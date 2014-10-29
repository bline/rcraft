'use strict';

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['mocha'],
    files: [
      'src/test/helpers/**/*.coffee',
      'src/test/spec/**/*.coffee'
    ],
    preprocessors: {
      '**/*.coffee': ['webpack']
    },
    webpack: {
      cache: true,
      resolve: {
        root: __dirname + '/lib',
        extensions: ['', '.js', '.coffee']
      },
      module: {
        loaders: [{
          test: /\.css$/,
          loader: 'style!css'
        }, {
          test: /\.gif/,
          loader: 'url-loader?limit=10000&mimetype=image/gif'
        }, {
          test: /\.jpg/,
          loader: 'url-loader?limit=10000&mimetype=image/jpg'
        }, {
          test: /\.png/,
          loader: 'url-loader?limit=10000&mimetype=image/png'
        }, {
          test: /\.coffee$/,
          loader: 'coffee-loader'
        }]
      }
    },
    webpackServer: {
      quiet: true,
      stats: true
    },
    exclude: [],
    port: 8080,
    logLevel: config.LOG_WARN,
    colors: true,
    autoWatch: false,
    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],
    reporters: ['progress'], // ['mocha'],
    captureTimeout: 60000,
    singleRun: true
  });
};

