const Customer = require('../models/customer');
const IPN = require('paypal-ipn');
const mail = require('../classes/mail');

var ipnMail = function (msg, params) {
  var html = msg+"<br>"+JSON.stringify(params);
  mail.send({
    from: 'donotreply@bikecampcook.com',
    to: 'tyler@sleekcode.net',
    subject: 'BCC IPN',
    html: html,
    text: html.replace(/<\/?[^>]+(>|$)/g, "")
  });
};

var purchaseMail = function (res, params) {
  res.app.render('emails/purchase', params, function(err, html) {
    mail.send({
      from: 'Tara Alan <tara@bikecampcook.com>',
      to: params.first_name+' '+params.last_name+' <'+params.payer_email+'>',
      subject: 'Thank you for your purchase!',
      html: html,
      text: html.replace(/<\/?[^>]+(>|$)/g, "")
    });
  });
};

module.exports = function (req, res) {
  var params = req.body;

  ipnMail('IPN Received!',params);

  var handler = function (err, msg) {
    if (err) {
      ipnMail(msg, params);
    } else {
      Customer.createFromIpn(params).then(function (customer) {
        if (customer) {
          customer.createSaleFromIpn(params).then(function (sale) {
            if(!sale) {
              console.log('wtf');
            } else {
              purchaseMail(res, params);
              res.send(200);
            }
          });
        } else {
          ipnMail('Could not create customer.', params);
        }
      }).catch(function (e) {
        ipnMail(e, params);
        res.send(500);
      });
    }
  };
  IPN.verify(params, handler);
};
