path = require 'path'

stack = require 'simple-stack-common'

routes = require './config/routes'

module.exports = app = stack()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  app.useBefore 'router', '/api', 'jwt-verify', require('./middleware/jwt-verify')
  app.useBefore 'router', '/static', 'mincer', require('./middleware/mincer').server

routes.init app
