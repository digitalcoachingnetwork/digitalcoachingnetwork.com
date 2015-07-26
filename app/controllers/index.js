(function() {
  var config;

  config = require('../config.js');

  module.exports = {
    index: function(req, res) {
      return res.render('index', {
        config: config
      });
    }
  };

}).call(this);
