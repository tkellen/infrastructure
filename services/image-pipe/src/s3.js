// this is TERRIBLE

const hyperquest = require('hyperquest')
const AWS = require('aws-sdk')

const resize = require('./resize')

const S3 = new AWS.S3()

function transfer ({uri, size, bucket, key}) {
  return new Promise(function (resolve, reject) {
    // spawn process to resize image received on stdin
    const resizer = resize(size)
    // capture detailed error messages for resize failures
    let resizeErr = ''
    // handle process failures (can't start/kill/communicate w/ process)
    resizer.on('error', reject)
    // capture error output if resize failed
    resizer.stderr.on('data', err => { resizeErr += err.toString() })
    // reject and display error output if resizing failed
    resizer.on('close', (code) => {
      if (code) {
        return reject(new Error(resizeErr))
      }
    })
    // stream requested image from a provided uri
    const image = hyperquest(uri)
    // handle process failures (can't start/kill/communicate w/ process)
    image.on('error', reject)
    // provide detailed rejection if image being retrieved can't be found
    image.on('response', ({statusCode}) => {
      if (statusCode !== 200) {
        reject(new Error(`${statusCode} response for ${uri}`))
      }
    })
    // push image through resizer
    image.pipe(resizer.stdin)
    // stream image to s3
    S3.upload({
      Bucket: bucket,
      Key: `img/${size}/${key}`,
      Body: resizer.stdout,
      ContentType: 'image/jpeg'
    }, (err, result) => {
      if (err) {
        return reject(err)
      }
      resolve(result)
    })
  })
}

exports.transfer = transfer
