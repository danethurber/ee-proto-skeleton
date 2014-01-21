path = require('path')
crypto = require('crypto')
_ = require 'lodash'

mongoose = require('mongoose')
Schema = mongoose.Schema
jwt = require('jwt-simple')

ttl = 3600000
resetTokenExpiresMinutes = 20
tokenSecret = 'put-a-$Ecr3t-h3re'

TokenSchema = new Schema
  token:
    type: String
  date_created:
    type: Date
    default: Date.now

TokenSchema.methods.hasExpired = () ->
    now = new Date();
    return (now.getTime() - this.date_created.getTime()) > config.ttl

Token = mongoose.model 'Token', TokenSchema

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
  reset_token:
    type: String
  reset_token_expires_millis:
    type: Number

UserSchema.plugin require('passport-local-mongoose'), usernameField: 'email'

UserSchema.statics.encode = (data) ->
  jwt.encode data, tokenSecret

UserSchema.statics.decode = (data) ->
  jwt.decode data, tokenSecret

UserSchema.statics.findUser = (email, token, cb) ->
  @findOne email: email, (err, user) ->
    if err or not user
      cb err, null
    else if token is user.token.token
      cb false, _(user).pick 'email', 'token', 'date_created', 'first_name', 'last_name'
    else
      cb new Error('Token does not match.'), null

UserSchema.statics.findUserByEmailOnly = (email, cb) ->
  @findOne email: email, (err, user) ->
    if err or not user
      cb err, null
    else
      cb false, user

UserSchema.statics.createUserToken = (email, cb) ->
  @findOne email: email, (err, user) =>
    console.log(err) if err or not user

    user.token = new Token token: @encode(email: email)
    user.save (err, user) ->
      if err
        cb(err, null);
      else
        cb false, user.token.token

UserSchema.statics.generateResetToken = (email, cb) ->
  @findUserByEmailOnly email, (err, user) ->
    if err
      cb err, null
    else if user
      user.reset_token = crypto.randomBytes(32).toString('hex')
      now = new Date()
      expires = new Date(now.getTime() + (config.resetTokenExpiresMinutes * 60 * 1000)).getTime()
      user.reset_token_expires_millis = expires
      user.save()
      cb false, user
    else
      cb new Error('No user with that email found.'), null

module.exports = mongoose.model 'User', UserSchema
