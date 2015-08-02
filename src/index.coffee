require('localenv')
express         = require('express')
bodyParser      = require('body-parser')
mongoose        = require('mongoose')
session         = require('express-session')
favicon         = require('serve-favicon')
Promise         = require('bluebird')
sendgrid        = require('sendgrid')(process.env.SENDGRID_API_KEY)
portConfig      = require('port-config')
indexController = require('./controllers/index')
aboutController = require('./controllers/about')
config          = require('./config')
Client          = require('./models/client');
Trello          = require('trello')

mongoose.connect(config.mongo.connectionString)

trello = new Trello(process.env.TRELLO_API_KEY, process.env.TRELLO_USER_TOKEN)

Promise.promisifyAll(trello)
Promise.promisifyAll(sendgrid)

app = express()
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.use favicon __dirname + '/public/favicon.ico'
app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded extended:false
app.use session
  secret: 'dcn',
  resave: false,
  saveUninitialized: true

# sends an email to the site owners when a new client has registered
sendNewClientEmail = (email)->
  sendgrid.sendAsync({
    to:       config.adminEmail,
    from:     email,
    subject:  'DCN: New Client!',
    text:     email + ' has expressed interest in the Digital Coaching Network.'
  })

app.get '/', indexController.index
app.get '/about', aboutController.about
app.post '/signup', (req, res)->

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

server = app.listen portConfig(), ->
	console.log 'Express server listening on port ' + server.address().port
