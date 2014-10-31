express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http
copyDereferenceSync = require('copy-dereference').sync
RSVP = require 'rsvp'
rimraf = RSVP.denodeify(require('rimraf'))
broccoli = require('broccoli')

app.use express.static(__dirname + '/dist')

io.on 'connection', (socket) ->
  console.log 'a user connected'
  socket.on 'click', ->
    console.log 'click'
    socket.broadcast.emit 'change background',
      for: 'everyone'


publicDirectory = 'dist'
publicDirectoryPath = __dirname + '/' + publicDirectory
brocTree = broccoli.loadBrocfile()
builder = new broccoli.Builder(brocTree);


RSVP.resolve()
.then ->
  rimraf publicDirectoryPath
.then ->
  builder.build()
.then (hash) ->
  copyDereferenceSync hash.directory, publicDirectoryPath

  port = process.env.PORT or 8000
  
  http.listen port, ->
    console.log 'listening on port', port

.catch (error) ->
  console.log 'error', error, error.stack
