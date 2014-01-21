mongoose = require 'mongoose'

mongoose.connect process.env.MONGO_URL

console.log 'Dumping database'
mongoose.connection.db.dropDatabase();

process.exit()
