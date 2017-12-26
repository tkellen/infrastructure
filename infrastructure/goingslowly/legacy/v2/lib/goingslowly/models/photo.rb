module GS
  class Photo < Sequel::Model

    dataset_module do
      def byFlickrId(id)
        where(:f_id=>id)
      end
    end

    def link
      "#{CONFIG['url']['flickr']}/#{f_id}"
    end

    def cdn
      "http://img#{(id%2)}.goingslowly.com/photos";
    end

    def src(size=:normal)
      case size
        when :normal
          "#{cdn}/normal/#{f_id}.#{type}"
        when :thumb
          "#{cdn}/thumbnail/#{f_id}.#{type}"
        when :featured
          "#{cdn}/thumbnail/#{f_id}.#{type}"
        when :large
          "#{f_url_base}_b.jpg"
      end
    end

    def render(type)
      Media.renderPhoto(type, self)
    end

    def self.createFromFlickrAPI(photo, set_id)
      self.new({
        :f_id => photo.id.to_s,
        :name => photo.title,
        :date_taken => photo.dates.taken,
        :type => photo.originalformat,
        :f_url_base => FlickRaw.url_b(photo).gsub("_b.#{photo.originalformat}",""),
        :f_url_orig => FlickRaw.url_o(photo),
        :photo_set_id => set_id
      }).save()
    end

    def updateFromFlickrAPI(photo, set_id)
      update({
        :name => photo.title,
        :photo_set_id => set_id
      })
    end

    ##
    # Add cross-referencing links to flickr descriptions,
    # indicating what journals a photo has appeared in.
    #
    def setFlickrDescription
      # get photo info
      photo = flickr.photos.getInfo(:photo_id => f_id)

      if photo
        # get current description, less any automated data
        description = photo.description.split("\n---\n")[0]||""

        # get all journals where this photo appears
        journals = Journal.hasPhoto(f_id).all

        # make line entry for every journal this photo is featured in.
        entries = []
        journals.each do |journal|
          entries.push("<a href=\"#{CONFIG['url']['journal']}#{journal.href}\">#{journal.title}</a> (#{journal.date})")
        end

        # add automatic links if this photo appears in any journals
        if !entries.empty?
          description += "\n---\n\n<strong>Featured in the following journals:</strong>\n"
          description += entries.join("\n")
        end

        flickr.photos.setMeta(
          :photo_id => photo.id,
          :title => photo.title,
          :description => description
        )
      end
    end
  end
end
