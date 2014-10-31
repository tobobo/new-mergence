module.exports = (grunt) ->
  config = require('./config') process.env.NODE_ENV or 'development'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.initConfig
    watch:
      server:
        files: ['client/**/*', 'server/**/*', 'server.coffee']
        tasks: 'express:development'
        options:
          spawn: false
          livereload: true

    express:
      development:
        options:
          port: config.port
          opts: ['node_modules/coffee-script/bin/coffee']
          script: 'server.coffee'

      production:
        options:
          port: config.port
          opts: ['node_modules/coffee-script/bin/coffee']
          script: 'server.coffee'
          background: false

  grunt.registerTask 'server:development', ['express:development', 'watch:server']
  grunt.registerTask 'server', 'server:development'

  grunt.registerTask 'server:production', 'express:production'
