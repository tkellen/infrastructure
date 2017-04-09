const BaseModel = require('../classes/base_model');

var instanceProps = {
  tableName: 'affiliate'
};

var classProps = {
  fields: ['id', 'name', 'email', 'code'],
};

module.exports = BaseModel.extend(instanceProps, classProps);
