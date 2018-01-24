task :syncset do
  require 'open-uri'
  require './lib/goingslowly'
  require './lib/goingslowly/classes/s3'

  begin
    # get cli arguments
    set_id = ENV['id']
    cdn = !ENV['cdn'].nil?

    # find set
    flickrSet = flickr.photosets.getInfo(:photoset_id=>set_id)

    # get set from database
    set = GS::PhotoSet[:f_set_id=>flickrSet.id.to_s]

    # if set isn't in database, add it
    set = GS::PhotoSet.createFromFlickrAPI(flickrSet) if set.nil?

    # sync
    sync_set(set, cdn)
  rescue
    puts "Set #{ENV['id']} not found."
  end
end

def sync_set(set, syncToCDN)

  # clear any photos that didn't finish uploading
  GS::Photo.where(:uploaded=>false,:uploading=>true).update(:uploading=>false)

  # connect to s3
  s3 = GS::S3.new

  # photos in defined set
  photos = flickr.photosets.getPhotos(:photoset_id=>set.f_set_id).photo

  # iterate photos and save them to s3
  photos.each do |photo|

    # get photo from flickr
    flickrPhoto = flickr.photos.getInfo(:photo_id=>photo.id)

    # get photo from database
    photo = GS::Photo[:f_id=>flickrPhoto.id.to_s]

    # if photo isn't in database, add it
    photo = GS::Photo.createFromFlickrAPI(flickrPhoto, set.id) if !photo

    # update photo title
    photo.update(:name=>flickrPhoto.title)

    # update references to which journal this appeared
    photo.setFlickrDescription

    if syncToCDN

      if !photo.uploaded

        # flag image as beginning upload
        photo.update(:uploading=>true)

        # read photo from flickr
        puts "Reading #{photo.f_url_orig}..."
        blob = open(photo.f_url_orig).read
        bucket = 's3.goingslowly.com'
        filename = "#{photo.f_id}.#{photo.type}"

        # store thumbnail
        s3.save({
          :name => "photos/thumbnail/#{filename}",
          :blob => GS::Media.resizePhoto(blob, 192, photo.type),
          :bucket => bucket,
          :access => :public_read
        })

        # store normal size
        s3.save({
          :name => "photos/normal/#{filename}",
          :blob =>  GS::Media.resizePhoto(blob, 783, photo.type),
          :bucket => bucket,
          :access => :public_read
        })

        # flag image as uploaded to cdn
        photo.update(:uploading=>false,:uploaded=>true)

      end
    end
  end
end
