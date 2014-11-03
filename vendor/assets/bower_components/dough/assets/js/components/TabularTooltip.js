/**
 * Replaces browser default tooltips for elements, with
 * CSS-powered tooltips that work on touchscreen devices too.
 *
 * @param  {Object}   $         (jQuery)
 * @param  {Function} DoughBaseComponent
 */
define(['jquery', 'DoughBaseComponent'], function($, DoughBaseComponent) {
  'use strict';

  /**
   * Call base constructor
   * @constructor
   */
  var TabularTooltip = function() {
    TabularTooltip.baseConstructor.apply(this, arguments);
  };

  DoughBaseComponent.extend(TabularTooltip);

  /**
   * Init
   * @param {Promise} initialised
   */
  TabularTooltip.prototype.init = function(initialised) {
    var title = this.$el.attr('title');
    this.$el.attr('data-tooltip', title)  // store title in new data-attribute
        .removeAttr('title');          // remove old title, to avoid double tooltip (see comment in css)

    this._initialisedSuccess(initialised);
  };

  return TabularTooltip;

});
