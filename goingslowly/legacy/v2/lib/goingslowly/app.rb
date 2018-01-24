module GS
  class App < Sinatra::Base
    ##
    # Configure Sinatra for development and production.
    #
    configure do
      set :root, File.dirname(__FILE__)
      set :public_folder, File.join(settings.root,'/../../public')
      set :protection, :except => :frame_options

      # give access to content_for helper
      register Sinatra::Contrib
      # segregate routes by subdomain
      register Sinatra::Subdomain
      # custom helpers
      helpers GS::Helpers
      # register custom memcached interface
      use Rack::Cache
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

    ##
    # Handle 404 pages
    #
    not_found do
      if Fourohfour[:url=>request.path].nil?
        miss = Fourohfour.new(:url=>request.host+request.path,:referrer=>request.referrer)
        miss.save
      end
      miss = Fourohfour[:url=>request.host+request.path]
      miss.count = miss.count+1
      miss.save
      slim :'404'
    end
  end
end
