config = require('../config.js')

module.exports =
  index: (req, res)->
    res.render 'index',
      config: config
      subscribed: req.session.subscribed
