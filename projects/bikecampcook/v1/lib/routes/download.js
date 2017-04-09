const DB = require('../classes/database').knex;
const Customer = require('../models/customer');

module.exports = function (req, res) {
  var params = req.body||req.query;
  Customer.boughtBookByEmail(params.purchaser_email).then(function (customer) {
    if(customer) {
      DB('downloads').insert({
        email: params.purchaser_email
      }).then(function () {
        res.setHeader('Content-disposition', 'attachment; filename=BikeCampCook.pdf');
        res.sendfile('files/BikeCampCook.pdf', __dirname);
      });
    } else {
      res.send('Unable to locate a purchase under this email.  Please <a href=/#contact>contact me</a> if you feel this is incorrect!', 403);
    }
  });
};
