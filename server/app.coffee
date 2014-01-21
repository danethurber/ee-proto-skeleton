path = require 'path'
fs = require 'fs'

# stack = require 'simple-stack-common'
express = require 'express'
passport = require 'passport'
mongoose = require 'mongoose'

routes = require './config/routes'

dbUrl = process.env.MONGO_URL
mongoose.connect dbUrl

db = mongoose.connection
db.once 'open', () -> console.log "Connected To Database: #{dbUrl}"
db.on 'error', () -> throw new Error "Unable to Connect To Database: #{dbUrl}"

modelPath = __dirname + '/models'
loadModels = (path) ->
  fs.readdirSync(path).forEach (file) ->
    newPath = path + '/' + file
    stat = fs.statSync newPath

    if stat.isFile()
      require(newPath) if /(.*)\.(js$|coffee$)/.test(file)
    else if stat.isDirectory()
      loadModels newPath

loadModels modelPath

# module.exports = app = stack()
module.exports = app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  app.use express.logger()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use passport.initialize()

#   app.useBefore 'router', '/api', 'jwt-verify', require('./middleware/jwt-verify')
#   app.useBefore 'router', '/static', 'mincer', require('./middleware/mincer').server

  app.use '/static', require('./middleware/mincer').server

  app.use app.router

app.configure 'development', () ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', () ->
  app.use express.errorHandler()

passport.use require('./models/user').createStrategy()

routes.init app
