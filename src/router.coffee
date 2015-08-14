express  = require('express')
mongoose = require('mongoose')
Promise  = require('bluebird')
Trello   = require('trello')
sendgrid = require('sendgrid')(process.env.SENDGRID_API_KEY)
stripe   = require("stripe")(process.env.STRIPE_SECRET_KEY)
Client   = require('./models/client');
config   = require('./config.js')

mongoose.connect(config.mongo.connectionString)
trello = new Trello(process.env.TRELLO_API_KEY, process.env.TRELLO_USER_TOKEN)

Promise.promisifyAll(trello)
Promise.promisifyAll(sendgrid)

# sends an email to the site owners when a new client has registered
sendNewClientEmail = (email)->
  sendgrid.sendAsync({
    to:       config.adminEmail
    from:     email
    subject:  'DCN: New Client!'
    text:     email + ' has expressed interest in the Digital Coaching Network.'
  })

router = express.Router()

router.get '/', (req, res)->
  res.render 'index',
    config: config
    subscribed: req.session.subscribed

router.get '/about', (req, res)->
  res.render 'about'

router.get '/pay', (req, res)->
  res.render 'pay',
    config: config

router.post '/charge', (req, res)->
  res.status(500).send('oi')

router.get '/signup', (req, res)->

  email = req.body.email

  success = ->
    req.session.subscribed = true
    res.send()

  error = (err)->
    if err.toString().indexOf('duplicate key error') >= 0
      success()
    else
      console.log(err)
      res.status(500).send()


  if !req.body.email
    return error('Email is required')

  # save to db, save to trello, email admins
  Promise.join(
    (new Client email:email).save(),
    trello.addCardAsync(email, null, config.trello.newClientListId),
    sendNewClientEmail(email)
  )
  .then(success)
  .catch(error)

module.exports = router
