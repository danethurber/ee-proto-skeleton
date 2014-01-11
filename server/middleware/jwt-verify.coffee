jwt = require 'jsonwebtoken'

# TODO: put secret in a config file using an ENV var
# TODO: return 401 on unauthorized requests instead of just logging errors
# TODO: test and cleanup
module.exports = (req, res, next) ->
  secret = 'kittens'

  if req.headers?.authorization
    parts = req.headers.authorization.split(' ')

    if parts.length is 2
      token_type = parts[0]
      token = parts[1]

      if not /^Bearer$/i.test token_type
        console.error 'bad token format'
    else
      console.error 'bad token format'

  else
    console.error 'token required'

  jwt.verify token, secret, {}, (err, decoded) ->
    if err
      console.error 'invalid token'

    req.user = decoded

    next()
