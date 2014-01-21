passport = require 'passport'

home = require '../controllers/home'
user = require '../controllers/user'
token = require '../controllers/token'
api = require '../controllers/api'

module.exports =
  init: (app) ->
    app.post '/register', user.create

    app.post '/token',
      passport.authenticate('local', session: false),
      token.create


    # app.get '/api', api.index

    # app.get '/api/users', user.index
    # app.post '/api/users', user.create
    # app.get '/api/users/:id', user.show

    app.get '/', home.index
