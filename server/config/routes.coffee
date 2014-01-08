home = require '../controllers/home'
auth = require '../controllers/auth'

module.exports =
  init: (app) ->

    app.post '/auth', auth.auth

    app.get '/', home.index
