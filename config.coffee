module.exports = (env) ->
  root: __dirname
  port: process.env.PORT or 8000
  build:
    directory: __dirname + '/dist'
    vendorScriptFiles: ['bower_components/socket.io-client/socket.io.js']
