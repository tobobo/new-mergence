filterCoffeescript = require 'broccoli-coffee'

prepareCommon = require './prepare_common'
concatenateScripts = require './concatenate_scripts'

module.exports = (app, common, vendor, options) ->

  uglify = options.uglify or false

  # prepare and merge common script files
  app = prepareCommon app, common

  # transpile app scripts to JS
  app = filterCoffeescript app

  # prepare app scripts
  concatenateScripts app, vendor,
    uglify: uglify
