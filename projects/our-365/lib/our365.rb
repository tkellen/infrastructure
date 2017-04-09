$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'sequel'
require 'sinatra/base'
require 'sinatra/contrib'
require 'slim'
require 'aws/s3'
require 'RMagick'
require 'exifr'
require 'json'
require 'base64'
require 'mailgun'

# prep linguistics gem
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
require 'linguistics'
Linguistics::use(:en)

# customize sequel model defaults
class Sequel::Model
  plugin :validation_helpers
  strict_param_setting = false
end

CONFIG = YAML::load(File.open('config/our365.yml'))
AUTH = YAML::load(File.open('config/auth.yml'))
DB = Sequel.connect(CONFIG['db'])
AWS::S3::Base.establish_connection!({
  :access_key_id => AUTH['aws']['access_key_id'],
  :secret_access_key => AUTH['aws']['secret_access_key']
})

# Connect to Mailgun
MGun = Mailgun({
  :api_key => AUTH['mailgun']['api_key'],
  :domain => AUTH['mailgun']['domain']
})

# Load helpers.
require 'our365/helpers/utils'
require 'our365/helpers/assets'
require 'our365/helpers/email'

# Load models.
require 'our365/models/member'
require 'our365/models/photo'

# Load sinatra.
require 'our365/app'

# Load controllers.
require 'our365/controllers/www'

