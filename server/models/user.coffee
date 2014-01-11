mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema
  first_name:
    type: String
  last_name:
    type: String
  username:
    type: String


module.exports = mongoose.model 'User', UserSchema
