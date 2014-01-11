User = require '../models/user'

module.exports =

  index: (req, res) ->
    User.find (err, users) ->
      res.json users

  create: (req, res) ->
    user = new User req.body.user

    user.save (err) ->
      if not err
        res.send '201', user
      else
        res.send '403'

  show: (req, res) ->
    User.findById req.params.id, (err, user) ->
      if not err
        res.send user
      else
        res.send '404', user
