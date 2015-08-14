config = require('../config.js')

module.exports =
  index: (req, res)->
    res.render 'index',
      config: config
      subscribed: req.session.subscribed

  about: (req, res)->
    res.render 'about'

  pay: (req, res)->
    res.render 'pay',
      config: config
