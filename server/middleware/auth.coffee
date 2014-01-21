User = require '../models/user'

exports.ensureAuthenticated = (options) ->

  (req, res, next) ->
    token = req.headers?.authorization

    if token? and token.length > 0
      token = token.split(' ')[1]

    try decoded = User.decode token
    catch e
      res.json 401, error: 'Issue decoding incoming token.'

    if decoded and decoded.email
      User.findUser decoded.email, token, (err, user) ->
       if err
        res.json 401, error: 'User not Found'
       else
        next()
    else
      res.json 401, error: 'Issue decoding incoming token.'
