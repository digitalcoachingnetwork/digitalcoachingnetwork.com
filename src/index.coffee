require('localenv')
express         = require('express')
bodyParser      = require('body-parser')
mongoose        = require('mongoose')
session         = require('express-session')
Promise         = require('bluebird')
sendgrid        = require('sendgrid')(process.env.SENDGRID_API_KEY)
portConfig      = require('port-config')
indexController = require('./controllers/index')
aboutController = require('./controllers/about')
config          = require('./config')
Client          = require('./models/client');

Promise.promisifyAll(sendgrid)

mongoose.connect(config.mongo.connectionString)

app = express()
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded extended:false
app.use session
  secret: 'dcn',
  resave: false,
  saveUninitialized: true

# sends an email to the site owners when a new client has registered
sendEmail = (email)->
  sendgrid.sendAsync({
    to:       config.adminEmail,
    from:     email,
    subject:  'DCN: New Client!',
    text:     email + ' has expressed interest in the Digital Coaching Network.'
  })

app.get '/', indexController.index
app.get '/about', aboutController.about
app.post '/signup', (req, res)->

  success = ->
    req.session.subscribed = true
    res.send()

  error = (err)->
    if err.toString().indexOf('duplicate key error') >= 0
      success()
    else
      console.log(err)
      res.status(500).send()

  if req.body.email
    client = new Client email:req.body.email
    Promise.resolve(client.save())
      .then(sendEmail.bind(null, req.body.email))
      .then(success)
      .catch(error)
  else
    error('Email is required')

server = app.listen portConfig(), ->
	console.log 'Express server listening on port ' + server.address().port
