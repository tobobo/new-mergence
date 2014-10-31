var concat = require('broccoli-concat');
var mergeTrees = require('broccoli-merge-trees');
var pickFiles = require('broccoli-static-compiler');

var vendorScriptFiles = [
  'bower_components/socket.io-client/socket.io.js'
]

var scripts = 'client/scripts';
var styles = 'client/styles';

var html = pickFiles('client', {
  srcDir: '/',
  files: ['**/*.html'],
  destDir: '/'
})

scripts = concat(scripts, {
  inputFiles: [
    '**/*.js'
  ],
  outputFile: '/app.js'
});

vendorScripts = concat('.', {
  inputFiles: vendorScriptFiles,
  outputFile: '/vendor.js'
})

styles = concat(styles, {
  inputFiles: [
    '**/*.css'
  ],
  outputFile: '/app.css'
});

module.exports = mergeTrees([html, scripts, vendorScripts, styles]);
