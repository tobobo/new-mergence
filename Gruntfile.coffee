module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.initConfig
    watch:
      server:
        files: ['client/**/*', 'server/**/*', 'server.coffee']
        tasks: 'server'
        options:
          spawn: false
          livereload: true

    express:
      server:
        options:
          port: process.env.PORT or 8000
          opts: ['node_modules/coffee-script/bin/coffee']
          script: 'server.coffee'

  grunt.registerTask 'server', 'express:server'
  grunt.registerTask 'server:watch', ['server', 'watch:server']
