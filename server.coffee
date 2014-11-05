RSVP = require 'rsvp'
path = require 'path'

config = require('./config')()

app = require('./server/app') config

broccoliBuildToFolder = require './server/utils/broccoli_build_to_folder'

unless config.build?.directory?
  console.log 'You must specify a build directory in config.coffee to run this app.'
  process.exit 1

buildDir = path.resolve config.root, config.build.directory

RSVP.resolve()
.then ->
  broccoliBuildToFolder path.join(config.root, 'Brocfile'), buildDir

.then ->
  app.get('http').listen config.port, ->
    console.log config.serverListenMessage or "listening on port #{config.port}..."

.catch (error) ->
  console.log 'server startup error', error, error.stack
