module.exports = (grunt) ->
  config = require('./config') process.env.NODE_ENV or 'development'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.initConfig
    watch:
      server:
        files: ['client/**/*', 'server/**/*', 'shared/**/*', 'server.coffee', 'config.coffee']
        tasks: 'express:development'
        options:
          spawn: false
          livereload: true

    express:
      development:
        options:
          node_env: 'development'
          port: config.port
          opts: ['node_modules/coffee-script/bin/coffee']
          output: config.serverListenMessage
          script: 'server.coffee'

      production:
        options:
          node_env: 'production'
          port: config.port
          opts: ['node_modules/coffee-script/bin/coffee']
          output: config.serverListenMessage
          script: 'server.coffee'
          background: false

  grunt.registerTask 'server:development', ['express:development', 'watch:server']
  grunt.registerTask 'server', 'server:development'

  grunt.registerTask 'server:production', 'express:production'
