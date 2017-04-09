const config = require('../config/site');
const express = require('express');
const app = express();
const DB = require('./classes/database').knex;

app.configure('development', function () {
  app.use(express.errorHandler());
  app.use('/lib',express.static('lib'));
  app.use('/',express.static(__dirname+'/../'));
});

app.configure(function () {
  app.engine('jade', require('jade').__express);
  app.set('view engine', 'jade');
  app.set('views', __dirname+'/views');
  app.use(express.static(__dirname+'/../public'));
  app.use(express.urlencoded());
  app.use(express.json());
});

app.get('/', function (req, res) {
  DB('customer').
    distinct(['lat','lng']).
    whereNotNull('lat').
    whereNotNull('lng').then(function (sightings) {
      res.render('index', {
        mode: config.env,
        config: config,
        sightings: JSON.stringify(sightings)
      });
  });
});
app.all('/download', require('./routes/download'));
app.post('/contact', require('./routes/contact'));
app.post('/ipn', require('./routes/ipn'));

module.exports = app;
