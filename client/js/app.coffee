#= require ./../components/jquery/jquery.js
#= require ./../components/underscore/underscore.js
#= require ./../components/handlebars/handlebars.js
#= require ./../components/ember/ember.js
#= require ./../components/ember-data/ember-data.js
#= require ./../components/ember-simple-auth/ember-simple-auth.js
#= require ./../components/underscore/underscore.js

#= require_self
#= require_tree ./../templates

Ember.Application.initializer
  name: 'authentication'
  initialize: (container, application) ->
    Ember.SimpleAuth.setup container, application

App = Ember.Application.create()

DS.RESTAdapter.reopen
  namespace: 'api'

  follow: (path, data={}) ->
    return if Ember.isEmpty path

    next = path.shift()
    url = if data[next]? then data[next].href else next

    Ember.$.get(url).then (res) =>
      if Ember.isEmpty path
        res
      else
        @follow path, res

  buildURL: (type, id) ->
    klass = App[type.classify()]

    if klass.isClass and klass.hyper
      throw new Error 'hyperPath must be set' if not klass.hyperPath

      path = klass.hyperPath.split '.'
      path.unshift @urlPrefix()

      req = @follow(path)
        .then (data) ->
          href = data.href
          console.log "href: #{href}"

        # TODO: this function needs to return the resource url
        #       how do i do that???
    else
      s = @._super.apply @, arguments

    s = @._super.apply @, arguments

App.Router.map () ->
  @route 'login'
  @route 'test'

# MODELS
App.User = DS.Model.extend
  email: DS.attr 'string'

App.User.reopenClass
  hyper: true
  hyperPath: "account.root.account.root.account.root.account"

App.UserSerializer = DS.RESTSerializer.extend
  normalizePayload: (type, payload) ->
    user: _(payload).pick 'id', 'email'

# ROUTES
App.ApplicationRoute = Ember.Route.extend Ember.SimpleAuth.ApplicationRouteMixin

App.TestRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: () ->
    @store.find 'user', 1

# CONTROLLERS
App.LoginController = Ember.Controller.extend Ember.SimpleAuth.LoginControllerMixin
