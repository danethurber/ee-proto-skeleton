module.exports =

  # NOTE: this is testing the auth middleware
  #       remove this or replace with a hypermedia manifest
  index: (req, res) ->
    res.json { key: 'value' }
