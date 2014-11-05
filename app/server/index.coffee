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

  buildPath = path.join config.root, config.build.path
  app.use express.static(path.join(buildPath, 'assets'), { maxAge: 86400000 })
  app.use express.static(buildPath, { maxAge: 0 })

  module.exports = app
