module.exports = (env) ->
  env = env or process.env.NODE_ENV or 'development'
  port = process.env.PORT or 8000
  root = __dirname
  env: env
  root: root
  port: port
  server: 'server.coffee'
  serverListenMessage: "listening on port #{port}..."
  url: process.env.MERGENCE_URL or "http://localhost:#{port}"
  build:
    directory: './dist'
    vendorScriptFiles:
      'bower_components': [
        'socket.io-client/socket.io.js',
        'underscore/underscore-min.js',
        'tone/Tone':
          'core': ['Tone.js', 'Master.js']
          'source': ['Source.js', 'Oscillator.js']
          'signal': ['Signal.js']
          'component': ['Envelope.js']
      ]
