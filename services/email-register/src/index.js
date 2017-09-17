const validator = (new (require('ajv'))())
const check = validator.compile(require('./schema'))

const { send, json } = require('micro')

const { subscribe } = require('./mailchimp')

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    return send(res, 501)
  }
  try {
    const payload = await json(req)
    const valid = check(payload)
    if (!valid) {
      return send(res, 400, {
        error: true,
        message: check.errors
      })
    }
    const result = await subscribe(payload)
    return send(res, result.error ? 500 : 200, result)
  } catch (err) {
    return send(res, 500, err)
  }
}
