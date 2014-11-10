broccoli = require 'broccoli'
RSVP = require 'rsvp'
chalk = require 'chalk'
path = require 'path'
printSlowTrees = require 'broccoli-slow-trees'
TimerSequence = require '../util/timer_sequence'

module.exports = (app) ->
  config = app.get('config')
  brocfilePath = path.join(config.root, 'Brocfile')

  timer = new TimerSequence().start()

  RSVP.resolve()
  .then ->
    tree = require brocfilePath
    builder = new broccoli.Builder(tree);
    timer.time 'load'

    builder.build()

  .then (hash) ->
    timer.time 'broccoli'

    console.log chalk.green(
      "\nbuild succeeded in #{timer.total}ms " +
      "(load #{timer.load}ms, " +
      "broccoli #{timer.broccoli}ms)"
    )
    printSlowTrees hash.graph

    app.set 'buildPath', hash.directory

    RSVP.resolve app.get('buildPath')

  .catch (error) ->
    console.log chalk.red('error building client files')
    if error?.stack?
      console.log error.stack
    else if error?
      console.log error
    RSVP.reject error
