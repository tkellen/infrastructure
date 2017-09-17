require('dotenv').config()

module.exports = {
  mailchimp_api_key: process.env.mailchimp_api_key,
  port: process.env.PORT || 3000
}
