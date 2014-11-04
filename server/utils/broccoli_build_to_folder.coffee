broccoli = require 'broccoli'
RSVP = require 'rsvp'
rimraf = RSVP.denodeify require('rimraf')
copyDereferenceSync = require('copy-dereference').sync
printSlowTrees = require 'broccoli-slow-trees'
TimerSequence = require '../../shared/timer_sequence'

module.exports = (tree, directory) ->
  builder = new broccoli.Builder(tree);

  timer = new TimerSequence().start()
  buildHash = null

  RSVP.resolve()
  .then ->
    rimraf directory

  .then ->
    timer.time 'rm'
    builder.build()

  .then (hash) ->
    buildHash = hash
    timer.time 'build'
    copyDereferenceSync hash.directory, directory

  .then (result) ->
    timer.time 'copy'
    RSVP.resolve ->
      console.log "\nbuilt in #{timer.total}ms (rm #{timer.rm}ms, build #{timer.build}ms, copy #{timer.copy}ms)"
      printSlowTrees buildHash.graph

  .catch (error) ->

    console.log 'Error building client files', error, error.stack
    RSVP.reject error
