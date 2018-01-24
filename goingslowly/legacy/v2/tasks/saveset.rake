task :saveset, :set_id do |t, args|
  require 'open-uri'
  require './lib/goingslowly'
  require 'fileutils'
  set_id = args[:set_id]
  if set_id.nil?
    puts "Please define a set."
  else
    photos = flickr.photosets.getPhotos(:photoset_id=>set_id).photo
    FileUtils.rm_rf(set_id)
    Dir.mkdir(set_id)
    photos.each do |photo|
      flickrPhoto = flickr.photos.getInfo(:photo_id=>photo.id)
      file = "#{set_id}/#{photo.id}.#{flickrPhoto.originalformat}"
      puts "Saving #{file}..."
      File.write(file, open(FlickRaw.url_o(flickrPhoto)).read)
    end
  end
end
