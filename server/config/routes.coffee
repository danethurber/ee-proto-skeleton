home = require '../controllers/home'
auth = require '../controllers/auth'
api = require '../controllers/api'
user = require '../controllers/user'

module.exports =
  init: (app) ->

    app.post '/token', auth.token

    app.get '/api', api.index

    app.get '/api/users', user.index
    app.post '/api/users', user.create
    app.get '/api/users/:id', user.show

    app.get '/', home.index
