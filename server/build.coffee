concat = require 'broccoli-concat'
mergeTrees = require 'broccoli-merge-trees'
pickFiles = require 'broccoli-static-compiler'
rsvp = require 'rsvp'
broccoliBuildToFolder = require './utils/broccoli_build_to_folder'

module.exports = (app) ->
  ->
    buildOptions = app.get('config')?.build or {}
    publicDirectoryPath = buildOptions.directory

    vendorScriptFiles = buildOptions.vendorScriptFiles or []
    scripts = buildOptions.scripts or 'client/scripts'
    styles = buildOptions.styles or 'client/styles'

    html = pickFiles 'client',
      srcDir: '/'
      files: ['**/*.html']
      destDir: '/'

    scripts = concat scripts,
      inputFiles: ['**/*.js']
      outputFile: '/app.js'

    vendorScripts = concat '.',
      inputFiles: vendorScriptFiles
      outputFile: '/vendor.js'

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
