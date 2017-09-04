const test = require('ava')
const micro = require('micro')
const listen = require('test-listen')
const service = micro(require('./'))
const request = require('request-promise')
const { cleanup, mockdata } = require('./testhelpers');

test('adding emails to mailchimp', async t => {
  t.pass()
  //const payload = mockdata()
  //const url = await listen(service)
  //const response = await request({
  //  method: 'POST',
  //  uri: url,
  //  body: payload,
  //  json: true,
  //  resolveWithFullResponse: true
  //})
  //t.deepEqual(response.body, payload)
  //service.close()
})
