socketIO = require('socket.io')

module.exports = (app) ->
  io = socketIO app.get('server')
  app.set 'io', io

  io.on 'connection', (socket) ->
    console.log "#{socket.id} connected"

    socket.on 'click', ->
      console.log "#{socket.id} clicked"

      socket.broadcast.emit 'someone clicked',
        for: 'everyone'

    socket.on 'disconnect', ->
      console.log "#{socket.id} disconnected"
