path = require 'path'
fs = require 'fs'

express = require 'express'
mongoose = require 'mongoose'

routes = require './config/routes'

dbUrl = process.env.MONGO_URL
mongoose.connect dbUrl

db = mongoose.connection
db.once 'open', () -> console.log "Connected To Database: #{dbUrl}"
db.on 'error', () -> throw new Error "Unable to Connect To Database: #{dbUrl}"

recursiveLoadModels = (path) ->
  fs.readdirSync(path).forEach (file) ->
    newPath = path + '/' + file
    stat = fs.statSync newPath

    if stat.isFile()
      require(newPath) if /(.*)\.(js$|coffee$)/.test(file)
    else if stat.isDirectory()
      arguments.callee newPath

recursiveLoadModels path.join(__dirname, 'models')

module.exports = app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  app.use express.logger()
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use '/static', require('./middleware/mincer').server

  app.use app.router

app.configure 'development', () ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', () ->
  app.use express.errorHandler()

routes.init app
