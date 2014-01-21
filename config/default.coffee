pkg = require '../package.json'
path = require 'path'

rootDir = path.join __dirname, '..'
serverDir = path.join rootDir, 'server'
clientDir = path.join rootDir, 'client'

module.exports =
  version: pkg.version
  env: process.env.NODE_ENV or 'development'

  ports:
    server: process.env.PORT or 3000

  paths:
    root: rootDir
    views: path.join serverDir, 'views'
    assets: clientDir
