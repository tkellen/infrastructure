const BaseModel = require('../classes/base_model');
const mail = require('../classes/mail');
const promise = require('bluebird');
const _ = require('lodash');

var affiliateEmail = function (who, what) {
  mail.send({
    from: 'Tara Alan <tara@bikecampcook.com>',
    to: who.name+' <'+who.email+'>',
    subject: 'Bike. Camp. Cook. Commission Sale',
    text: 'You just sold: '+what.name+'!'
  });
};

var instanceProps = {
  tableName: 'sale_item',
  sale: function () {
    return this.belongsTo(require('./sale'));
  },
  isBook: function () {
    return this.get('product_id') > 1;
  }
};

var classProps = {
  fields: ['id','sale_id','product_id','total','qty'],
  createFromIpn: function (params, sale) {
    const Product = require('./product');
    var self = this;
    var items = [];
    var total = 0;
    _.times((params.num_cart_items||1), function (i) {
      var item = i+1;
      var code = params['item_number'+item];
      var item_total = params['mc_gross_'+item];
      var qty = params['quantity'+item]||1;
      items.push(Product.findByCode(code).then(function (product) {
        if (product) {
          if (product.related('affiliate')) {
            affiliateEmail(product.related('affiliate').toJSON(), product.toJSON());
          }
          total += item_total*qty;
          return self.forge({
            product_id: product.get('id'),
            total: item_total,
            sale_id: sale.get('id'),
            qty: qty
          }).save();
        }
      }));
    });
    return promise.all(items).then(function () {
      return sale.save({total:total});
    });
  }
};

module.exports = BaseModel.extend(instanceProps, classProps);
