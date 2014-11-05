RSVP = require 'rsvp'
path = require 'path'

config = require('./config')()

app = require('./app/server') config

buildClient = require './app/build'

unless config.build?.path?
  console.log 'You must specify a build path in config.coffee to run this app.'
  process.exit 1

buildPath = path.resolve config.root, config.build.path

RSVP.resolve()
.then ->
  buildClient path.join(config.root, 'Brocfile'), buildPath

.then ->
  app.get('http').listen config.port, ->
    console.log config.serverListenMessage or "listening on port #{config.port}..."

.catch (error) ->
  console.log 'server startup error', error, error.stack
