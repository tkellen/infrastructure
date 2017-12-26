task :syncall do
  require 'open-uri'
  require './lib/goingslowly'
  require './lib/goingslowly/classes/s3'
  include GS

  # open connection to S3
  S3 = S3.new

  # clear any photos that didn't finish uploading
  Photo.where(:uploaded=>false,:uploading=>true).update(:uploading=>false)

  # iterate photos and save them to s3
  while Photo.where(:uploaded=>false).count != 0

    # get next photo that hasn't been uploaded
    img = Photo.where(:uploaded=>false,:uploading=>false).order(:id).first
    img.update(:uploading=>true)

    # prep photo data
    photo = flickr.photos.getInfo(:photo_id=>img.f_id)
    url = FlickRaw.url_o(photo)
    type = photo.originalformat
    filename = "#{photo.id}.#{type}"

    # read photo from flickr
    puts "Reading #{url}..."
    blob = open(url).read

    # store thumbnail
    S3.save({
      :name => "photos/thumbnail/#{filename}",
      :blob => GS::Media.resizePhoto(blob, 192, type),
      :bucket => 's3.goingslowly.com',
      :access => :public_read
    })

    # store normal size
    S3.save({
      :name => "photos/normal/#{filename}",
      :blob =>  GS::Media.resizePhoto(blob, 783, type),
      :bucket => 's3.goingslowly.com',
      :access => :public_read
    })

    # store doubled size (for retina display)
    #S3.save({
    #  :name => "photos/doubled/#{name}",
    #  :blob =>  GS::Media.resizePhoto(blob, 1566, type),
    #  :bucket => 's3.goingslowly.com',
    #  :access => :public_read
    #})

    img.update(:uploaded=>true,:uploading=>false)
  end
end
