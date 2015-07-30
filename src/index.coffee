express         = require('express')
bodyParser      = require('body-parser')
mongoose        = require('mongoose')
session        = require('express-session')
portConfig      = require('port-config')
indexController = require('./controllers/index')
aboutController = require('./controllers/about')
config          = require('./config')
Client          = require('./models/client');

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
    client.save().then(success, error)
  else
    error('Email is required')

server = app.listen portConfig(), ->
	console.log 'Express server listening on port ' + server.address().port
