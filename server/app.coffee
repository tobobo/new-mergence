express = require 'express'
http = require 'http'
compression = require 'compression'
path = require 'path'

socket = require './socket'

module.exports = (config) ->
  app = express()

  app.set 'config', config

  http = http.Server app
  app.set 'http', http
  socket app

  app.use compression()

  buildDirectory = path.join config.root, config.build.directory
  app.use express.static(path.join(buildDirectory, 'assets'), { maxAge: 86400000 })
  app.use express.static(buildDirectory, { maxAge: 0 })

  module.exports = app
