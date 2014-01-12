superagent = require 'superagent'

home = require '../controllers/home'
auth = require '../controllers/auth'
user = require '../controllers/user'

module.exports =
  init: (app) ->
    app.post '/token', auth.token


    # mock hypermedia responses
    app.get '/api', (req, res) ->
      res.json
        href: 'http://localhost:5000/api'
        users:
          href: 'http://localhost:5000/api/users'
        account:
          href: 'http://localhost:5000/api/users/1'

    app.get '/api/users', (req, res) ->
      res.json
        href: 'http://localhost:5000/api/users'
        root:
          href: 'http://localhost:5000/api'
        data: [{
          ref: 'http://localhost:5000/api/users/1'
        }]

    app.get '/api/users/:id', (req, res) ->
      superagent.get 'http://api.randomuser.me/0.2/', (data) ->
        user = data.body.results[0].user
        res.json
          id: 123
          href: 'http://localhost:5000/api/users/1'
          root:
            href: 'http://localhost:5000/api'
          first_name: user.name.first
          last_name: user.name.last
          email: user.email
          avatar:
            src: user.picture

    # app.get '/api/users', user.index
    # app.post '/api/users', user.create
    # app.get '/api/users/:id', user.show

    app.get '/', home.index
