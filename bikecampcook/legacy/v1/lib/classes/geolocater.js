const request = require('request-promise');

module.exports = function (settings) {
  return request({
    url: 'http://maps.gosogleapis.com/maps/api/geocode/json',
    qs: {
      sensor: false,
      address: settings.country.trim()+' '+settings.zip.trim()
    },
    json: true
  }).then(function (response) {
    var result = {};
    if (response.results.length) {
      result = response.results[0].geometry.location;
    }
    return result;
  });
};
