path = require 'path'

stack = require 'simple-stack-common'
mongoose = require 'mongoose'

routes = require './config/routes'

dbUrl = process.env.MONGO_URL
mongoose.connect dbUrl

db = mongoose.connection
db.once 'open', () -> console.log "Connected To Database: #{dbUrl}"
db.on 'error', () -> throw new Error "Unable to Connect To Database: #{dbUrl}"


module.exports = app = stack()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'view engine', 'jade'
  app.set 'views',  path.join __dirname, 'views'

  # app.useBefore 'router', '/api', 'jwt-verify', require('./middleware/jwt-verify')
  app.useBefore 'router', '/static', 'mincer', require('./middleware/mincer').server

routes.init app
