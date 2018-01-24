const DB = require('../classes/database');
const _ = require('lodash');

var instanceProps = {
  format: function (params) {
    var fields = _.intersection(Object.keys(params), this.constructor.fields);
    return _.pick(params, fields);
  },
  save: function (params, opts) {
    var fields = params || this.attributes;
    return DB.Model.prototype.save.call(this, fields, opts);
  }
};

var classProps = {
  fields: []
};

module.exports = DB.Model.extend(instanceProps, classProps);
