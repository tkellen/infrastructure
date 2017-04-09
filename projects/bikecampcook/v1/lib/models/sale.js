const BaseModel = require('../classes/base_model');

var instanceProps = {
  tableName: 'sale',
  items: function () {
    return this.hasMany(require('./sale_item'), 'sale_id');
  }
};

var classProps = {
  fields: ['id','date_placed','customer_id','notes','total',
           'date_shipped','txn_id','ipn_response','shipping_name'],
  findByTxn: function (txn_id, fetchOpts) {
    fetchOpts = fetchOpts||{};
    return this.forge({txn_id:txn_id}).fetch(fetchOpts);
  },
  createFromIpn: function (params, customer) {
    var self = this;
    return this.findByTxn(params.txn_id).then(function (model) {
      if (!model) {
        return self.forge({
          customer_id: customer.get('id'),
          txn_id: params.txn_id,
        }).save().then(function (sale) {
          return require('./sale_item').createFromIpn(params, sale);
        });
      } else {
        return model;
      }
    });
  }
};

module.exports = BaseModel.extend(instanceProps, classProps);
