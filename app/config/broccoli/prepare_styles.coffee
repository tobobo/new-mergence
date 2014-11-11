concat = require 'broccoli-concat'

module.exports = (styles) ->

  concat styles,
    inputFiles: ['**/*.css']
    outputFile: '/app.css'
