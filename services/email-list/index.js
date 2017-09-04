const { send, json, sendError } = require('micro')

const { subscribe } = require('./mailchimp');

module.exports = async (req, res) => {
  try {
    const payload = await json(req)
    const result = await subscribe(payload)
    return send(res, 200, payload)
  } catch(err) {
    return send(res, 500, 'No good.')
  }
}
