broccoli = require 'broccoli'
RSVP = require 'rsvp'
rimraf = RSVP.denodeify require('rimraf')
copyDereferenceSync = require('copy-dereference').sync

module.exports = (tree, directory) ->
  builder = new broccoli.Builder(tree);

  RSVP.resolve()
  .then ->
    rimraf directory
  .then ->
    builder.build()
  .then (hash) ->
    copyDereferenceSync hash.directory, directory
  .catch (error) ->
    console.log 'Error building client files', error, error.stack
    RSVP.reject error
