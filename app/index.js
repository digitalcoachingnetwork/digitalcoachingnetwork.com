(function() {
  var aboutController, app, bodyParser, express, indexController, server;

  express = require('express');

  bodyParser = require('body-parser');

  indexController = require('./controllers/index.js');

  aboutController = require('./controllers/about.js');

  require('newrelic');

  app = express();

  app.set('view engine', 'jade');

  app.set('views', __dirname + '/views');

  app.use(express["static"](__dirname + '/public'));

  app.use(bodyParser.urlencoded({
    extended: false
  }));

  app.get('/', indexController.index);

  app.get('/about', aboutController.about);

  server = app.listen(process.env.PORT || 9882, function() {
    return console.log('Express server listening on port ' + server.address().port);
  });

}).call(this);
