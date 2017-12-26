module DailyShare

  class App < Sinatra::Base

    get '/' do
      context = context_from_date(Date.today)
      @title = "#{CONFIG['seo']['title']} - day #{context[:count]}"
      slim :index, :locals => context
    end

    get '/:y/:m/:d' do
      begin
        date = date_from_params(params)
        context = context_from_date(date)
        @title = "#{CONFIG['seo']['title']} - day #{context[:count]}"
      rescue
        pass
      end

      if valid_date?(date)
        slim :index, :locals => context
      else
        redirect request.referrer
      end
    end

    get '/admin' do
      protected!
      redirect '/'
    end

    get '/:name' do
      if (member = Member.byName(params[:name])).nil?
        redirect request.referrer
      end

      slim :member, :locals => { :member => member }
    end

    get '/:name/missing' do
      if (member = Member.byName(params[:name])).nil?
        redirect request.referrer
      end
      slim :member_missing, :locals => { :photos => member.missingPhotos }
    end

    get '/logout' do
      session.delete(:member_id)
      session.delete(:member_name)
      status 401
      slim :logout
    end

    post '/upload' do
      protected!
      if params[:file]
        save_photo(params, params[:file][:tempfile])
      end
      redirect request.referrer
    end

    post '/edit' do
      protected!
      puts params

      photo = Photo[:id=>params[:photo_id]]
      if photo
        photo.update_fields(params, [:title, :description])
      end

      redirect request.referrer
    end

    ##
    # Receive emailed photos via Postmark.
    #
    post '/receiver' do
      # parse post data
      data = JSON.parse(request.body.read)

      # grab image data
      image = data['Attachments'][0]['Content']

      # check which member this is based on sender
      member = Member[:email=>data['From']]

      # was there a member with that email?
      if !member.nil?

        # get most recent photo
        recent = member.mostRecentPhoto

        # only continue if a photo doesn't exist for today
        if !recent.nil? && recent.date_added+1 <= Date.today

          # prep params for submission
          params = {
            :member_id => member.id,
            :title => data['Subject'],
            :description => data['TextBody'],
            :date_added => recent.date_added+1
          }
          save_photo(params,StringIO.new(Base64.decode64(image)))
        end
      end
    end

  end

end
