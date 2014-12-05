/**
 * Make part of the header of the site fix itself to the top as you scroll
 * @param  {jQuery} $                  [description]
 * @return {object}                    [description]
 */
define(['jquery'], function($) {
  'use strict';

  var defaultConfig = {
    'headerId' : 'header',
    'filterClass' : 'l-filter',
    'filterButtonClass': 'l-header-filter-button',
    'filterActiveClass' : 'filter-active',
    'headerTopId' : 'header-top',
    'shallowHeaderMinWidth': 720
  },

  /**
   * @constructor
   */
  Header = function($el, config) {

  };

  /**
   * Init
   * @param {boolean} initialised
   */
  Header.prototype.init = function() {
    this.bindEvents();
    this.setupVars();
    this.positionFilterOffScreen();
    this.addPositionedClass();
    this.startDelayedHeaderMove();
    this.checkResize();
  };

  Header.prototype.checkResize = function() {
    $(window).resize($.proxy(this.positionFilterOffScreen, this));
  };

  Header.prototype.startDelayedHeaderMove = function() {
    setTimeout($.proxy(this.moveHeader, this), 2000);
  };

  Header.prototype.shouldMoveHeader = function() {
    return (
      $('body').scrollTop() == 0 &&
      !this.isFilterActive() &&
      $(window).width() < defaultConfig.shallowHeaderMinWidth
    );
  };

  Header.prototype.moveHeader = function() {
    if (this.shouldMoveHeader()) {
      $('body').animate({
        scrollTop: $('#' + defaultConfig.headerTopId).height()
      });
    }
  };

  Header.prototype.bindEvents = function() {
    $('.' + defaultConfig.filterButtonClass).on(
      'click',
      $.proxy(this.filterButtonFired, this)
    );
  };

  Header.prototype.isFilterActive = function() {
    return $('body').hasClass(defaultConfig.filterActiveClass);
  };

  Header.prototype.filterButtonFired = function() {
    $('body').toggleClass(defaultConfig.filterActiveClass);

    if (!this.isFilterActive()) {
      this.moveHeader();
    }
  };

  Header.prototype.setupVars = function() {
    this.$header = $('#' + defaultConfig.headerId);
  };

  Header.prototype.positionFilterOffScreen = function() {
    $('.' + defaultConfig.filterClass).css('display', 'block');
    this.removePositionedClass();
    this.$header.css('margin-top', -this.getFilterHeight());
    this.addPositionedClass();
  };

  Header.prototype.getFilterHeight = function() {
    return $('.' + defaultConfig.filterClass).height();
  };

  Header.prototype.addPositionedClass = function() {
    setTimeout($.proxy(function() {
      this.$header.addClass('positioned');
    }, this), 0);
  };

  Header.prototype.removePositionedClass = function() {
    this.$header.removeClass('positioned');
  };

  return Header;
});
