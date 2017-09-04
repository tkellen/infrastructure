const { client } = require('./mailchimp')

exports.mockEmail = () =>
  `${Math.random().toString(36).substring(7)}@aevitas.io`

exports.withMailchimp = async (fn) => {
  let tempList
  try {
    tempList = await client().post('/lists', {
      name: 'test',
      contact: {
        company: 'test',
        address1: 'test',
        address2: 'test',
        city: 'test',
        state: 'VT',
        zip: '05250',
        country: 'US',
        phone: ''
      },
      permission_reminder: 'test',
      campaign_defaults: {
        from_name: 'test',
        from_email: 'infrastructure@aevitas.io',
        subject: '',
        language: 'en'
      },
      email_type_option: true
    });
    const tempInterest = await client().post(`/lists/${tempList.id}/interest-categories`, {
      title: 'test',
      type: 'hidden'
    })
    const tempGroupOne = await client().post(`/lists/${tempList.id}/interest-categories/${tempInterest.id}/interests`, {
      name: 'one'
    })
    const tempGroupTwo = await client().post(`/lists/${tempList.id}/interest-categories/${tempInterest.id}/interests`, {
      name: 'two'
    })
    await fn({
      list_id: tempList.id,
      group_id_one: tempGroupOne.id,
      group_id_two: tempGroupTwo.id
    })
  } catch(e) {
    // don't care about failures
  } finally {
    // clean up!
    return await client().delete(`/lists/${tempList.id}`)
  }
}
