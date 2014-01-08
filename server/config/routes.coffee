home = require '../controllers/home'

module.exports =
  init: (app) ->
    app.get '/', home.index
