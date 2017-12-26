require "stringio"

module DailyShare
  class Photo < Sequel::Model
    many_to_one :member

    def before_save
      description.strip!
    end

    def file(size)
      case size
        when :original
          "#{date_added}-#{member.name}.jpg"
        when :thumb
          "#{date_added}-#{member.name}-thumb.jpg"
        when :big
          "#{date_added}-#{member.name}-big.jpg"
      end
    end

    def url(size)
      "#{CONFIG['url']['cdn']}/photos/#{file(size)}"
    end

    def save_original(tmpfile)
      image = File.join(CONFIG['photo_dir'],file(:original))
      File.open(image,'wb') {|f| f.write(tmpfile.read) }
      image
    end

    def generate_sizes
      img = Magick::Image::read(File.join(CONFIG['photo_dir'],file(:original))).first
      if img
        img.resize_to_fit(240,240).write(File.join(CONFIG['photo_dir'],file(:thumb)))
        img.resize_to_fit(960,680).write(File.join(CONFIG['photo_dir'],file(:big)))
        img.destroy!
        true
      else
        false
      end
    end

    def sizes
      [File.join(CONFIG['photo_dir'],file(:original)),
       File.join(CONFIG['photo_dir'],file(:thumb)),
       File.join(CONFIG['photo_dir'],file(:big))]
    end

    def save_to_s3
      sizes.each do |file|
        AWS::S3::S3Object.store(
          "/photos/#{File.basename(file)}",
          open(file),
          AUTH['aws']['bucket'],
          {
            :cache_control => 'max-age=315360000',
            :access => 'public_read'
          }
        )
      end
    end

    def parse_exif
      img = EXIFR::JPEG.new(file)

      # store fstop/focal length for comparison
      fstop = img.exif[:f_number].to_f
      flen = img.exif[:focal_length].to_f

      {
        # if no decimal is needed, leave it off
        :fstop => (fstop == fstop.to_i ? fstop.to_i : fstop),
        # convert exposure to string
        :exposure => img.exif[:exposure_time].to_s,
        # if no decimal is needed, leave it off
        :focal_length => (flen == flen.to_i ? flen.to_i : flen).to_s+'mm'
      }
    end

  end
end
