const crypto = require('crypto')
module.exports = input => {
  return crypto.createHash('md5').update(input).digest('hex')
}
