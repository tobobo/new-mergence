mergeTrees = require 'broccoli-merge-trees'
pickFiles = require 'broccoli-static-compiler'
assetRev = require 'broccoli-asset-rev'

module.exports = (html, scripts, styles) ->

  assets = mergeTrees [
    scripts
    styles
  ]

  assets = pickFiles assets,
    srcDir: '/'
    destDir: '/assets'

  merged = mergeTrees [assets, html]

  assetRev merged,
    extensions: ['js', 'css', 'png', 'jpg', 'gif']
    replaceExtensions: ['html', 'css', 'js']
