path = require 'path'

express = require 'express'
expressJwt = require 'express-jwt'

routes = require './config/routes'

module.exports = app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.json()
  app.use express.urlencoded()

  # TODO: put secret in a config file using an ENV var
  app.use '/api', expressJwt { secret: 'kittens' }
  app.use (err, req, res, next) ->
    if err.constructor.name is 'UnauthorizedError'
      res.send 401, 'Unauthorized'

  app.use '/static', require('./middleware/mincer').server

  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler()

routes.init app
