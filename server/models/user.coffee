path = require 'path'
crypto = require 'crypto'
config = require 'config'

Q = require 'q'
jwt = require 'jwt-simple'

mongoose = require 'mongoose'
Schema = mongoose.Schema

BearerStrategy = require('passport-http-bearer').Strategy
Token = require './token'

UserSchema = new Schema
  email:
    type: String
    required: true
    lowercase: true
    index:
      unique: true
  first_name:
    type: String
    required: true
  last_name:
    type: String
    required: true
  date_created:
    type: Date
    default: Date.now
  token:
    type: Object

UserSchema.plugin require('passport-local-mongoose'), usernameField: 'email'

UserSchema.statics.encode = (data) ->
  jwt.encode data, config.token.secret

UserSchema.statics.decode = (data) ->
  jwt.decode data, config.token.secret

UserSchema.statics.createToken = (email) ->
  deferred = Q.defer()

  @findOne email: email, (err, user) =>
    if err or not user
      deferred.reject(err)

    user.token = new Token token: @encode(email: email)
    user.save (err, user) ->
      if err
        deferred.reject(err)
      else
        deferred.resolve user.token.token

  deferred.promise

UserSchema.statics.createBearerStrategy = () ->
  new BearerStrategy (token, done) =>
    @findOne @decode(token), (err, user=false) ->
      done(err) if err

      done null, user

module.exports = mongoose.model 'User', UserSchema
