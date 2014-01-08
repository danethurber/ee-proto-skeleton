home = require '../controllers/home'
auth = require '../controllers/auth'
api = require '../controllers/api'

module.exports =
  init: (app) ->

    app.post '/auth', auth.auth

    app.get '/api', api.index

    app.get '/', home.index
