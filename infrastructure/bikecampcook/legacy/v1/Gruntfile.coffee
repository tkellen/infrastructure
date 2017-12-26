module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig

    stylus:
      options:
        'include css': true
      css:
        src: 'styles/style.styl'
        dest: 'public/style.css'
      ie:
        src: 'styles/ie.styl'
        dest: 'public/ie.css'

    watch:
      options:
        livereload: true
      views:
        files: ['lib/**/*']
        tasks: ['express:development']
      css:
        files: ['styles/*']
        tasks: ['stylus']

    clean:
      generated: ['public/site.js','public/style.css','public/ie.css']

    express:
      options:
        script: 'app.js'
      production:
        options:
          node_env: 'production'
      development:
        options:
          node_env: 'development'

    requirejs:
      options:
        baseUrl: '',
        mainConfigFile: 'config/requirejs.js',
        name: 'bower_components/almond/almond',
        out: 'public/site.js'

      development:
        options:
          optimize: 'none'
      production:
        options:
          optimize: 'uglify2'

  grunt.registerTask('work', ['stylus', 'express:development', 'watch'])
  grunt.registerTask('production', ['clean', 'requirejs:production', 'stylus'])
  grunt.registerTask('default', ['work'])
