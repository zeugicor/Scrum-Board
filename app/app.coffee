
###
Module dependencies.
###
express           = require 'express'
load              = require 'express-load'
http              = require 'http'
path              = require 'path'
reload            = require 'reload'
mongoose          = require 'mongoose'
Mincer            = require 'mincer'
less              = require 'less'
passport          = require 'passport'
MongoStore        = require('connect-mongo')(express)
flash             = require 'connect-flash'

###
# Express app
###
app = express()


###
# Server
###
server = http.createServer app

###
# Application configuration
###

app.configure ->
  app.set 'root', __dirname
  app.set 'mongoDb', 'mongodb://ple.bli.ch/scrum_board_development'
  app.set 'mongoDbServer', 'ple.bli.ch'
  app.set 'mongoDbDatabase', 'scrum_board_development'
  app.set 'port', 8080


  # Template engine
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.locals.pretty = true if app.settings.env is 'development'

  # Express
  app.use express.favicon()
  app.use express.logger("dev") if app.settings.env is 'development'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  # Session store
  app.use express.session(
    secret: 'NodeScrumBoardApp'
    store: new MongoStore(
      db:     app.get 'mongoDbDatabase'
      host:   app.get 'mongoDbServer'
    )
  )

  # Passport
  app.use passport.initialize()
  app.use passport.session()

  app.use app.router

  # Flash Messages
  app.use flash()


  # Assets
  environment = new Mincer.Environment()
  environment.appendPath "app/assets/images"
  environment.appendPath "app/assets/javascripts"
  environment.appendPath "app/assets/stylesheets"
  environment.appendPath "app/assets/vendor"

  app.use "/assets", Mincer.createServer(environment)

  # Static content
  app.use express.static "#{__dirname}/public"
  app.enable 'trust proxy'



###
# Autoload environment configuration and modules into application instance
###
process.chdir 'app'

load('middelware')
  .then('models')
  .then('controllers')
  .then('routes')
  .into app


###
  Socket
###
require('./sockets/sockets')( app, server )

###
# MongoDB Connection
###
mongoose.connect("mongodb://#{app.get 'mongoDbServer'}/#{app.get 'mongoDbDatabase'}" )





###
# Listen on to port
###
reload(server, app)

server.listen app.settings.port, ->
  console.log "#{app.settings.name}: listening on port #{app.settings.port} in #{app.settings.env} mode"

module.exports = app
