/**
 * Make part of the header of the site fix itself to the top as you scroll
 * @param  {jQuery} $                  [description]
 * @return {object}                    [description]
 */
define(['jquery'], function($) {
  'use strict';

  var defaultConfig = {
        'bottomHeaderId' : 'header-bottom',
        'headerId' : 'header'
      },

      /**
       * @constructor
       */
      StickyHeader = function($el, config) {

      };

  /**
   * Init - detect range type support and clone input / label
   * @param {boolean} initialised
   */
  StickyHeader.prototype.init = function() {

    $('.l-header__filter-button').on('click', function () {
      $('body').toggleClass('filter-active');
    });

    this.headerHeight = $('#' + defaultConfig.headerId).height();

    this.$bottomOfHeader = $('#' + defaultConfig.bottomHeaderId);
    this.$header = $('#' + defaultConfig.headerId);

    this.initialHeaderOffsetTop = this.$bottomOfHeader.offset().top;

    setInterval($.proxy(this.stickIt, this), 10);
  };

  StickyHeader.prototype.stickIt = function() {
    if ($(window).scrollTop() > this.initialHeaderOffsetTop) {
      this.$bottomOfHeader.addClass('sticky');
      this.$header.css('height', this.headerHeight);
    } else {
      this.$bottomOfHeader.removeClass('sticky');
      this.$header.css('height', 'auto');
    }
  };

  return StickyHeader;
});
