module GS
  class App < Sinatra::Base
    subdomain :journal do

      ##
      # Main journal page, show most current entry.
      #
      get '/' do
        slim :journal_entry, {
          :layout => :layout_journal,
          :locals => Journal.latest.context(request.xhr?)
        }
      end

      ##
      # Journal entry page.  If request is XHR, respond with
      # the entry only (for slide effect), otherwise respond
      # with the entire page layout.
      #
      get %r{^/(?<year>20\d{2})/(?<month>\d{2})/(?<slug>[\w-]*)/?(?<junk>.*)$} do

        journal = Journal.lookup(params[:year],params[:month],params[:slug])
        pass if journal.nil?

        # hack off any extra junk from url and redirect to entry
        if !params[:junk].empty?
          noCache
          if params[:junk] == "clearcache"
            journal.cacheLocations.each do |url|
              MC.delete(request.host+url)
            end
          end
          redirect "/#{params[:year]}/#{params[:month]}/#{params[:slug]}", 301
        end

        slim :journal_entry, {
          :layout => request.xhr? ? false : :layout_journal,
          :locals => journal.context(request.xhr?)
        }
      end

      ##
      # Journal topic and country listings.
      # TODO: implement pagination?
      #
      get %r{^/(topic|country)/(?<topic>.*)$} do
        topic = Topic.byName(params[:topic]).first

        # redirect to search for topics that don't exist
        if topic.nil?
          redirect "/search/#{params[:topic]}"
        end

        # ensure country topics appear on country pages
        if topic.isCountry? && request.path_info[1] == "t"
          redirect "/country/#{params[:topic]}", 301
        end

        journals = topic.journals.order(:stamp.desc).all

        slim :journal_topic, {
          :layout => :layout_journal,
          :locals => {
            :topic => topic,
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Journal entry page, as viewed under a topic or country section.
      #
      get %r{^/(topic|country)/(?<topic>.*)/(?<year>20\d{2})/(?<month>\d{2})/(?<slug>[\w-]*)/?(?<junk>.*)$} do

        # hack off any extra junk from url and redirect to entry
        if !params[:junk].empty?
          redirect "/topic/#{params[:topic]}/#{params[:year]}/#{params[:month]}/#{params[:slug]}", 301
        end

        topic = Topic.byName(params[:topic]).first
        if topic.nil?
          redirect "/#{params[:year]}/#{params[:month]}/#{params[:slug]}", 301
        end

        # ensure country topics appear on country pages
        if topic.isCountry? && request.path_info[1] == "t"
          redirect "/country/#{params[:topic]}/#{params[:year]}/#{params[:month]}/#{params[:slug]}", 301
        end

        journal = Journal.lookup(params[:year],params[:month],params[:slug])
        pass if journal.nil?

        slim :journal_entry, {
          :layout => request.xhr? ? false : :layout_journal,
          :locals => journal.context(request.xhr?, topic)
        }

      end

      ##
      # Journals listed by rating.
      #
      get '/rating/:rating' do
        rating = Rating.byName(params[:rating]).first
        pass if rating.nil?

        journals = rating.journals.order(:stamp.desc).all

        slim :journal_rating, {
          :layout => :layout_journal,
          :locals => {
            :rating => rating,
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Journals listed by month.
      #
      get %r{^/(?<year>20\d{2})/(?<month>\d{2})$} do
        journals = Journal.byMonth(params[:year],params[:month]).all
        pass if journals.nil?

        slim :journal_datelist, {
          :layout => :layout_journal,
          :locals => {
            :display => journals.first.stamp.strftime("%B, %Y"),
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Journals listed by year.
      #
      get %r{^/(?<year>20\d{2})$} do
        journals = Journal.byYear(params[:year]).all
        pass if journals.nil?

        slim :journal_datelist, {
          :layout => :layout_journal,
          :locals => {
            :display => params[:year],
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Journals listed by bookmarks
      #
      get '/bookmarks' do
        noCache
        bookmarks = request.cookies['bookmarks']
        if bookmarks
          bookmarks = bookmarks.split(',').map { |mark| mark.to_i }
          journals = Journal.publishedList.
                             where(:journal__id=>bookmarks).
                             order(:stamp.desc).all
        else
          journals = []
        end

        slim :journal_bookmarks, {
          :layout => :layout_journal,
          :locals => {
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Search Sphinx database and display results.
      # TODO: implement pagination?
      #
      get '/search/:query' do

        # redirect searches for topics/countries to topic/country page
        topic = Topic.byName(params[:query]).first
        if !topic.nil?
          redirect topic.href
        end

        matches = Search.query(params[:query])
        if matches.empty?
          journals = []
        else
          journals = Journal.publishedList.where(:journal__id=>matches).order(:stamp.desc).all
        end

        slim :journal_search, {
          :layout => :layout_journal,
          :locals => {
            :journals => journals,
            :count => journals.length
          }
        }
      end

      ##
      # Receive, sanitize and redirect to SEO-friendly url.
      #
      post '/search' do
        redirect "/search/#{Search.sanitize(params[:search])}"
      end

      ##
      # Journal entry page, as viewed with a search.
      #
      get %r{^/search/(?<query>.*)/(?<year>20\d{2})/(?<month>\d{2})/(?<slug>[\w-]*)$} do
        noCache
        journal = Journal.lookup(params[:year],params[:month],params[:slug])
        pass if journal.nil?
        slim :journal_entry, {
          :layout => request.xhr? ? false : :layout_journal,
          :locals => journal.context(request.xhr?, nil, params[:query])
        }
      end

      ##
      # Redirect ancient search urls from blogger.
      #
      get '/search/label/:query' do
        redirect "/search/#{params[:query]}", 301
      end

      ##
      # Receive and store comments for any journal entry, invalidating
      # all possible pages that could be cached to ensure the comment
      # appears immediately.
      #
      post '/comment' do

        # create journal comment
        comment = JournalComment.new(params[:comment])

        if comment.journal.nocomments
          pass
        end

        honeypotFilled = params[:age].to_i != 0
        timerViolated = (params[:timer].to_i == 0 || params[:timer].to_i+30 > Time.now.to_i)
        humanCheckboxEmpty = params[:check].nil?

        if humanCheckboxEmpty || honeypotFilled || timerViolated || isSpam?(request, params[:comment])
          if humanCheckboxEmpty || honeypotFilled || timerViolated
            #sendEmail('tyler@sleekcode.net', 'spam thwarted', "honeypot: #{honeypotFilled}\ntimer: #{timerViolated}")
          end
          halt 401
        end

        begin
          comment.save()
          # send email notifications for this comment
          comment.notify.each do |email|
            begin
              sendEmail(email, 'Going Slowly Comment', comment.email)
            rescue

            end
          end
          # notify us of all comments
          sendEmail('us@goingslowly.com', 'Going Slowly Comment', comment.email+request.inspect)

          # clear all possible cache locations for this journal
          comment.journal.cacheLocations.each do |url|
            cacheClear(request.host+url)
          end
          # redirect back to page.
          formRedirect(request.referrer)
        rescue
          formError(comment.errors)
        end
      end

      ##
      # Display RSS feed.
      #
      get '/rss/?' do
        noCache
        content_type 'application/rss+xml'
        slim :rss, {
          :layout => false,
          :locals => {
            :entries => Journal.published.order(:stamp.desc).limit(25).all
          }
        }
      end

      ##
      # Redirect ancient RSS url from blogger.
      #
      get '/feeds/posts/default' do
        redirect '/rss', 301
      end

    end
  end
end
