rsvp = require 'rsvp'
glob = require 'glob'
path = require 'path'
concat = require 'broccoli-concat'
mergeTrees = require 'broccoli-merge-trees'
pickFiles = require 'broccoli-static-compiler'
filterCoffeescript = require 'broccoli-coffee'
browserify = require 'broccoli-browserify'
uglifyJS = require 'broccoli-uglify-js'
replace = require 'broccoli-string-replace'
assetRev = require 'broccoli-asset-rev'
fileListFromObject = require './app/util/file_list_from_object'

config = require('./config')()

buildOptions = config?.build or {}

vendorScriptFiles = buildOptions.vendorScriptFiles or []
toneFiles = buildOptions.toneFiles or []

vendorFileList = fileListFromObject vendorScriptFiles

common = buildOptions.common or 'app/common'
client = buildOptions.client or 'app/client'
scripts = buildOptions.scripts or path.join(client, 'scripts')
styles = buildOptions.styles or path.join(client, 'styles')

# pick HTML files

html = pickFiles client,
  srcDir: '/'
  files: ['**/*.html']
  destDir: '/'


# prepare common files

commonFileList = glob.sync(path.join(common, '**/*')).map (filename) ->
  path.relative common, filename

common = replace common,
  files: commonFileList
  patterns: [
    match: /#server[\s\S]+#\/server/g
    replacement: ''
  ]

wrappedCommon = pickFiles common,
  srcDir: '/'
  destDir: '/common'


# merge common files with scripts

scripts = mergeTrees [wrappedCommon, scripts]


# prepare app scripts

scripts = filterCoffeescript scripts

scripts = browserify scripts,
  entries: ['./index']
  outputFile: './app.js'


# concatenate vendor scripts

vendorScripts = concat '.',
  inputFiles: vendorFileList
  outputFile: '/vendor.js'


# uglify scripts if in production

if config.env == 'production'
  scripts = uglifyJS scripts

  vendorScripts = uglifyJS vendorScripts,
    mangle: true


# process app styles

styles = concat styles,
  inputFiles: ['**/*.css']
  outputFile: '/app.css'


# merge all static assets and put in assets folder (non-HTML)

assets = mergeTrees [
  scripts
  vendorScripts
  styles
]

assets = pickFiles assets,
  srcDir: '/'
  destDir: '/assets'


# merge assets with html

merged = mergeTrees [assets, html]


# fingerprint assets

fingerprinted = assetRev merged,
  extensions: ['js', 'css', 'png', 'jpg', 'gif']
  replaceExtensions: ['html', 'css', 'js']


# the tree is complete!

module.exports = fingerprinted
