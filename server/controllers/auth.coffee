jwt = require 'jsonwebtoken'

# TODO: move user fixture to centralized file
userFixture =
  id: 1
  first_name: 'Dane'
  last_name: 'Thurber'
  username: 'dane.thurber'
  password: 'password'

module.exports =

  token: (req, res) ->
    user =
      username: req?.body?.username
      password: req?.body?.password

    # TODO: put secret in a config file using an ENV var
    if user.username is userFixture.username and user.password is userFixture.password
      token = jwt.sign userFixture, 'kittens', { expiresInMinutes: 300 }

      res.json
        token_type: 'bearer'
        access_token: token

    else
      res.json 400,
        error: "invalid_grant"
