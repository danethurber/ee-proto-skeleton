User = require '../models/user'

module.exports =

  create: (req, res) ->
    if req.user
      User.createToken(req.user.email)
        .then (token) ->
          res.json access_token: token
        .fail ->
          res.json 400, error: 'Error generating token'
    else
      res.json 400, error: "AuthError"
