const config = require('../../config/db');
const Bookshelf = require('bookshelf');
const DB = Bookshelf.initialize(config.database);

module.exports = DB;
