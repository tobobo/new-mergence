concat = require 'broccoli-concat'
uglifyJS = require 'broccoli-uglify-js'
browserify = require 'broccoli-browserify'
mergeTrees = require 'broccoli-merge-trees'

module.exports = (app, vendor, options) ->
  uglify = options?.uglify or false

  # browserify app scripts
  app = browserify app,
    entries: ['./index']
    outputFile: './app.js'

  # concatenate vendor scripts
  vendor = concat '.',
    inputFiles: vendor
    outputFile: '/vendor.js'

  # uglify scripts if specified
  if uglify
    app = uglifyJS app

    vendor = uglifyJS vendor,
      mangle: true

  # combine app scripts with vendor scripts
  mergeTrees [app, vendor]
