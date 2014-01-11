jwt = require 'jsonwebtoken'

# TODO: put secret in a config file using an ENV var
# TODO: test and cleanup
module.exports = (req, res, next) ->
  secret = 'kittens'

  if req.headers?.authorization
    parts = req.headers.authorization.split(' ')

    if parts.length is 2
      token_type = parts[0]
      token = parts[1]

      if not /^Bearer$/i.test token_type
        return res.send 401, 'bad token format'
    else
      return res.send 401, 'bad token format'

  else
    return res.send 401, 'token required'

  jwt.verify token, secret, {}, (err, decoded) ->
    if err
      return res.send 401, 'invalid token'

    req.user = decoded

    next()
