
path = require("path")
module.paths.unshift path.join __dirname, 'lib'

_ = require 'lodash'
karma = require('karma').server
gulp = require 'gulp'
util = require 'gulp-util'
$ = require('gulp-load-plugins')()
del = require 'del'
pkg = require './package.json'
CliTable = require 'cli-table'

# coffeelint all coffee scripts
gulp.task 'lint', ->
  gulp.src(['src/**/*.coffee', 'gulpfile.coffee'])
    .pipe($.coffeelint('./coffeelint.json'))

# cleans test and lib
gulp.task 'clean', (done) ->
  del ['test/**/*', 'test/', 'lib/**/*', 'lib/'], done

gulp.task 'distclean', ['clean'], (done) ->
  del ['coverage.html', 'debug/*', 'debug'], done

# Add header to each test file so it's easier
# to require modules for testing
gulp.task 'build-test', ['clean'], ->
  testHeader = """
# no module.path under karma webpack tests
# but we handle the paths in the webpack conf
if module.paths
  module.paths.unshift process.cwd() + "/lib"

"""
  gulp.src('src/test/**/*.coffee', base: 'src/test')
    .pipe($.header '<%= header %>', header: testHeader)
    .pipe($.sourcemaps.init())
    .pipe($.coffee().on 'error', util.log)
    .pipe($.sourcemaps.write())
    .pipe gulp.dest 'test'

# Build coffee files in src/lib/ to js files in lib/
gulp.task 'build-lib', ['clean'], ->
  gulp.src('src/lib/**/*.coffee')
    .pipe($.sourcemaps.init())
    .pipe($.coffee().on 'error', util.log)
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest 'lib')

# lint clean and build everything
gulp.task 'build', ['lint', 'clean', 'build-lib', 'build-test']

testFiles = ['test/helpers/**/*.js', 'test/spec/**/*.js']
# helper to run coverage generation with given options
runCoverage = (opts) ->
  gulp.src(testFiles, read: false)
    .pipe($.coverage.instrument
      pattern: ['lib/**/*.js', '!node_modules']
      debugDirectory: 'debug')
    .pipe($.plumber())
    .pipe($.mocha reporter: 'dot').on('error', (e) -> @emit 'end') # test errors dropped
    .pipe($.plumber.stop())
    .pipe($.coverage.gather())
    .pipe($.coverage.format opts)

runTest = (stream, opts) ->
  stream
    .pipe($.plumber())
    .pipe($.mocha opts)
    .pipe($.plumber.stop())

# test and create coverage
gulp.task 'coverage', ['build'], ->
  runCoverage(outFile: './coverage.html')
    .pipe(gulp.dest './')
    .on 'end', ->
      require('opn') './coverage.html', null, util.log

# send coverage to travis
gulp.task 'coveralls', ['build'], ->
  runCoverage(reporter: 'lcov')
    .pipe($.coveralls())

# run tests but only show progress
gulp.task 'test-quiet', ['build'], ->
  runTest gulp.src(testFiles), reporter: 'dot'

# run and display all tests
gulp.task 'test', ['build'], ->
  runTest gulp.src(testFiles), reporter: 'spec'

# run tests from phantomjs with karma
gulp.task 'karma', ['test-quiet'], (done) ->
  karma.start
    configFile: require('path').join __dirname, './karma.conf.js'
    singleRun: true
  , done

# uses chrome and firefox
gulp.task 'karma-gui', ['test-quiet'], (done) ->
  karma.start
    configFile: require('path').join __dirname, './karma.conf.js'
    browsers: ['Chrome', 'Firefox']
    singleRun: true
  , done

# doesn't work... yet
gulp.task 'watch-coverage', ['coverage'], (done) ->
  $.livereload.listen port: 35729
  require('opn') './coverage.html', null, util.log
  gulp.watch('src/**/*.coffee', ['coverage'])
  gulp.watch('./coverage.html').on 'change', $.livereload
  return

# watch all coffee files and run tests for changes
gulp.task 'watch', (done) ->
  gulp.watch 'src/**/*.coffee', ['test']
  return

# default, test
gulp.task 'default', ['test']


