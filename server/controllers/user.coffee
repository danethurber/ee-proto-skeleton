User = require '../models/user'

module.exports =

  index: (req, res) ->
    User.find (err, users) ->
      res.json users

  create: (req, res) ->
    if not req?.body?
      res.send 400, error: "registration error"

    data =
      email: req.body?.email
      first_name: req.body?.first_name
      last_name: req.body?.last_name

    User.register data, req.body.password, (err, user) ->
      if err
        console.log 'registration error'
        console.log err

        res.send 400, errors: err.message
      else
        res.send '201', user
