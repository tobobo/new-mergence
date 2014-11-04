express = require 'express'
http = require 'http'
RSVP = require 'rsvp'
compression = require 'compression'
broccoliBuildToFolder = require('./utils/broccoli_build_to_folder')

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

  app.set 'startServer', ->
    RSVP.resolve().then ->
      broccoliTree = require('./broccoli_tree') app
      publicDirectoryPath = app.get('config').build?.directory

      broccoliBuildToFolder broccoliTree, publicDirectoryPath

    .then (logBuildResult) ->
      console.log '\nfrontend build complete'
      logBuildResult()

      port = process.env.PORT or 8000
      app.get('http').listen port, ->
        console.log 'listening on port', port

    .catch (error) ->
      console.log 'server startup error', error, error.stack

  module.exports = app
