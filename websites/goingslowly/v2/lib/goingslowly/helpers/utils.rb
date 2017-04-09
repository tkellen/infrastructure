require 'mail'
require 'date'

module GS
  module Helpers

    ##
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

    ##
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

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      return true if !session[:authorized].nil?

      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      if @auth.provided? &&
         @auth.basic? &&
         @auth.credentials &&
         @auth.credentials[0] == AUTH['user'] &&
         @auth.credentials[1] == AUTH['pass']
         session[:authorized] = true
      end
    end

    ##
    # Find the number of days in a month.
    #
    # @param [Integer] year
    #   The year.
    # @param [Integer] month
    #   The month.
    # @return [Integer]
    #   The number of days in the requested month.
    #
    def days_in_month(year, month)
      (Date.new(year, 12, 31) << (12-month)).day
    end
  end
end
