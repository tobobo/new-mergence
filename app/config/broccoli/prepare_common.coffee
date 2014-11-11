glob = require 'glob'
path = require 'path'
replace = require 'broccoli-string-replace'
pickFiles = require 'broccoli-static-compiler'
mergeTrees = require 'broccoli-merge-trees'

module.exports = (app, common) ->

  # get list of common files cause replace can't handle glob patterns
  commonFileList = glob.sync(path.join(common, '**/*')).map (filename) ->
    path.relative common, filename

  # get rid of #server #/server blocks in common
  common = replace common,
    files: commonFileList
    patterns: [
      match: /#server[\s\S]+#\/server/g
      replacement: ''
    ]

  # move common assets to common folder
  common = pickFiles common,
    srcDir: '/'
    destDir: 'common'

  # merge with rest of scripts
  merged = mergeTrees [common, app]

  return merged
