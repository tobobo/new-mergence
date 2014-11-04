express = require 'express'
http = require 'http'
RSVP = require 'rsvp'
compression = require 'compression'
broccoliBuildToFolder = require('./utils/broccoli_build_to_folder')
path = require 'path'

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

  buildDirectory = path.resolve config.root, config.build.directory

  app.use express.static(buildDirectory)

  app.set 'startServer', ->
    RSVP.resolve().then ->
      broccoliTree = require('./broccoli_tree') app
      broccoliBuildToFolder broccoliTree, buildDirectory

    .then (logBuildResult) ->
      logBuildResult()

      port = process.env.PORT or 8000
      app.get('http').listen port, ->
        console.log config.serverListenMessage

    .catch (error) ->
      console.log 'server startup error', error, error.stack

  module.exports = app
