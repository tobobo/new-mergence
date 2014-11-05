express = require 'express'

module.exports = (config) ->
  app = express()
  app.set 'config', config

  app.set 'start', ->
    require('./initializers') app

  module.exports = app
