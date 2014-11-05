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
fileListFromObject = require './server/utils/file_list_from_object'

config = require('./config')()

buildOptions = config?.build or {}

vendorScriptFiles = buildOptions.vendorScriptFiles or []
toneFiles = buildOptions.toneFiles or []

vendorFileList = fileListFromObject vendorScriptFiles

shared = buildOptions.shared or 'shared'
scripts = buildOptions.scripts or 'client/scripts'
styles = buildOptions.styles or 'client/styles'

# pick HTML files

html = pickFiles 'client',
  srcDir: '/'
  files: ['**/*.html']
  destDir: '/'


# prepare shared files

sharedFileList = glob.sync(path.join(shared, '**/*')).map (filename) ->
  path.relative shared, filename

shared = replace shared,
  files: sharedFileList
  patterns: [
    match: /#server[\s\S]+#\/server/g
    replacement: ''
  ]

wrappedShared = pickFiles shared,
  srcDir: '/'
  destDir: '/shared'


# merge shared files with scripts

scripts = mergeTrees [wrappedShared, scripts]


# prepare app scripts

scripts = filterCoffeescript scripts

scripts = browserify scripts,
  entries: ['./app']
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
