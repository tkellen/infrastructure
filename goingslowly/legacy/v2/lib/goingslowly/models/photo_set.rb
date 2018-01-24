module GS
  class PhotoSet < Sequel::Model

    def self.createFromFlickrAPI(set)
      self.new({
        :f_set_id => set.id.to_s,
        :name => set.title
      }).save()
    end

  end
end
