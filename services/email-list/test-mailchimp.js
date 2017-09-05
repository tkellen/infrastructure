const test = require('ava')
const { subscribe } = require('./mailchimp')
const { withMailchimp, mockEmail } = require('./testhelpers');

test('fails if a bad list is supplied', async t => {
  const failed = await subscribe({
    list_id: 'nope',
    email_address: mockEmail()
  })
  t.is(failed.message, 'failed-bad-list')
})

test('fails if a bad group is supplied', async t => {
  await withMailchimp(async ({list_id}) => {
    const failed = await subscribe({
      list_id: list_id,
      group_id: 'nope',
      email_address: mockEmail()
    })
    t.is(failed.message, 'failed-bad-group')
  })
})

test('fails if a bad email is supplied', async t => {
  await withMailchimp(async ({list_id, group_id_one}) => {
    const failed = await subscribe({
      list_id: list_id,
      group_id: group_id_one,
      email_address: 'nope',
      first_name: 'test'
    })
    t.is(failed.message, 'failed-bad-email')
  })
})

test('handles new signups', async t => {
  const email = mockEmail()
  await withMailchimp(async ({list_id, group_id_one}) => {
    const subscribed = await subscribe({
      list_id: list_id,
      group_id: group_id_one,
      email_address: email,
      first_name: 'test'
    })
    t.is(subscribed.message, 'waiting-on-approval')
    t.is(subscribed.first_name, 'test')
    t.is(subscribed.email_address, email)
    t.is(subscribed.list_id, list_id)
    t.true(subscribed.groups[group_id_one])
    t.false(subscribed.groups[group_id_two])
  })
})

test('handles repeated signups', async t => {
  const email = mockEmail()
  await withMailchimp(async ({list_id, group_id_one, group_id_two}) => {
    const first = await subscribe({
      list_id: list_id,
      group_id: group_id_one,
      email_address: email,
      first_name: 'first'
    })
    t.is(first.message, 'waiting-on-approval')
    t.is(first.first_name, 'first')
    t.is(first.email_address, email)
    t.is(first.list_id, list_id)
    t.true(first.group_ids[group_id_one])
    t.false(first.group_ids[group_id_two])
    const second = await subscribe({
      list_id: list_id,
      email_address: email,
      group_id: group_id_two,
      first_name: 'second'
    })
    t.is(second.message, 'welcome-back')
    t.is(second.first_name, 'second')
    t.is(second.email_address, email)
    t.is(second.list_id, list_id)
    t.true(second.group_ids[group_id_one])
    t.true(second.group_ids[group_id_two])
  })
})
