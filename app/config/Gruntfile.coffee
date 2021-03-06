module.exports = (grunt) ->
  config = require('../../config')()

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  coffeePath = 'node_modules/.bin/coffee'

  grunt.initConfig
    watch:
      server:
        files: [
          'app/**/*',
          'config.coffee',
          'index.coffee',
          'Brocfile.coffee',
          'Gruntfile.coffee'
        ]
        tasks: 'express:development'
        options:
          spawn: false
          livereload: true

    express:
      development:
        options:
          node_env: 'development'
          port: config.port
          opts: [coffeePath]
          output: config.serverListenMessage or 'listening'
          script: config.server

      production:
        options:
          node_env: 'production'
          port: config.port
          opts: [coffeePath]
          output: config.serverListenMessage or 'listening'
          script: config.server
          background: false

  grunt.registerTask 'server:development', ['express:development', 'watch:server']
  grunt.registerTask 'server:debug', ['express:debug']
  grunt.registerTask 'server:production', 'express:production'
  grunt.registerTask 'server', 'server:development'
