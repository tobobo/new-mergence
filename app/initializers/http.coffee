http = require 'http'

module.exports = (app) ->
  server = http.Server app
  config = app.get('config')

  app.set 'server', server

  server.listen config.port, ->
    console.log config.serverListenMessage or "listening on port #{config.port}..."
