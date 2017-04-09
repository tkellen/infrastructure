module GS
  module Helpers

    ##
    # Generate a cache-busted URL for assets.
    #
    # @param [String] url
    #   URL to asset.
    # @return [String]
    #   URL to asset with cache-busting string added.
    #
    def assetPath(url)

      file = File.join(settings.public_folder,'assets',url)
      if File.exists?(file)
        cachebust = File.mtime(file).strftime('%s')
        url = "cb#{cachebust}/#{url}"
      end

      if ENV['RACK_ENV'] == 'production'
        "#{CONFIG['url']['cdn']}/assets/#{url}"
      else
        "/assets/#{url}"
      end
    end

  end
end
