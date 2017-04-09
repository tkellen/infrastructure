module GS
  module Helpers
    ##
    # Instruct Rack to clear a cached page during the current request.
    #
    # @param [String] path
    #   Relative path to page URL
    #
    def cacheClear(key=nil)
      key = "#{request.host}#{request.path_info}" if key.nil?
      (request.env['cacheClear'] ||= []).push(key)
    end

    ##
    # Instruct Rack not to cache the current request.
    #
    def noCache
      request.env['nocache'] = true
    end
  end
end

module Rack
  class Cache
    def initialize(app)
      @app = app
    end
    ##
    # Build a key to store this request's response in memcached.
    # AJAX requests may deliver different content than standard
    # requests, so include that in the key as well.
    #
    # nginx will try to find these entries using memcached_pass
    # before hitting the ruby process.
    #
    def key(env)
      "#{env['SERVER_NAME']}#{env['PATH_INFO']}#{env['HTTP_X_REQUESTED_WITH']}"
    end

    ##
    # Store the response of a request in memcached.
    #
    def call(env)
      status, headers, response = @app.call(env)

      # Confirm if we should actually cache this page.
      # Ignore assets, which are ultimately delivered from CloudFront.
      if status == 200 &&
         env['REQUEST_METHOD'] == 'GET' &&
         env['nocache'].nil? &&
         env['PATH_INFO'][0..7] != "/assets/"
        begin
          MC.set(key(env),response.join("\n"),nil,:raw=>true)
        rescue
        end
      end
      # If the environment includes an array of keys to clear, do so
      # before this request is fullfilled.
      if env['cacheClear'] && env['cacheClear'].kind_of?(Array)
        begin
          env['cacheClear'].each { |k| MC.delete(k) }
        rescue
        end
      end
      [status, headers, response]
    end
  end
end
