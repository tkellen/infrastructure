module GS
  class Flickr

    TTL = 3600

    ##
    # Get a list of flickr sets, from cache if possible.
    #
    def self.sets
      key = 'flickr.photoset.getList'
      sets = nil
      begin
        sets = MC.get(key)
        if sets.nil?
          sets = flickr.photosets.getList(:user_id => AUTH['flickr']['id'])
        end
        MC.set(key, sets, TTL)
      rescue
      end
      sets
    end

    ##
    # Get a list of flickr collections, from cache if possible.
    #
    def self.collections
      key = 'flickr.collections.getTree'
      collections = nil
      begin
        collections = MC.get(key)
        if collections.nil?
          collections = flickr.collections.getTree(:user_id => AUTH['flickr']['id'])
        end
        MC.set(key, collections, TTL)
      rescue
      end
      collections
    end

    ##
    # Get photo set info.
    #
    def self.setInfo(id=nil)
      begin
        set = flickr.photosets.getInfo(:photoset_id=>id)
      rescue
        set = {}
      end
      set
    end

    ##
    # Get a photos in a set.
    #
    def self.photosInSet(id=nil)
      begin
        # get most recent set if none is defined
        id = self.sets[0].id if id.nil?
        flickr.photosets.getPhotos(:photoset_id=>id).photo
      rescue
        []
      end
    end

    ##
    # Get a recently uploaded photos.
    #
    def self.recentPhotos
      begin
        flickr.photos.search(:user_id => AUTH['flickr']['id']).map { |photo| photo.id }
      rescue
        []
      end
    end

  end
end
