app = require('express')()
http = require('http').Server app
io = require('socket.io') http

app.get '/', (req, res) ->
  res.sendFile 'index.html',
    root: __dirname

io.on 'connection', (socket) ->
  console.log 'a user connected'
  socket.on 'click', ->
    console.log 'click'
    socket.broadcast.emit 'change background',
      for: 'everyone'

port = process.env.PORT or 8000

http.listen port, ->
  console.log 'listening on port', port
