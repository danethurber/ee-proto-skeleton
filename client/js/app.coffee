#= require ./../components/jquery/jquery.js
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

App.Router.map () ->
  @route 'login'
  @route 'test'

App.ApplicationRoute = Ember.Route.extend Ember.SimpleAuth.ApplicationRouteMixin

App.TestRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: () ->
    Ember.$.getJSON '/api'

App.LoginController = Ember.Controller.extend Ember.SimpleAuth.LoginControllerMixin
