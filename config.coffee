module.exports = (env) ->
  port = process.env.PORT or 8000
  env: env
  root: __dirname
  port: port
  url: process.env.MERGENCE_URL or "http://localhost:#{port}"
  build:
    directory: __dirname + '/dist'
    vendorScriptFiles: ['bower_components/socket.io-client/socket.io.js']
