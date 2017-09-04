const test = require('ava')
const { subscribe } = require('./mailchimp')

const { withList, mockEmail } = require('./testhelpers');

test('subscribe handles adding new users', async t => {
  const email = mockEmail()
  return await withList(async ({list_id, group_id}) => {
    const subscribed = await subscribe({
      list_id: list_id,
      group_id: group_id,
      email_address: email
    })
    t.is(subscribed, 'waiting-on-approval')
  })
})

test('subscribe handles re-adding/confirming returning users', async t => {
  const email = mockEmail()
  return await withList(async ({list_id, group_id}) => {
    const first = await subscribe({
      list_id: list_id,
      group_id: group_id,
      email_address: email
    })
    t.is(first, 'waiting-on-approval')
    const second = await subscribe({
      list_id: list_id,
      group_id: group_id,
      email_address: email
    })
    t.is(second, 'welcome-back')
  })
})

test('subscribe fails if a bad email is supplied', async t => {
  await withList(async ({list_id, group_id}) => {
    const failed = await subscribe({
      list_id: list_id,
      group_id: group_id,
      email_address: 'nope'
    })
    t.is(failed, 'failed-bad-email')
  })
})

test('subscribe fails if a bad list is supplied', async t => {
  const failed = await subscribe({
    list_id: 'nope',
    email_address: mockEmail()
  })
  t.is(failed, 'failed-bad-list')
})

test('subscribe fails if a bad group is supplied', async t => {
  await withList(async ({list_id, group_id}) => {
    const failed = await subscribe({
      list_id: list_id,
      group_id: 'nope',
      email_address: mockEmail()
    })
    t.is(failed, 'failed-bad-group')
  })
})
