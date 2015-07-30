(function() {
  var Client, config, mongoose;

  mongoose = require('mongoose');

  config = require('../config');

  Client = mongoose.model('client', new mongoose.Schema({
    created: {
      type: Date,
      "default": function() {
        return new Date;
      }
    },
    email: {
      type: String,
      required: true,
      unique: true
    }
  }));

  module.exports = Client;

}).call(this);
