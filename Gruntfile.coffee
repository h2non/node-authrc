'use strict'

module.exports = (grunt) ->

  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean: ['lib', 'test/*.js', 'test/tmp/**/*']

    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      lib:
        src: '<%= watch.lib.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        camel_case_classes: true
        no_trailing_semicolons: 
          level: 'warn'
        no_trailing_whitespace: 
          level: 'warn'
        max_line_length:
          level: 'warn'
        indentation:
          level: 'warn'
        no_backticks:
          level: 'warn'

    coffee:
      lib:
        options:
          bare: true
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'lib/'
        ext: '.js'
        
    mochacli:
      options:
        compilers: ['coffee:coffee-script']
        timeout: 5000
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      all: 
        src: [
          'test/**/*.coffee' 
        ]

    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      lib:
        files: ['src/**/*.coffee']
        tasks: ['coffeelint:lib', 'coffee:lib', 'simplemocha']
      test:
        files: ['src/test/**/*.coffee']
        tasks: ['coffeelint:test', 'coffee:test', 'simplemocha']

  grunt.event.on 'watch', (action, files, target)->
    grunt.log.writeln "#{target}: #{files} has #{action}"

    # coffeelint
    grunt.config ['coffeelint', target], src: files

    # coffee
    coffeeData = grunt.config ['coffee', target]
    files = [files] if _.isString files
    files = files.map (file)-> path.relative coffeeData.cwd, file
    coffeeData.src = files

    grunt.config ['coffee', target], coffeeData


  grunt.registerTask 'compile', [
    'clean'
    'coffeelint'
    'coffee'
  ]

  grunt.registerTask 'test', [
    'compile',
    'mochacli'
  ]

  grunt.registerTask 'publish', [
    'test'
    'release'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]

