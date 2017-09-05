const { api_key } = require('./config')
const md5 = require('./md5')

const MailChimp = require('mailchimp-api-v3')

function client () {
  try {
    return new MailChimp(api_key)
  } catch (err) {
    // TODO: replace with something where the email will get saved
    // to a service we know is alive.
    throw new Error('Unable to create mailchimp client.')
  }
}

function status (payload) {
  return client().get(
    `/lists/${payload.list_id}/members/${md5(payload.email_address)}`
  )
}

async function subscribe (payload) {
  // By default we are expecting users are first time visitors. This means
  // we will put them into a "pending" state. That will tell Mailchimp to
  // send them a "double opt-in" email.
  let state = 'pending'

  // By default our message should be that we are waiting on approval from
  // the user. This corresponds to the pending scenario described above.
  let message = 'waiting-on-approval'

  // By default we want to use the HTTP method put to update/create in place.
  let method = 'put'

  // By default we assume no error has occured.
  let error = false

  // Keep member data in scope so we can return it
  let member = {}

  // First, let's see if this email is already in our list.
  try {
    member = await status(payload)
    if (member) {
      // If a user is already on the list and they are signing up again, we can
      // safely assume they want to be subscribed. No matter what their previous
      // state was, make them be "subscribed".
      state = 'subscribed'

      // If a user already exists, change to updating specific fields rather
      // than whole sale replacment/creation.
      method = 'patch'

      // We want to be smart in our reply. If a user has already signed up and
      // they are back for more, let's welcome them vs showing them the same
      // initial signup flow.
      message = 'welcome-back'
    }
  } catch (e) {
    // If this fails it just means the user didn't exist.
  }

  // Prep the payload we are going to use for creating/updating our user
  const body = {
    email_address: payload.email_address,
    status: state,
    merge_fields: {
      FNAME: payload.first_name
    },
    // We use hidden groups to classify how people signed up. This ensures
    // that our signup call will flag the user as being in any group that
    // we havs specified.
    interests: payload.group_id ? { [payload.group_id]: true } : {}
  }
  // Create or update the user!
  try {
    member = await client()[method]({
      path: `/lists/${payload.list_id}/members/${md5(payload.email_address)}`,
      body: body
    })
  } catch (e) {
    error = true
    if (e.status === 404) {
      message = 'failed-bad-list'
    } else if (e.detail.match(/provide a valid email/)) {
      message = 'failed-bad-email'
    } else if (e.detail.match(/interest ID/)) {
      // TODO: handle this by just removing the group assignment if it
      // doesn't exist
      message = 'failed-bad-group'
    }
  }
  return {
    error,
    message,
    first_name: member.first_name || payload.first_name,
    email_address: member.email_address || payload.email_address,
    list_id: member.list_id,
    group_ids: member.interests
  }
}

exports.subscribe = subscribe
exports.client = client
