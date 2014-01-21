User = require '../models/user'

module.exports =

  create: (req, res) ->
    if req.user
      User.createUserToken req.user.email, (err, token) ->
        if err
          res.json 400, error: 'Error generating token'
        else
          res.json access_token: token
    else
      res.json 400, error: "AuthError"

