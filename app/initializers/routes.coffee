path = require 'path'
compression = require 'compression'
express = require 'express'

module.exports = (app) ->
  config = app.get('config')

  app.use compression()

  buildPath = app.get('buildPath')
  assetsPath = path.join(buildPath, 'assets')

  app.use express.static(assetsPath, { maxAge: 86400000 })
  app.use express.static(buildPath, { maxAge: 0 })
