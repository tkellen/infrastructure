module DailyShare
  module Helpers
    ##
    #
    # Render a partial template using slim
    #
    # @param [String] template
    #   Path to template.
    # @param [Hash] args
    #   Hash of options for generating a template.
    # @return [String]
    #   Parsed template html.
    #
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:layout => false)
      locals = options[:locals] || {}
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << slim(:"#{template}", options.merge(:layout =>
          false, :locals => { :item => member }.merge(locals)))
        end.join("\n")
      else
        slim(:"#{template}", options)
      end
    end

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    ##
    #
    # Find the ordinal suffix for a number.
    #
    # @param [Integer] number
    #   A number to be ordinalize
    # @return [String]
    #   An ordinalized number (e.g. 3 => 3rd)
    #
    def ordinalize(number)
      if (11..13).include?(number.to_i.abs % 100)
        "#{number}th"
      else
        case number.to_i.abs % 10
          when 1; "#{number}st"
          when 2; "#{number}nd"
          when 3; "#{number}rd"
          else    "#{number}th"
        end
      end
    end

    def authorized?
      return true if !session[:member_id].nil?

      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      if @auth.provided? && @auth.basic? &&
         @auth.credentials && @auth.credentials[1] == AUTH['pass'] &&
         (member = Member.byName(@auth.credentials[0]))
            session[:member_id] = member.id
            session[:member_name] = member.name
      end
    end

    def date_from_params(params)
      if params[:y] && params[:m] && params[:d]
        Date.parse("#{params[:y]}-#{params[:m]}-#{params[:d]}")
      else
        Date.today
      end
    end

    def valid_date?(date)
      (date.year > 2011 || date <= Date.today)
    end

    def context_from_date(date)
      edition = (date.strftime('%Y').to_i)-(CONFIG['dailyshare']['start'].strftime('%Y').to_i)
      {
        :ymd => date.strftime('%Y-%m-%d'),
        :date => date,
        :year => (edition+1).en.numwords,
        :count => (((date-CONFIG['dailyshare']['start']).to_i)-((edition)*365).to_i).en.numwords,
        :members => Member.order(:id).all
      }
    end

    def prev_entry(date)
      (date-1).strftime('/%Y/%m/%d/')
    end

    def next_entry(date)
      (date+1).strftime('/%Y/%m/%d/')
    end

    def save_photo(params, file)
      begin
        photo = Photo.new
        photo.set_fields(params, [:title, :description, :date_added, :member_id])
        puts photo.inspect
        photo.save_original(file)
        photo.generate_sizes
        photo.save_to_s3
      rescue
        false
      else
        photo.save
        sendEmail(
          CONFIG['email']['to'],
          "new submisson",
          slim(:'emails/uploaded', {:locals=>{:photo=>photo},:layout=>false})
        )
      end
    end
  end
end
