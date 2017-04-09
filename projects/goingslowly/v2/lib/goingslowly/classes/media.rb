require 'RMagick'
require 'digest/sha1'

module GS
  class Media

    ##
    # Use Tilt to render a photo model.
    #
    def self.renderPhoto(type, photo)
      if photo.nil?
        photo = Photo[:id=>1]
      end
      template = Tilt.new("lib/goingslowly/views/_photo_#{type}.slim")
      template.render(nil, :item => photo)
    end

    ##
    # Use Tilt to render a media object.
    #
    def self.renderElement(type, media)
      template = Tilt.new("lib/goingslowly/views/_media_#{type}.slim")
      template.render(nil, :item => media)
    end

    ##
    # Resize a photo blob and return a blob.
    #
    def self.resizePhoto(blob, width, type)
      hash = Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      tmp = "tmp/#{hash}.#{type}"
      Magick::Image.from_blob(blob).first.resize_to_fit(width).sharpen(0,0.5).write(tmp) {
        self.interlace = Magick::PlaneInterlace
        self.quality = 85
      }

      # Force garbage collection so ruby doesn't blow up.
      GC.start
      # Nice work, ruby.

      case type
        when 'jpg'
          `jpegoptim --preserve --strip-com --strip-exif --strip-iptc #{tmp}`
        when /png$/i
          `optipng #{tmp}`
      end
      result = File.read(tmp)
      File.delete(tmp)
      result
    end

  end
end
