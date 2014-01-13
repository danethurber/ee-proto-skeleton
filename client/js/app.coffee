#= require ./../components/jquery/jquery.js
#= require ./../components/underscore/underscore.js
#= require ./../components/handlebars/handlebars.js
#= require ./../components/ember/ember.js
#= require ./../components/ember-data/ember-data.js
#= require ./../components/ember-simple-auth/ember-simple-auth.js
#= require ./../components/underscore/underscore.js

#= require_self
#= require_tree ./../templates

DS.HyperAdapter = DS.RESTAdapter.extend
  find: (store, type, id) ->
    if @isHyperModel type
      path = @buildHyperPath type
      @follow path
    else
      @._super.apply @, arguments

  follow: (path, data={}) ->
    next = path.shift()
    url = if data[next]? then data[next].href else next

    @ajax(url, 'GET').then (res) =>
      if Ember.isEmpty(path) then res else @follow(path, res)

  isHyperModel: (type) ->
    type.isClass and type.hyper

  buildHyperPath: (type) ->
    throw new Error 'hyperPath must be set' if not type.hyperPath

    path = type.hyperPath.split '.'
    path.unshift @urlPrefix()
    path

Ember.Application.initializer
  name: 'authentication'
  initialize: (container, application) ->
    Ember.SimpleAuth.setup container, application


App = Ember.Application.create
  ApplicationAdapter: DS.HyperAdapter

DS.HyperAdapter.reopen
  namespace: 'api'

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
    req = @store.find('user', 1)

# CONTROLLERS
App.LoginController = Ember.Controller.extend Ember.SimpleAuth.LoginControllerMixin
