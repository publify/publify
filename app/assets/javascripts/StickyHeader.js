/**
 * Make part of the header of the site fix itself to the top as you scroll
 * @param  {jQuery} $                  [description]
 * @return {object}                    [description]
 */
define(['jquery'], function($) {
  'use strict';

  var defaultConfig = {
        'topHeaderId' : 'header-top',
        'headerId' : 'header',
        'filterClass' : 'l-filter',
        'filterButtonClass': 'l-header__filter-button',
        'filterActiveClass' : 'filter-active',
        'scrollingClass': 'scrolling',
        'shallowHeaderMinWidth': 720
      },

      /**
       * @constructor
       */
      StickyHeader = function($el, config) {

      };

  /**
   * Init
   * @param {boolean} initialised
   */
  StickyHeader.prototype.init = function() {
    this.bindEvents();
    this.setupVars();
    this.addPositionedClass();
    this.monitorStickyness();
    this.positionFilterOffScreen();
  };

  StickyHeader.prototype.setupVars = function() {
    this.$header = $('#' + defaultConfig.headerId);
    this.$header.css('margin-top', -this.filterHeight);
    this.filterHeight = this.getFilterHeight();
  };

  StickyHeader.prototype.getFilterHeight = function() {
    return $('.' + defaultConfig.filterClass).height();
  }

  StickyHeader.prototype.addPositionedClass = function() {
    setTimeout($.proxy(function() {
      this.$header.addClass('positioned');
    }, this), 0);
  };

  StickyHeader.prototype.monitorStickyness = function() {
    $(window).scroll($.proxy(this.stickIt, this));
    $(window).resize($.proxy(function() {
      this.filterHeight = this.getFilterHeight();
      this.positionFilterOffScreen();
      this.stickIt();
    }, this));
    this.stickIt();
  };

  StickyHeader.prototype.bindEvents = function() {
    $('.' + defaultConfig.filterButtonClass).on(
      'click',
      $.proxy(this.filterButtonFired, this)
    );
  };

  StickyHeader.prototype.isFilterActive = function() {
    return $('body').hasClass(defaultConfig.filterActiveClass);
  };

  StickyHeader.prototype.filterButtonFired = function() {
    $('body').toggleClass(defaultConfig.filterActiveClass);
    this.stickIt();
  };

  StickyHeader.prototype.isShallowHeader = function() {
    return $(window).width() >= defaultConfig.shallowHeaderMinWidth;
  };

  StickyHeader.prototype.heightToFix = function() {
    return this.isFilterActive() || this.isShallowHeader() ? 1 : $('#' + defaultConfig.topHeaderId).height();
  };

  StickyHeader.prototype.heightOfFixedHeader = function() {
    return this.isFilterActive() ? this.$header.height() : (this.$header.height() - this.filterHeight);
  }

  StickyHeader.prototype.positionFilterOffScreen = function() {
    this.$header.css('margin-top', -this.filterHeight);
  };

  StickyHeader.prototype.stickIt = function() {
    var scrollTop = $(window).scrollTop(),
        $body = $('body'),
        topOfHeaderHeight = this.heightToFix();

    if (scrollTop < topOfHeaderHeight) {
      $body.removeClass(defaultConfig.scrollingClass);
      $body.css('margin-top', 0);
    } else {
      $body.addClass(defaultConfig.scrollingClass);
      $body.css('margin-top', this.heightOfFixedHeader());
      this.$header.css('top', -topOfHeaderHeight);
    }
  };

  return StickyHeader;
});
