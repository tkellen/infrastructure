const test = require('ava')

const { transfer } = require('./s3')

const images = [
  {
    uri: 'https://farm6.staticflickr.com/5782/21502193583_4585d5d4c4_o.jpg',
    key: '21502193583.jpg'
  },
  {
    uri: 'https://farm9.staticflickr.com/8406/29033497953_ec00a676f9_o.jpg',
    key: '29033497953.jpg'
  },
  {
    uri: 'https://farm9.staticflickr.com/8360/29883925391_21d8d633db_o.jpg',
    key: '29883925391.jpg'
  },
  {
    uri: 'https://farm6.staticflickr.com/5496/30352285843_2abe6feb8f_o.jpg',
    key: '30352285843.jpg'
  },
  {
    uri: 'https://farm6.staticflickr.com/5789/30686579960_e9c2203b24_o.jpg',
    key: '30686579960.jpg'
  },
  {
    uri: 'https://farm1.staticflickr.com/362/31499164532_7ecfd4e008_o.jpg',
    key: '31499164532.jpg'
  },
  {
    uri: 'https://farm1.staticflickr.com/649/31529650461_57c36904be_o.jpg',
    key: '31529650461.jpg'
  },
  {
    uri: 'https://farm1.staticflickr.com/721/31499170292_cbdb27f546_o.jpg',
    key: '31499170292.jpg'
  },
  {
    uri: 'https://farm1.staticflickr.com/372/31645372455_049a8cff95_o.jpg',
    key: '31645372455.jpg'
  },
  {
    uri: 'https://farm1.staticflickr.com/283/30762565764_59712aaa0f_o.jpg',
    key: '30762565764.jpg'

  },
  {
    uri: 'https://farm1.staticflickr.com/739/30794129423_910cd39d65_o.jpg',
    key: '30794129423.jpg'
  },
  {
    uri: 'https://farm6.staticflickr.com/5616/30762553254_a7950f80b9_o.jpg',
    key: '30762553254.jpg'

  },
  {
    uri: 'https://farm1.staticflickr.com/523/30794115363_13926a0aef_o.jpg',
    key: '30794115363.jpg'

  },
  {
    uri: 'https://farm1.staticflickr.com/606/32150610165_e7713228eb_o.jpg',
    key: '32150610165.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4385/36586903950_7c72620cac_o.jpg',
    key: '36586903950.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4398/36586901030_de2914c8ed_o.jpg',
    key: '36586901030.jpg'

  },
  {
    uri: 'https://farm5.staticflickr.com/4387/36843908491_e40398ffbd_o.jpg',
    key: '36843908491.jpg'

  },
  {
    uri: 'https://farm5.staticflickr.com/4374/36843903651_6f515d3d51_o.jpg',
    key: '36843903651.jpg'

  },
  {
    uri: 'https://farm5.staticflickr.com/4414/36796190016_20fe30fdde_o.jpg',
    key: '36796190016.jpg'

  },
  {
    uri: 'https://farm5.staticflickr.com/4386/36148363324_20c603a6ed_o.jpg',
    key: '36148363324.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4410/36148358284_aef0f9a9a8_o.jpg',
    key: '36148358284.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4420/36148357774_e1e9ca27b2_o.jpg',
    key: '36148357774.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4372/36175257453_013a89f376_o.jpg',
    key: '36175257453.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4438/36984187835_11d6b9fca8_o.jpg',
    key: '36984187835.jpg'
  },
  {
    uri: 'https://farm5.staticflickr.com/4344/36797251436_3b8f998463_o.jpg',
    key: '36797251436.jpg'
  }
]

const sizes = [320, 480, 640, 960, 1280, 1920, 2560, 3200]

test('resizing images', async t => {
  const payloads = sizes.map(size => {
    return images.map(image => ({
      size: size,
      uri: image.uri,
      bucket: 'aevitas',
      key: image.key
    }))
  })
  const flat = [].concat.apply([], payloads)
  const transfers = flat.map(payload => {
    console.log(`starting ${payload.key} at ${payload.size}`)
    return transfer(payload).then(() => {
      console.log(`landed ${payload.key} at ${payload.size}`)
    })
  })
  return Promise.all(transfers)
})
