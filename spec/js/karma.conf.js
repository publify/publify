// Karma configuration
// Generated on Mon Dec 08 2014 15:10:55 GMT+0000 (GMT)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../../',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['requirejs', 'mocha', 'chai-jquery', 'chai', 'sinon', 'jquery-1.11.0'],


    // list of files / patterns to load in the browser
    files: [
      'spec/js/test-main.js',
      'spec/js/fixtures/*.html',
      'vendor/assets/bower_components/dough/vendor/assets/non_bower_components/modernizr/modernizr.js',
      {pattern: 'app/assets/javascripts/components/*.js', included: false},
      {pattern: 'vendor/assets/bower_components/**/*.js', included: false},
      {pattern: 'spec/js/tests/*_spec.js', included: false}
    ],


    // list of files to exclude
    exclude: [
      'vendor/assets/bower_components/**/test/**/*.js',
      'vendor/assets/bower_components/dough/node_modules/**/*.js',
      'vendor/assets/bower_components/**/spec/**/*.js'
    ],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      '**/*.html': ['html2js'],
      'assets/js/**/*.js': ['coverage']
    },

    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress', 'coverage', 'osx'],


    // configure the reporter
    coverageReporter: {
      type : 'html',
      dir : 'coverage/'
    },

    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_ERROR,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  });
};
