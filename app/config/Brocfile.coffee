path = require 'path'
_ = require 'underscore'

pickHTML = require './broccoli/pick_html'
prepareScripts = require './broccoli/prepare_scripts'
prepareStyles = require './broccoli/prepare_styles'
packageAssets = require './broccoli/package_assets'

fileListFromObject = require '../util/file_list_from_object'

config = require('../../config')()

defaults =
  vendorScripts: []
  client: 'app/client'
  scripts: 'app/client/scripts'
  styles: 'app/client/styles'
  common: 'app/common'

opts = _.extend {}, defaults, config.build

# pick HTML files
html = pickHTML opts.client

# prepare scripts
scripts = prepareScripts opts.scripts, opts.common, fileListFromObject(opts.vendorScripts),
  uglify: config.env == 'production'

# prepare styles
styles = prepareStyles opts.styles

# merge and fingerprint assets
assets = packageAssets html, scripts, styles

# the tree is complete!
module.exports = assets
