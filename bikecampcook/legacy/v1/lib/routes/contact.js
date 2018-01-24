const config = require('../../config/site.js');
const mail = require('../classes/mail');

module.exports = function (req, res) {
  var params = req.body;
  res.app.render('emails/contact', params, function(err, html) {
    mail.send({
      from: params.from+' <'+params.email+'>',
      to: config.email,
      subject: 'Bike Camp Cook Contact Form',
      html: html,
      text: html.replace(/<\/?[^>]+(>|$)/g, "")
    });
    res.json({});
  });
};
