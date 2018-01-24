const BaseModel = require('../classes/base_model');
const geolocater = require('../classes/geolocater');
const _ = require('lodash');

var instanceProps = {
  tableName: 'customer',
  purchases: function () {
    return this.hasMany(require('./sale'), 'customer_id');
  },
  createSaleFromIpn: function (params) {
    return require('./sale').createFromIpn(params, this);
  }
};

var classProps = {
  fields: ['id','date_joined','first','last','email','addr1','addr2','city',
           'state','zip','country','phone','company','backername','lat','lng'],
  boughtBookByEmail: function (email) {
    var find = this.findByEmail(email, {withRelated:['purchases.items']});
    return find.then(function (customer) {
      if(!customer) {
        return false;
      } else {
        var purchases = customer.related('purchases').models;
        return _.any(purchases, function (purchase) {
          if (purchase.get('kickstarter')) {
            return true;
          }
          var items = purchase.related('items').models;
          return _.any(items, function (item) { return item.isBook(); });
        });
      }
    });
  },
  findByEmail: function (email, fetchOpts) {
    fetchOpts = fetchOpts||{};
    return this.forge({}).query(function () {
      return this.whereRaw('lower(email) = ?',email.toLowerCase());
    }).fetch(fetchOpts);
  },
  createFromIpn: function (params) {
    var self = this;
    return this.findByEmail(params.payer_email).then(function (model) {
      if (!model) {
        model = self.forge({
          first: params.first_name,
          last: params.last_name,
          email: params.payer_email,
          addr1: params.address_street,
          city: params.address_city,
          state: params.address_state,
          zip: params.address_zip,
          country: params.address_country_code
        });
        return geolocater({
          zip: model.get('zip'),
          country: model.get('country')
        }).then(function (coords) {
          model.set('lat', coords.lat);
          model.set('lng', coords.lng);
          return model.save();
        }).catch(function () {
          // ignore failures on the geolocater
          return model.save();
        });
      } else {
        return model;
      }
    });
  }
};

module.exports = BaseModel.extend(instanceProps, classProps);
