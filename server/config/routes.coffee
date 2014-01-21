superagent = require 'superagent'
passport = require 'passport'

auth = require '../middleware/auth'

home = require '../controllers/home'
session = require '../controllers/session'
token = require '../controllers/token'
user = require '../controllers/user'

module.exports =
  init: (app) ->

    # mock hypermedia responses
    app.get '/api', auth.ensureAuthenticated(), (req, res) ->
      res.json
        href: 'http://localhost:5000/api'
        users:
          href: 'http://localhost:5000/api/users'
        account:
          href: 'http://localhost:5000/api/users/1'

    app.get '/api/users', auth.ensureAuthenticated(), (req, res) ->
      res.json
        href: 'http://localhost:5000/api/users'
        root:
          href: 'http://localhost:5000/api'
        data: [{
          ref: 'http://localhost:5000/api/users/1'
        }]

    app.get '/api/users/:id', auth.ensureAuthenticated(), (req, res) ->
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

    app.post '/register', user.create

    app.post '/token', passport.authenticate('local', session: false), token.create
    app.post '/login', session.create
    app.post '/logout', session.destroy

    app.get '/', home.index
