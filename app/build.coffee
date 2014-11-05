broccoli = require 'broccoli'
RSVP = require 'rsvp'
chalk = require 'chalk'
rimraf = require('rimraf')
fs = require 'fs'
copyDereferenceSync = require('copy-dereference').sync
printSlowTrees = require 'broccoli-slow-trees'
TimerSequence = require './util/timer_sequence'

module.exports = (brocfilePath, directory) ->
  timer = new TimerSequence().start()
  buildHash = null

  RSVP.resolve()
  .then ->
    tree = require brocfilePath
    builder = new broccoli.Builder(tree);
    timer.time 'load'

    builder.build()

  .then (hash) ->
    timer.time 'broccoli'

    if fs.existsSync directory
      rimraf.sync directory
    fs.symlinkSync hash.directory, directory
    timer.time 'fs'

    console.log chalk.green(
      "\nbuild succeeded in #{timer.total}ms " +
      "(load #{timer.load}ms, " +
      "broccoli #{timer.broccoli}ms, " +
      "fs #{timer.fs}ms)"
    )
    printSlowTrees hash.graph

  .catch (error) ->
    console.log chalk.red('error building client files')
    if error?.stack?
      console.log error.stack
    else if error?
      console.log error
    RSVP.reject error
