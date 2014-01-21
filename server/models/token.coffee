config = require 'config'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TokenSchema = new Schema
  token:
    type: String
  date_created:
    type: Date
    default: Date.now

TokenSchema.methods.hasExpired = () ->
  now = new Date()
  (now.getTime() - @date_created.getTime()) > config.token.ttl

module.exports = mongoose.model 'Token', TokenSchema
