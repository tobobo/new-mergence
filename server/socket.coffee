module.exports = (app) ->
  io = require('socket.io') app.get('http')

  io.on 'connection', (socket) ->
    console.log "#{socket.id} connected"

    socket.on 'click', ->
      console.log "#{socket.id} clicked"

      socket.broadcast.emit 'someone clicked',
        for: 'everyone'

    socket.on 'disconnect', ->
      console.log "#{socket.id} disconnected"
