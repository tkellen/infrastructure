$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Load dependencies
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/subdomain'
require 'pg'
require 'sequel'
require 'sequel-noinflectors'
require 'slim'
require 'dalli'
require 'kgio'
require 'sanitize'
require 'flickraw-cached'
require 'riddle'
require 'riddle/2.0.1'
require 'soundcloud'
require 'twitter'
require 'mail'
require 'mailgun'
require 'akismet'

# Load configs
CONFIG = YAML::load(File.open('config/goingslowly.yml'))
AUTH = YAML::load(File.open('config/auth.yml'))

# Connect to databases
Sequel.extension(:core_extensions)
DB = Sequel.connect(CONFIG['db'])
MC = Dalli::Client.new('localhost:11211',{:compress=>true,:compressor=>Dalli::GzipCompressor})

# Configure sphinx search client
SPHINX = Riddle::Client.new(CONFIG['sphinx']['host'],CONFIG['sphinx']['port'])
SPHINX.match_mode = CONFIG['sphinx']['match_mode'].to_sym
SPHINX.limit = CONFIG['sphinx']['limit']

# Spool up twitter integration
TW = Twitter::REST::Client.new do |config|
  config.consumer_key = AUTH['twitter']['consumer_key']
  config.consumer_secret = AUTH['twitter']['consumer_secret']
  config.access_token = AUTH['twitter']['access_token']
  config.access_token_secret = AUTH['twitter']['access_token_secret']
end

# Spool up flickr integration.
FlickRaw.api_key = AUTH['flickr']['api_key']
FlickRaw.shared_secret = AUTH['flickr']['shared_secret']
flickr.access_token = AUTH['flickr']['access_token']
flickr.access_secret = AUTH['flickr']['access_secret']

# Connect to Soundcloud
SC = Soundcloud.new(:client_id=>AUTH['soundcloud']['client_id'])

# Connect to Mailgun
MGun = Mailgun({
  :api_key => AUTH['mailgun']['api_key'],
  :domain => AUTH['mailgun']['domain']
})

SpamCheck = Akismet::Client.new(AUTH['akismet']['key'],AUTH['akismet']['domain'])

# Load helpers.
require 'goingslowly/helpers/utils'
require 'goingslowly/helpers/assets'
require 'goingslowly/helpers/forms'
require 'goingslowly/helpers/email'
require 'goingslowly/helpers/core_ext'
require 'goingslowly/helpers/context'
require 'goingslowly/helpers/journal'

# Load classes.
require 'goingslowly/classes/flickr'
require 'goingslowly/classes/parser'
require 'goingslowly/classes/media'
require 'goingslowly/classes/search'
require 'goingslowly/classes/cache'

# Load models.
require 'goingslowly/models/news'
require 'goingslowly/models/photo'
require 'goingslowly/models/photo_set'
require 'goingslowly/models/member'
require 'goingslowly/models/prefix'
require 'goingslowly/models/section'
require 'goingslowly/models/topic'
require 'goingslowly/models/author'
require 'goingslowly/models/rating'
require 'goingslowly/models/widget'
require 'goingslowly/models/journal'
require 'goingslowly/models/journal_comment'
require 'goingslowly/models/letter'
require 'goingslowly/models/location'
require 'goingslowly/models/track'
require 'goingslowly/models/track_point'
require 'goingslowly/models/newsletter'
require 'goingslowly/models/email'
require 'goingslowly/models/fourohfour'

# Load sinatra.
require 'goingslowly/app'

# Load controllers.
require 'goingslowly/controllers/www'
require 'goingslowly/controllers/journal'
require 'goingslowly/controllers/map'
require 'goingslowly/controllers/admin'
require 'goingslowly/controllers/workshops'
