module.exports =

  create: (req, res) ->
    res.render 'login'

  destroy: (req, res) ->
    req.logout()
    req.redirect '/'
