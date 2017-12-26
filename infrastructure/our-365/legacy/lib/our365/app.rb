module DailyShare
  class App < Sinatra::Base

    configure do
      set :root, File.dirname(__FILE__)
      set :public_folder, settings.root+'/../../public'
      # configure photo upload directory
      CONFIG['photo_dir'] = settings.public_folder+'/photos/'
      # make photos directory if it doesn't already exist
      Dir.mkdir CONFIG['photo_dir'] unless Dir.exists? CONFIG['photo_dir']
      helpers Sinatra::ContentFor
      helpers DailyShare::Helpers
    end

    ##
    # Static files are delivered by nginx in production.
    #
    configure :production do
      set :static, false
    end

    ##
    # Prevent trailing slashes and rewrite cachebusted urls for
    # css/js.  These rewrites are handled by nginx in production.
    #
    configure :development do
      require 'rack-rewrite'
      use Rack::Rewrite do
        rewrite %r{^/assets/cb?(.[^\/]*)/(.*)}, '/assets/$2'
        r301 %r{^/(.*)/$}, '/$1'
      end
      require 'logger'
      DB.logger = Logger.new($stdout)
    end

    ##
    # Set page title and description site-wide (overriden at the route level)
    #
    before do
      @title = CONFIG['seo']['title']
      @description = CONFIG['seo']['description']
    end

  end
end
