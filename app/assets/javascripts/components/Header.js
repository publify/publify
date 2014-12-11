/**
 * Scrolling the header past the MAS logo, and dealing with
 * the clicking of the filter button
 * @param  {jQuery} $                  [description]
 * @param  {[type]} DoughBaseComponent [description]
 * @return {object}                    [description]
 */
define(['jquery', 'DoughBaseComponent'], function($, DoughBaseComponent) {
  'use strict';

  var HeaderProto,
  defaultConfig = {
    'headerMoveTimeout': 2000,
    uiEvents: {
      'click [data-dough-collapsable-trigger]': '_filterButtonFired'
    }
  },

  /**
   *
   * @param {jQuery} $el - mandatory - the header
   * @param {object} config
   * @returns {Header}
   * @constructor
   */
  Header = function($el, config) {
    Header.baseConstructor.call(this, $el, config, defaultConfig);

    this.$htmlAndBody = $('html,body');
    this.$filter = this.$el.find('[data-dough-header-filter]');
    this.$headerTop = this.$el.find('[data-dough-header-header-top]');
    this.filterActiveClass = this.$el.data('dough-header-filter-active-class');
    this.animateClass = this.$el.data('dough-header-animate-class');

    return this;
  };

  /**
   * Inherit from base module, for shared methods and interface
   * @type {[type]}
   * @private
   */
  DoughBaseComponent.extend(Header);
  HeaderProto = Header.prototype;

  /**
   * Init function
   * @return {Header}
   */
  HeaderProto.init = function(initialised) {
    this._bindEvents();
    this._positionFilterOffScreen();
    this._addAnimateClass();
    this._startDelayedHeaderMove();
    this._initialisedSuccess(initialised);

    return this;
  };

  /**
   * Binds UI Events for clicking the filter button or resizing window
   */
  HeaderProto._bindEvents = function() {
    $(window).resize($.proxy(this._positionFilterOffScreen, this));
  };

  /**
   * Positions the filter div off screen and ensures that
   * no animations happening whilst positioning it
   */
  HeaderProto._positionFilterOffScreen = function() {
    this.$filter.css('display', 'block');
    this._removeAnimateClass();
    this.$el.css('margin-top', -this._getFilterHeight());
    this._addAnimateClass();
  };

  /**
   * Adds the animate class after browser has finished rendering
   */
  HeaderProto._addAnimateClass = function() {
    setTimeout($.proxy(function() {
      this.$el.addClass(this.animateClass);
    }, this), 0);
  };

  /**
   * Moves the header after a certain amount of time
   */
  HeaderProto._startDelayedHeaderMove = function() {
    setTimeout($.proxy(this._moveHeader, this), this.config.headerMoveTimeout);
  };

  /**
   * Works out whether the header should be allowed to move
   * @return {boolean}
   */
  HeaderProto._shouldMoveHeader = function() {
    var scrollTop = Math.max.apply(
      Math,
      this.$htmlAndBody.map(function(idx, el) {
        return $(el).scrollTop();
      })
    );

    return (
      scrollTop === 0 &&
      !this._isFilterActive() &&
      !this._isShallowHeader()
    );
  };

  /**
   * Works out from the CSS whether we are displaying the shallow header
   * @return {boolean}
   */
  HeaderProto._isShallowHeader = function() {
    return window.getComputedStyle(
      this.$el[0],
      ':after'
    ).getPropertyValue('content') === 'shallow';
  };

  /**
   * Moves the page down beyond the header top
   */
  HeaderProto._moveHeader = function() {
    if (!this._shouldMoveHeader()) {
      return;
    }

    this.$htmlAndBody.animate({
      scrollTop: this.$headerTop.height() + 1
    });
  };

  /**
   * Works out whether the filter is currently displayed
   * @return {boolean}
   */
  HeaderProto._isFilterActive = function() {
    return this.$el.hasClass(this.filterActiveClass);
  };

  /**
   * Deals with when the filter button is clicked
   * @return {boolean}
   */
  HeaderProto._filterButtonFired = function() {
    this.$el.toggleClass(this.filterActiveClass);

    if (!this._isFilterActive()) {
      this._moveHeader();
    }
  };

  /**
   * Gets the height of the filter div
   * @return {int}
   */
  HeaderProto._getFilterHeight = function() {
    return this.$filter.height();
  };

  /**
   * Remove the animate class
   */
  HeaderProto._removeAnimateClass = function() {
    this.$el.removeClass(this.animateClass);
  };

  return Header;
});
