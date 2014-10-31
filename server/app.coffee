express = require 'express'
http = require 'http'
RSVP = require 'rsvp'
compression = require 'compression'

socket = require './socket'

module.exports = (config) ->
  app = express()

  app.set 'config', config

  http = http.Server app
  app.set 'http', http

  app.use compression()

  socket app

  unless app.get('config')?.build?.directory?
    console.log 'You must specify a build directory in config.coffee to run this app.'
    process.exit 1

  app.use express.static(app.get('config').build.directory)

  buildFrontend = require('./broccoli_build') app

  app.set 'startServer', ->
    RSVP.resolve().then ->
      buildFrontend()

    .then ->
      port = process.env.PORT or 8000
      app.get('http').listen port, ->
        console.log 'listening on port', port

    .catch (error) ->
      console.log 'server startup error', error, error.stack

  module.exports = app
