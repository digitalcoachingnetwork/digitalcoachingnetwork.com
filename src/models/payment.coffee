mongoose = require('mongoose')
config   = require('../config')

Payment = mongoose.model 'payment', new mongoose.Schema
  created:
    type: Date
    default: -> new Date
  amount:      Number
  email:       String
  description: String
  source:      Object

module.exports = Payment
