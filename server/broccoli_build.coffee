rsvp = require 'rsvp'
concat = require 'broccoli-concat'
mergeTrees = require 'broccoli-merge-trees'
pickFiles = require 'broccoli-static-compiler'
filterCoffeescript = require 'broccoli-coffee'
browserify = require 'broccoli-browserify'
uglifyJS = require 'broccoli-uglify-js'
broccoliBuildToFolder = require './utils/broccoli_build_to_folder'

module.exports = (app) ->
  ->
    config = app.get('config')
    buildOptions = config?.build or {}
    publicDirectoryPath = buildOptions.directory

    vendorScriptFiles = buildOptions.vendorScriptFiles or []
    toneFiles = buildOptions.toneFiles or []

    toneFiles.forEach (file) ->
      vendorScriptFiles.push 'bower_components/tone/Tone/' + file

    scripts = buildOptions.scripts or 'client/scripts'
    styles = buildOptions.styles or 'client/styles'

    html = pickFiles 'client',
      srcDir: '/'
      files: ['**/*.html']
      destDir: '/'

    scripts = filterCoffeescript scripts

    scripts = browserify scripts,
      entries: ['./app']
      outputFile: './app.js'

    vendorScripts = concat '.',
      inputFiles: vendorScriptFiles
      outputFile: '/vendor.js'

    if config.env == 'production'
      scripts = uglifyJS scripts
      vendorScripts = uglifyJS vendorScripts

    styles = concat styles,
      inputFiles: ['**/*.css']
      outputFile: '/app.css'

    distTree = mergeTrees [
      html
      scripts
      vendorScripts
      styles
    ]

    broccoliBuildToFolder distTree, publicDirectoryPath
