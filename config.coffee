module.exports = (env) ->
  root: __dirname
  build:
    directory: __dirname + '/dist'
    vendorScriptFiles: ['bower_components/socket.io-client/socket.io.js']
