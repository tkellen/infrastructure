const mailgun = require('mailgun-js');
const auth = require('../../config/auth.js');

module.exports = mailgun(auth.mailgun.api_key, auth.mailgun.domain).messages;
