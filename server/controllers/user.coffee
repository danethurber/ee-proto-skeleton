User = require '../models/user'

module.exports =

  create: (req, res) ->
    temp = new User
      first_name: req.body.first_name
      last_name: req.body.last_name
      email: req.body.email

    User.register temp, req.body.password, (err, user) ->
      if err
        res.json 400
      else
        res.json 200, user: user

  # index: (req, res) ->
  #   User.find (err, users) ->
  #     res.json users

  # show: (req, res) ->
  #   User.findById req.params.id, (err, user) ->
  #     if not err
  #       res.send user
  #     else
  #       res.send '404', user
