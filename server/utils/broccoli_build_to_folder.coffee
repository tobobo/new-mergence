broccoli = require 'broccoli'
RSVP = require 'rsvp'
rimraf = RSVP.denodeify require('rimraf')
copyDereferenceSync = require('copy-dereference').sync
printSlowTrees = require 'broccoli-slow-trees'

module.exports = (tree, directory) ->
  builder = new broccoli.Builder(tree);

  start = new Date()
  buildStart = copyStart = rmTime = buildTime = copyTime = 0
  buildHash = null

  RSVP.resolve()
  .then ->
    rimraf directory
  .then ->
    rmTime = new Date() - start
    buildStart = new Date()
    builder.build()
  .then (hash) ->
    buildHash = hash
    buildTime = new Date() - buildStart
    copyStart = new Date()
    copyDereferenceSync hash.directory, directory
  .then (result) ->
    copyTime = new Date() - copyStart
    totalTime = rmTime + buildTime + copyTime

    RSVP.resolve ->
      console.log "\nbuilt in #{totalTime}ms (rm #{rmTime}ms, build #{buildTime}ms, copy #{copyTime}ms)"
      printSlowTrees buildHash.graph

  .catch (error) ->

    console.log 'Error building client files', error, error.stack
    RSVP.reject error
