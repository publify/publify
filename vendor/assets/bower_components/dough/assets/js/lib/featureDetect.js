define([], function() {
  'use strict';

  var support = {};

  function supportTest(prop, context) {
    try {
      return prop in context && context[prop] !== null;
    } catch (e) {
      return false;
    }
  }

  support.js = ( supportTest('querySelector', document) &&
      supportTest('localStorage', window) &&
      supportTest('addEventListener', window) ) ? 'advanced' : 'basic';
  support.touch = ( supportTest('ontouchstart', window) || supportTest('onmsgesturechange', window) );
  support.localstorage = supportTest('localStorage', window);
  support.svg = (function() {
    return !!document.createElementNS && !!document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGRect;
  })();

  support.inputtypes = Modernizr.inputtypes;

  support.mediaQueries =
      (typeof window.matchMedia !== 'undefined') ||
      (typeof window.msMatchMedia !== 'undefined');

  support.test = supportTest;

  return support;

});
