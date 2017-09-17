const port = process.env.PORT || 3000
const dev = process.env.NODE_ENV !== 'production'

const { parse } = require('url')
const micro = require('micro')
const match = require('micro-route/match')
const next = require('next')

const app = next({ dev })
const handle = app.getRequestHandler()

// TODO: extract this to a standalone service
const emailRegister = require('./services/email-register')

const server = micro(async (req, res) => {
  const parsedUrl = parse(req.url, true)
  if (match(req, '/email-register')) {
    return emailRegister(req, res)
  }
  return handle(req, res, parsedUrl)
})

app.prepare().then(() => {
  server.listen(port, err => {
    if (err) {
      throw err
    }
    console.log(`> Ready on http://localhost:${port}`)
  })
})
