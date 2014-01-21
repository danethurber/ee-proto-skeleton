throw new Error 'Seeds cannot be run in production' if process.env.NODE_ENV is 'production'

console.log 'Seeding Dev Database'

fs = require 'fs'
path = require 'path'
mongoose = require 'mongoose'

dbUrl = process.env.MONGO_URL
mongoose.connect dbUrl

db = mongoose.connection
db.once 'open', () -> console.log "Connected To Database: #{dbUrl}"
db.on 'error', () -> throw new Error "Unable to Connect To Database: #{dbUrl}"

loadModels = ( () ->
  p = path.join __dirname, '..', 'models'

  fs.readdirSync(p).forEach (file) ->
    newPath = p + '/' + file
    stat = fs.statSync newPath

    if stat.isFile()
      if /(.*)\.(js$|coffee$)/.test file
        require(newPath)
    else if stat.isDirectory()
      loadModels newPath

).call()


User = require '../models/user'

users = [
  {
    first_name: 'Dane'
    last_name: 'Thurber'
    email: 'dane.thurber@gmail.com'
    password: 'password'
  }
]

for user in users
  console.log 'seeding'
  console.log user
  tmp = new User user
  tmp.save()


console.log 'Seeding Finished'
process.exit()
