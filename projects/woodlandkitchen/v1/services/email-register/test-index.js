const test = require('ava')
const micro = require('micro')
const listen = require('test-listen')
const service = micro(require('./'))
const request = require('request-promise')
const { withMailchimp, mockEmail } = require('./testhelpers')

test('subscribing works', async t => {
  const url = await listen(service)
  const email = mockEmail()
  await withMailchimp(async ({listId, groupIdOne, groupIdTwo}) => {
    const response = await request({
      method: 'POST',
      uri: url,
      body: {
        listId: listId,
        groupId: groupIdOne,
        emailAddress: email,
        firstName: 'test'
      },
      json: true,
      resolveWithFullResponse: true
    })
    // TODO what tests are relevant here? the service is just a thin wrapper
    // to the subscribe method.
    t.is(response.statusCode, 200)
  })
  service.close()
})

test('bad payloads send 400 with errors', async t => {
  const url = await listen(service)
  await withMailchimp(async ({listId, groupIdOne, groupIdTwo}) => {
    try {
      await request({
        method: 'POST',
        uri: url,
        body: {
          // listId: listId,
          groupId: groupIdOne,
          emailAddress: 'bad',
          firstName: 'test'
        },
        json: true,
        resolveWithFullResponse: true
      })
    } catch (error) {
      t.is(error.response.statusCode, 400)
      t.true(error.response.body.error)
    }
  })
  service.close()
})
