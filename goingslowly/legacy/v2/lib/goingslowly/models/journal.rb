require 'cgi'

module GS
  class Journal < Sequel::Model
    include Helpers
    many_to_one :photo
    many_to_one :author
    many_to_one :prefix
    many_to_one :rating
    many_to_many :topics, :class=> :'GS::Topic'
    many_to_many :widgets, :class=> :'GS::Widget'
    many_to_many :locations, :class=> :'GS::Location'
    one_to_many :comments, :class => :'GS::JournalComment'

    dataset_module do
      def published
        where(:published=>true).
        where{date_publish<=Sequel::CURRENT_DATE}
      end

      def publishedList
        published.
        eager_graph(:rating,:photo,:author,:prefix)
      end

      def countByMonth
        select("date_trunc('month', stamp)".lit.as(:month)).
        select_append{count(:*){}}.
        group(:month).
        order(:month.desc)
      end

      def byYear(year)
        publishedList.
        where("date_trunc('year',stamp)".lit=>"#{year}-01-01").
        order(:stamp.desc)
      end

      def byMonth(year, month)
        publishedList.
        where("date_trunc('month',stamp)".lit=>"#{year}-#{month}-01").
        order(:stamp.desc)
      end

      def next(stamp)
        where{|o| o.stamp > stamp}.
        order(:stamp).
        limit(1)
      end

      def prev(stamp)
        where{|o| o.stamp < stamp}.
        order(:stamp.desc).
        limit(1)
      end
    end

    def self.lookup(year, month, slug)
      lookup = "/#{year}/#{"%02d"%month.to_i}/#{slug}"
      published.where(:href=>lookup).first
    end

    def self.latest
      published.
      order(:stamp.desc).
      first
    end

    def self.hasPhoto(id)
      published.
      where(Sequel.ilike(:body,"%#{id}%")).
      order(:stamp)
    end

    def cacheLocations
      # get all valid topic/country urls for this entry
      urls = topics.map { |topic| topic.href+href }
      # get primary url
      urls.push(href)
      # add cache locations for above pages, as requested by AJAX
      urls.dup.each do |href|
        urls.push(href+"XMLHttpRequest")
      end
      # if this is the latest entry, clear journal home page too
      if id == self.class.latest.id
        urls.push('/')
      end
      urls
    end

    def next
      self.class.published.next(stamp)
    end

    def prev
      self.class.published.prev(stamp)
    end

    def nextInTopic(topic_id)
      Topic[:id=>topic_id].journals_dataset.next(stamp)
    end

    def prevInTopic(topic_id)
      Topic[:id=>topic_id].journals_dataset.prev(stamp)
    end

    def onThisDay
      self.class.published.
      where("date_part('month',stamp)::text||date_part('day',stamp)".lit=>stamp.strftime('%-m%-d')).
      exclude("date(stamp)".lit=>stamp.strftime('%Y-%m-%d')).
      order(:stamp)
    end

    def comments
      comments_dataset.published.order(:stamp)
    end

    def month
      stamp.strftime('%B')
    end

    def monthAbbr
      stamp.strftime('%b')
    end

    def day
      stamp.strftime('%-d')
    end

    def year
      stamp.strftime('%Y')
    end

    def ymd
      stamp.strftime('%Y-%m-%d')
    end

    def date
      stamp.strftime("%B #{ordinalize(stamp.strftime('%e'))}, %Y")
    end

    def pubDate
      stamp.strftime("%a, %e %b %Y %H:%M:%S %z")
    end

    def prefixedTitle
      if prefix.name == " "
        title
      else
        "#{prefix.name}: #{title}"
      end
    end

    def body
      Parser.process(@values[:body])
    end

    def rssTitle
      CGI::escapeHTML(title)
    end

    def synopsis
      content = @values[:body].gsub(/\[\{[^\|\]]*\}\]/,'').gsub(/\[\|[^\|\]]*\|\]/,'')
      Sanitize.clean(content)[0...250]+'...'
    end

    def context(xhr=false, topic=nil, search=nil)
      context = {}

      initEntry = {
        :year => year,
        :month => monthAbbr,
        :day => day,
        :href => href,
        :title => title,
        :id => id,
        # if xhr is flagged as true, the time tab
        # will be set after the entry is loaded
        :xhr => xhr,
      }

      if !search.nil?
        search_unescaped = CGI::unescape(search)
        context[:filedUnder] = {
          :name => search_unescaped,
          :href => "/search/#{search}"
        }
        context[:search] = true
        initEntry[:filedUnder] = search_unescaped
        initEntry[:highlight] = search_unescaped

        # skip next/prev entries in search context
        # TODO: make it possible to page through searches
      else
        # if no topic defined, get next/previous entry by date
        if topic.nil?
          prevEntry = self.prev.first
          nextEntry = self.next.first
        else
          # if topic defined, get next/previous entry in topic
          context[:filedUnder] = {
            :name => topic.name,
            :href => topic.href
          }
          initEntry[:filedUnder] = topic.name
          prevEntry = prevInTopic(topic.id).first
          nextEntry = nextInTopic(topic.id).first
        end
      end

      # configure previous entry
      if prevEntry
        initEntry[:prev] = {
          :title => prevEntry.title,
          :href => topic.nil? ? prevEntry.href : topic.href+prevEntry.href
        }
      end

      # configure next entry
      if nextEntry
        initEntry[:next] = {
          :title => nextEntry.title,
          :href => topic.nil? ? nextEntry.href : topic.href+nextEntry.href
        }
      end

      # get all entries that occured on this day over the years, if any
      if (onThisDay = self.onThisDay.all)
        context[:onThisDay] = onThisDay
      end

      # finalize context
      context.merge({
        :journal => self,
        :comments => self.comments.all,
        :initEntry => initEntry,
      })
    end
  end
end
