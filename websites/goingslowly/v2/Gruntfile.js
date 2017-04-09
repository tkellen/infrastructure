module.exports = function(grunt) {

  require('matchdep').filterDev('grunt-contrib*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({

    meta: {
      assets: {
        src: 'lib/goingslowly/assets',
        dest: 'public/assets',
        cdn: 'http://cdn.goingslowly.com'
      }
    },

    coffee: {
      gs: {
        src: ['<%= meta.assets.src %>/js/gs/*.coffee'],
        dest: 'tmp/gs.js',
        options: {
          bare: true
        }
      },
      page: {
        expand: true,
        cwd: '<%= meta.assets.src %>/js',
        src: 'page/*.coffee',
        dest: '<%= meta.assets.dest %>',
        ext: '.js'
      }
    },

    concat: {
      js: {
        src: ['<%= meta.assets.src %>/js/lib/jquery.js',
              '<%= meta.assets.src %>/js/lib/*.js',
              'tmp/gs.js'],
        dest: '<%= meta.assets.dest %>/site.js'
      }
    },

    compass: {
      compile: {
        options: {
          raw: ['images_dir = "img/"',
                'css_dir = "public/assets"',
                'sass_dir = "<%= meta.assets.src %>/css"',
                'asset_host { |asset| "<%= meta.assets.cdn %>" }'].join('\n')
        }
      }
    },

    uglify: {
      options: {
        report: false
      },
      js: {
        files: {
          '<%= meta.assets.dest %>/site.js': '<%= meta.assets.dest %>/site.js',
          '<%= meta.assets.dest %>/ie.js': '<%= meta.assets.src %>/js/ie.js'
        }
      }
    },

    cssmin: {
      options: {
        report: false
      },
      css: {
        expand: true,
        cwd: '<%= meta.assets.dest %>',
        src: '*.css',
        dest: '<%= meta.assets.dest %>'
      }
    },

    watch: {
      css: {
        files: ['<%= meta.assets.src %>/css/**/*'],
        tasks: ['compass']
      },
      js: {
        files: ['<%= meta.assets.src %>/js/**/*'],
        tasks: ['js']
      }
    },

    compress: {
      options: {
        mode: 'gzip',
        level: 9
      },
      js: {
        expand: true,
        cwd: '<%= meta.assets.dest %>',
        src: '*.js',
        dest: '<%= meta.assets.dest %>',
        ext: '.js.gz'
      },
      css: {
        expand: true,
        cwd: '<%= meta.assets.dest %>',
        src: '*.css',
        dest: '<%= meta.assets.dest %>',
        ext: '.css.gz'
      }
    },

    clean: {
      tmp: ['tmp'],
      assets: ['<%= meta.assets.dest %>']
    }
  });

  grunt.registerTask('rackup', function () {
    grunt.util.spawn({cmd: 'killall', args: ['rackup']}, function(){
      grunt.util.spawn({cmd: 'rackup'}, function(){});
    });
  });

  // concat site libs and coffeescript
  grunt.registerTask('js', ['coffee', 'concat', 'clean:tmp']);

  // prep site for development
  grunt.registerTask('develop', ['clean:assets', 'js', 'compass']);

  // start working environment
  grunt.registerTask('work', ['develop', 'rackup', 'watch']);

  // prep site for production (minify js/css)
  grunt.registerTask('production', ['develop', 'uglify', 'cssmin', 'compress']);

  // start working
  grunt.registerTask('default', ['work']);
};
