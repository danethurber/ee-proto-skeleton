express = require 'express'
path = require 'path'

routes = require './config/routes'

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.static path.join '..', 'client'

  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler()

routes.init app

app.listen app.get('port'), ->
  console.log "Express server listening on port: #{ app.get('port') }"
