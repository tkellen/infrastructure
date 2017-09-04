const test = require('ava')
const micro = require('micro')
const listen = require('test-listen')
const service = micro(require('./'))
const request = require('request-promise')
const { withMailchimp, mockEmail } = require('./testhelpers');

test('adding emails to mailchimp', async t => {
  const url = await listen(service)
  const email = mockEmail()
  await withMailchimp(async ({list_id, group_id_one, group_id_two}) => {
    try {
      const response = await request({
        method: 'POST',
        uri: url,
        body: {
          list_id: list_id,
          group_id: group_id_one,
          email_address: email,
          first_name: 'test'
        },
        json: true,
        resolveWithFullResponse: true
      })
    } catch (e) {
      throw e;
    }
    t.pass()
  })
  service.close()
/*

  } catch (e) {
    console.log(e)
  }*/
})
