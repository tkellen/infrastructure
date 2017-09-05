/* const test = require('ava')
const micro = require('micro')
const listen = require('test-listen')
const service = micro(require('./'))
const request = require('request-promise')

test('piping emails from urls to s3', async t => {
  const url = await listen(service)
  const response = await request({
    method: 'POST',
    uri: url,
    body: {
      uri: 'https://farm5.staticflickr.com/4179/34274401882_01f84d6577_z_d.jpg',
      size: 400,
      bucket: 'aevitas',
      key: 'test.jpg'
    },
    json: true,
    resolveWithFullResponse: true
  })
  // TODO what tests are relevant here? the service is just a thin wrapper
  // to the subscribe method.
  t.is(response.statusCode, 200)
  service.close()
}) */
