const { send, json } = require('micro')

const { subscribe } = require('./mailchimp')

module.exports = async (req, res) => {
  try {
    const payload = await json(req)
    const result = await subscribe(payload)
    return send(res, result.error ? 500 : 200, result)
  } catch (err) {
    return send(res, 500, err)
  }
}
