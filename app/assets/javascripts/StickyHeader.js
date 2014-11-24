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
        'filterClass' : 'l-filter'
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
    $('.l-header__filter-button').on('click', $.proxy(function () {
      $('body').toggleClass('filter-active');
      this.stickIt();
    }, this));

    this.$topOfHeaderHeight = $('#' + defaultConfig.topHeaderId).height() + 1;
    this.$header = $('#' + defaultConfig.headerId);

    this.filterHeight = $('.' + defaultConfig.filterClass).height();

    this.$header.css('margin-top', -this.filterHeight);
    setTimeout($.proxy(function() {
      this.$header.addClass('positioned');
    }, this), 0);

    setInterval($.proxy(this.stickIt, this), 10);
    this.stickIt();
  };

  StickyHeader.prototype.stickIt = function() {
    var scrollTop = $(window).scrollTop(),
        $body = $('body')

    if (scrollTop <= 0) {
      $body.removeClass('scrolling');
    } else {
      $body.addClass('scrolling');
    }

    if ($('body').hasClass('filter-active')) {
      this.$header.css('margin-top', 0);
    } else {
      this.$header.css('margin-top', -this.filterHeight);
    }

    if ($('body').hasClass('filter-active') || scrollTop <= 0) {
      this.$header.css('top', 0);
      return;
    }

    if (scrollTop < this.$topOfHeaderHeight) {
      this.$header.css('top', -scrollTop);
    } else {
      this.$header.css('top', -(this.$topOfHeaderHeight));
    }
  };

  return StickyHeader;
});
