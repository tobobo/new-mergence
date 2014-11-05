RSVP = require 'rsvp'

module.exports = (app) ->
  RSVP.resolve()
  .then ->
    require('./build') app

  .then ->
    require('./routes') app

  .then ->
    require('./http') app

  .then ->
    require('./socket') app

  .catch (error) ->
    console.log 'server startup error', error, error.stack
