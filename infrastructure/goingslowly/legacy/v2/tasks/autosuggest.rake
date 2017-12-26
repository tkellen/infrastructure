task :autosuggest do
  require './lib/goingslowly'
  autosuggest = []
  GS::Topic.countries.all.each do |topic|
    autosuggest.push({
      :name => topic.name,
      :url => CONFIG['url']['journal']+topic.href,
      :prefix => "<strong>Country:</strong> "
    })
  end
  GS::Topic.topics.all.each do |topic|
    autosuggest.push({
      :name => topic.name,
      :url => CONFIG['url']['journal']+topic.href,
      :prefix => "<strong>Topic:</strong> "
    })
  end
  GS::Journal.published.order(:stamp).all.each do |journal|
    autosuggest.push({
      :name => journal.title,
      :url => CONFIG['url']['journal']+journal.href
    })
  end
  File.open("public/assets/autosuggest.js","w+") do |file|
    file.write("window.gs = gs = window.gs || {};\ngs.autosuggest = #{autosuggest.reverse.to_json}")
  end
end
