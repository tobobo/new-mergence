express = require 'express'
http = require 'http'

socket = require './socket'

module.exports = (config) ->
  app = express()

  app.set 'config', config

  http = http.Server app
  app.set 'http', http

  socket app

  unless app.get('config')?.build?.directory?
    console.log 'You must specify a build directory in config.coffee to run this app.'
    process.exit 1

  app.use express.static(app.get('config').build.directory)

  module.exports = app
