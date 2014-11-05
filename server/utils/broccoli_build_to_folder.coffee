broccoli = require 'broccoli'
RSVP = require 'rsvp'
chalk = require 'chalk'
rimraf = RSVP.denodeify require('rimraf')
fs = require 'fs'
copyDereferenceSync = require('copy-dereference').sync
printSlowTrees = require 'broccoli-slow-trees'
TimerSequence = require '../../shared/timer_sequence'

module.exports = (tree, directory) ->
  builder = new broccoli.Builder(tree);

  timer = new TimerSequence().start()
  buildHash = null

  RSVP.resolve()
  .then ->
    if fs.existsSync directory
      rimraf directory

  .then ->
    timer.time 'fs'
    builder.build()

  .then (hash) ->
    buildHash = hash
    timer.time 'broccoli'

    fs.linkSync hash.directory, directory

  .then ->
    timer.time 'fs'
    RSVP.resolve ->
      console.log chalk.green("\nbuild successful #{timer.total}ms (broccoli #{timer.broccoli}ms, fs #{timer.fs}ms)")
      printSlowTrees buildHash.graph

  .catch (error) ->
    console.log chalk.red('error building client files')
    if error.stack?
      console.log error.stack
    else if error?
      console.log error
    RSVP.reject error
