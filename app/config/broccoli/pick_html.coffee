pickFiles = require 'broccoli-static-compiler'

module.exports = (client) ->
  pickFiles client,
    srcDir: '/'
    files: ['**/*.html']
    destDir: '/'
