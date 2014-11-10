RSVP = require 'rsvp'

module.exports = (app) ->
  RSVP.resolve()
  .then ->
    require('./build') app
  .then ->
    require('./routes') app
    require('./http') app
    require('./socket') app

  .catch (error) ->
    console.log 'server startup error', error, error.stack
