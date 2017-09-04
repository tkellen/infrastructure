const { api_key } = require('./config')
const md5 = require('./md5')

const MailChimp = require('mailchimp-api-v3')

function client() {
  try {
    return new MailChimp(api_key);
  }
  catch (err) {
    // TODO: replace with something where the email will get saved
    // to a service we know is alive.
    throw new Error("Unable to create mailchimp client.")
  }
}

async function status(payload) {
  return await client().get(
    `/lists/${payload.list_id}/members/${md5(payload.email_address)}`
  )
}

async function subscribe(payload) {
  let state = 'pending';
  let response = 'waiting-on-approval';
  let existingMember = {
    interests: {}
  }

  try {
    // if someone is already in the system for any reason and they are
    // hitting this method we can safely assume they want to be subscribed
    // and just set them to that state.
    existingMember = await status(payload)
    if (member) {
      state = 'subscribed'
      response = 'welcome-back'
    }
  } catch(e) {
    // we don't care if this fails
  }

  try {
    const member = await client().put({
      path: `/lists/${payload.list_id}/members/${md5(payload.email_address)}`,
      body: {
        email_address: payload.email_address,
        status: state,
        merge_fields: {
          FNAME: payload.first_name
        }
        interests: Object.assign(member.)
      }
    })
  } catch(e) {
    if (e.status === 404) {
      response = 'failed-bad-list'
    } else if (e.detail === 'Please provide a valid email address.') {
      response = 'failed-bad-email'
    }
  }

  return response;
}

exports.subscribe = subscribe
exports.client = client
