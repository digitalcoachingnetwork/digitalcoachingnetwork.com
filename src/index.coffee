require('localenv')
express    = require('express')
bodyParser = require('body-parser')
session    = require('express-session')
favicon    = require('serve-favicon')
portConfig = require('port-config')
router     = require('./router.js')
config     = require('./config')
forceSSL   = require('express-force-ssl')
# helmet   = require('helmet')

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

if process.env.NODE_ENV is 'production'
  console.log('using forceSSL')
  app.use(forceSSL)
  # app.use(helmet())

app.use '/', router

server = app.listen portConfig(), ->
	console.log 'Express server listening on port ' + server.address().port
