const test = require('ava')
const { subscribe } = require('./mailchimp')
const { withMailchimp, mockEmail } = require('./testhelpers')

test('fails if a bad list is supplied', async t => {
  const failed = await subscribe({
    listId: 'nope',
    emailAddress: mockEmail()
  })
  t.is(failed.message, 'failed-bad-list')
})

test('fails if a bad group is supplied', async t => {
  await withMailchimp(async ({listId}) => {
    const failed = await subscribe({
      listId: listId,
      group_id: 'nope',
      emailAddress: mockEmail()
    })
    t.is(failed.message, 'failed-bad-group')
  })
})

test('fails if a bad email is supplied', async t => {
  await withMailchimp(async ({listId, groupIdOne}) => {
    const failed = await subscribe({
      listId: listId,
      group_id: groupIdOne,
      emailAddress: 'nope',
      firstName: 'test'
    })
    t.is(failed.message, 'failed-bad-email')
  })
})

test('handles new signups', async t => {
  const email = mockEmail()
  await withMailchimp(async ({listId, groupIdOne, groupIdTwo}) => {
    const subscribed = await subscribe({
      listId: listId,
      group_id: groupIdOne,
      emailAddress: email,
      firstName: 'test'
    })
    t.is(subscribed.message, 'waiting-on-approval')
    t.is(subscribed.firstName, 'test')
    t.is(subscribed.emailAddress, email)
    t.is(subscribed.listId, listId)
    t.true(subscribed.groups[groupIdOne])
    t.false(subscribed.groups[groupIdTwo])
  })
})

test('handles repeated signups', async t => {
  const email = mockEmail()
  await withMailchimp(async ({listId, groupIdOne, groupIdTwo}) => {
    const first = await subscribe({
      listId: listId,
      group_id: groupIdOne,
      emailAddress: email,
      firstName: 'first'
    })
    t.is(first.message, 'waiting-on-approval')
    t.is(first.firstName, 'first')
    t.is(first.emailAddress, email)
    t.is(first.listId, listId)
    t.true(first.group_ids[groupIdOne])
    t.false(first.group_ids[groupIdTwo])

    const second = await subscribe({
      listId: listId,
      emailAddress: email,
      group_id: groupIdTwo,
      firstName: 'second'
    })
    t.is(second.message, 'welcome-back')
    t.is(second.firstName, 'second')
    t.is(second.emailAddress, email)
    t.is(second.listId, listId)
    t.true(second.group_ids[groupIdOne])
    t.true(second.group_ids[groupIdTwo])
  })
})
