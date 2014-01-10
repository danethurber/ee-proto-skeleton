path = require 'path'

stack = require 'simple-stack-common'
expressJwt = require 'express-jwt'

routes = require './config/routes'

module.exports = app = stack()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  # TODO: put secret in a config file using an ENV var
  app.useBefore 'router', '/api', 'express-jwt', expressJwt { secret: 'kittens' }

  app.use '/', 'error-intercept', (err, req, res) ->
    if err.constructor.name is 'UnauthorizedError'
      res.send 401, 'Unauthorized'

  app.useBefore 'router', '/static', 'mincer', require('./middleware/mincer').server

routes.init app
