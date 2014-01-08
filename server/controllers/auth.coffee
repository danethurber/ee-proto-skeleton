jwt = require 'jsonwebtoken'

# TODO: move user fixture to centralized file
userFixture =
  id: 1
  first_name: 'Dane'
  last_name: 'Thurber'
  username: 'dane.thurber'
  password: 'password'

module.exports =

  auth: (req, res) ->
    user =
      username: req?.body?.username
      password: req?.body?.password

    if user.username is userFixture.username and user.password is userFixture.password
      token = jwt.sign userFixture, 'kittens', { expiresInMinutes: 300 }
      res.json { token: token }
    else
      res.send 401, 'Wrong username or Password'
