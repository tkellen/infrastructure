const BaseModel = require('../classes/base_model');
const _ = require('lodash');

var instanceProps = {
  tableName: 'product',
  affiliate: function () {
    return this.belongsTo(require('./affiliate'));
  }
};

var classProps = {
  fields: ['id', 'name', 'code', 'price', 'affiliate_id'],
  findByCode: function (code) {
    return this.forge({code:code}).fetch({withRelated:'affiliate'});
  }
};

module.exports = BaseModel.extend(instanceProps, classProps);
