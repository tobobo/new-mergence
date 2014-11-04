rsvp = require 'rsvp'
concat = require 'broccoli-concat'
mergeTrees = require 'broccoli-merge-trees'
pickFiles = require 'broccoli-static-compiler'
filterCoffeescript = require 'broccoli-coffee'
browserify = require 'broccoli-browserify'
uglifyJS = require 'broccoli-uglify-js'
replace = require 'broccoli-string-replace'
fileListFromObject = require './utils/file_list_from_object'

module.exports = (app) ->
  config = app.get('config')
  buildOptions = config?.build or {}

  vendorScriptFiles = buildOptions.vendorScriptFiles or []
  toneFiles = buildOptions.toneFiles or []

  vendorFileList = fileListFromObject vendorScriptFiles

  shared = buildOptions.shared or 'shared'
  scripts = buildOptions.scripts or 'client/scripts'
  styles = buildOptions.styles or 'client/styles'

  html = pickFiles 'client',
    srcDir: '/'
    files: ['**/*.html']
    destDir: '/'

  shared = replace shared,
    files: ['model.coffee']
    patterns: [
      match: /#server[\s\S]+#\/server/g
      replacement: ''
    ]

  wrappedShared = pickFiles shared,
    srcDir: '/'
    destDir: '/shared'

  scripts = mergeTrees [wrappedShared, scripts]

  scripts = filterCoffeescript scripts

  scripts = browserify scripts,
    entries: ['./app']
    outputFile: './app.js'

  vendorScripts = concat '.',
    inputFiles: vendorFileList
    outputFile: '/vendor.js'

  if config.env == 'production'
    scripts = uglifyJS scripts
    vendorScripts = uglifyJS vendorScripts

  styles = concat styles,
    inputFiles: ['**/*.css']
    outputFile: '/app.css'

  mergeTrees [
    html
    scripts
    vendorScripts
    styles
  ]
