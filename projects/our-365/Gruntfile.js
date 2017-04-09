module.exports = function(grunt) {

  require('matchdep').filterDev('grunt-contrib*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({

    meta: grunt.file.readYAML('config/our365.yml'),
    assets: {
      src: 'lib/our365/assets',
      dest: 'public/assets',
      sitejs: 'public/assets/site.js'
    },

    coffee: {
      gs: {
        src: ['<%= assets.src %>/js/site.coffee'],
        dest: '<%= assets.sitejs %>',
        options: {
          bare: true
        }
      }
    },

    concat: {
      site: {
        src: ['<%= assets.src %>/js/lib/*.js', '<%= assets.sitejs %>'],
        dest: '<%= assets.sitejs %>'
      }
    },

    uglify: {
      site: {
        src: ['<%= assets.sitejs %>'],
        dest: '<%= assets.sitejs %>'
      }
    },

    compass: {
      compile: {
        options: {
          raw: ['images_dir = "img/"',
                'css_dir = "<%= assets.dest %>"',
                'sass_dir = "<%= assets.src %>/css"',
                'asset_host { |asset| "<%= meta.url.cdn %>" }'].join('\n')
        }
      }
    },

    mincss: {
      site: {
        src: ['<%= assets.dest %>/site.css'],
        dest: '<%= assets.dest %>/site.css'
      }
    }
  });

  grunt.registerTask('develop', ['coffee', 'concat', 'compass']);
  grunt.registerTask('production', ['default', 'uglify', 'mincss']);
  grunt.registerTask('default', 'develop');

};
