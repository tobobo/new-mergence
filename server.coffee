RSVP = require 'rsvp'

config = require('./config') process.env.NODE_ENV or 'development'

app = require('./server/app') config

buildFrontend = require('./server/build') app

RSVP.resolve().then ->
  buildFrontend()

.then ->
  port = process.env.PORT or 8000
  app.get('http').listen port, ->
    console.log 'listening on port', port

.catch (error) ->
  console.log 'server startup error', error, error.stack
