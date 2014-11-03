/**
 * # Tab selector
 *
 * Requires an element to have a data-dough-component="TabSelector" attribute.
 */

/**
 * Require from Config
 * @param  {object} $         [description]
 * @param  {object} DoughBaseComponent [description]
 * @return {object}
 * @private
 */
define(['jquery', 'DoughBaseComponent', 'eventsWithPromises', 'mediaQueries'],
    function($, DoughBaseComponent, eventsWithPromises, mediaQueries) {
      'use strict';

      var TabSelector,
          defaultConfig = {
            collapseInSmallViewport: false,
            uiEvents: {
              'click [data-dough-tab-selector-trigger]': '_handleClickEvent'
            }
          },
          selectors = {
            triggersOuter: '[data-dough-tab-selector-triggers-outer]',
            triggersInner: '[data-dough-tab-selector-triggers-inner]',
            triggerContainer: 'data-dough-tab-selector-trigger-container',
            trigger: 'data-dough-tab-selector-trigger',
            target: 'data-dough-tab-selector-target',
            activeClass: 'is-active',
            inactiveClass: 'is-inactive',
            collapsedClass: 'is-collapsed'
          },
          i18nStrings = {
            selected: 'selected',
            show: 'click to show'
          };

      /**
       * Call DoughBaseComponent constructor. Find options list.
       * @constructor
       */
      TabSelector = function($el, config) {
        var triggerId;

        TabSelector.baseConstructor.call(this, $el, config, defaultConfig);
        this.i18nStrings = (config && config.i18nStrings) ? config.i18nStrings : i18nStrings;
        this.selectors = $.extend(this.selectors || {}, selectors);

        this._checkComponentMarkup();

        this._setupAccessibility();

        if (this.$firstTrigger.length) {
          triggerId = this.$firstTrigger.attr(selectors.trigger);
          this._updateTriggers(triggerId);
        }

        if (this.config.collapseInSmallViewport === true) {
          this._updateCollapsedState();
        }

        this._subscribeHubEvents();
      };

      /**
       * Inherit from base module, for shared methods and interface
       */
      DoughBaseComponent.extend(TabSelector);

      /**
       * Init function
       * @returns {TabSelector}
       */
      TabSelector.prototype.init = function(initialised) {
        if (this.isComponentMarkupValid === true) {
          this._initialisedSuccess(initialised);
        } else {
          this._initialisedFailure(initialised);
        }
        return this;
      };

      /**
       * Set up references to the various required parts of the component. If they are all
       * present, set the property isComponentMarkupValid to true
       * @private
       */
      TabSelector.prototype._checkComponentMarkup = function() {
        this.$triggersWrapperOuter = this.$el.find(selectors.triggersOuter);
        this.$triggersWrapperInner = this.$el.find(selectors.triggersInner).addClass(this.selectors.inactiveClass);
        this.$triggerContainers = this.$el.find('[' + selectors.triggerContainer + ']');
        this.$firstTrigger = this.$triggersWrapperInner.find('[' + selectors.trigger + ']').first();

        this.isComponentMarkupValid = !!(this.$triggersWrapperOuter.length &&
            this.$triggersWrapperInner.length &&
            this.$firstTrigger.length);
      };

      /**
       * Any one-off actions to make the component more accessible
       * @private
       */
      TabSelector.prototype._setupAccessibility = function() {
        this.$el.find('[' + selectors.target + ']').attr({
          'aria-hidden': 'true',
          'tabindex': '-1'
        });
        this._convertLinksToButtons();
      };

      /**
       * Set the height of the triggers outer wrapper so that it will hold vertical space open
       * when the inner wrapper is positioned
       * @private
       */
      TabSelector.prototype._setTriggerWrapperHeight = function() {
        this.$triggersWrapperOuter.height(this.$triggersWrapperInner.outerHeight());
      };

      /**
       * Subscribe to hub event - if the viewport is resized to small, set the triggers wrapper to
       * inactive so the 'dropdown' menu isn't open
       * @private
       */
      TabSelector.prototype._subscribeHubEvents = function() {
        if (this.config.collapseInSmallViewport === true) {
          eventsWithPromises.subscribe('mediaquery:resize', $.proxy(this._updateCollapsedState, this));
        }
      };

      /**
       * Check if the tabs should be collapsed or not
       * (based on whether they're currently wrapped) and update them accordingly
       * @private
       */
      TabSelector.prototype._updateCollapsedState = function() {
        this.$el.removeClass(this.selectors.collapsedClass);
        if (this._haveTriggersWrapped()) {
          this.$triggersWrapperInner
              .removeClass(this.selectors.activeClass)
              .addClass(this.selectors.inactiveClass);
          this.$el.addClass(this.selectors.collapsedClass);
          // set height after triggers updated, so active trigger is visible on small viewport
          this._setTriggerWrapperHeight();
        }
      };

      /**
       * Have the triggers (eg tabs) wrapped onto a second line?
       * @returns {boolean}
       * @private
       */
      TabSelector.prototype._haveTriggersWrapped = function() {
        var result = false,
            top;

        this.$triggerContainers.each(function(idx) {
          if (idx === 0) {
            top = $(this).position().top;
          } else {
            if ($(this).position().top > (top + $(this).height())) {
              result = true;
            }
          }
        });
        return result;
      };

      /**
       * Change all links in tabs to button elements
       * @private
       */
      TabSelector.prototype._convertLinksToButtons = function() {
        var _this = this;
        this.$el.find('[' + this.selectors.trigger + ']').each(function() {
          var content = $(this).html(),
              triggerId = $(this).attr(selectors.trigger);
          $(this).replaceWith('<button class="tab-selector__trigger unstyled-button" type="button" ' +
              selectors.trigger + '="' + triggerId + '">' +
              content +
              ' <span class="visually-hidden" data-dough-tab-selector-show> ' +
              _this.i18nStrings.show + '</span>' +
              '<span class="tab-selector__icon icon"></span>' +
              '</button>');
        });
      };

      /**
       * Handle a click on a trigger
       * @returns {TabSelector}
       * @private
       */
      TabSelector.prototype._handleClickEvent = function(e) {
        var $trigger = $(e.currentTarget),
            targetAttr;

        this._deSelectItem(this.$triggerContainers.filter('.is-active'));
        targetAttr = $trigger.attr(selectors.trigger);
        this._updateTriggers(targetAttr);
        this._positionMenu($trigger);
        this._updateTargets(targetAttr);
        this._toggleMenu($trigger);
        e.preventDefault();
        return this;
      };

      /**
       * Deselect a trigger
       * @param {jQuery} $el
       * @private
       */
      TabSelector.prototype._deSelectItem = function($el) {
        $el.removeClass(this.selectors.activeClass).addClass(this.selectors.inactiveClass).attr('aria-selected', false);
        return this;
      };

      /**
       * Show / hide and position the menu so the selected item remains stationary
       * @returns {TabSelector}
       * @private
       */
      TabSelector.prototype._toggleMenu = function($trigger) {
        // if the clicked item is outside the menu, and the menu is closed, do nothing
        if (!$trigger.closest(this.$triggersWrapperInner).length &&
            !this.$triggersWrapperInner.hasClass(this.selectors.activeClass))
        {
          return;
        }
        this.$triggersWrapperInner.toggleClass(this.selectors.activeClass).toggleClass(this.selectors.inactiveClass);
        this._positionMenu($trigger);
        return this;
      };

      /**
       * Position the menu when it's open
       * @param {jQuery} $selected - selected trigger
       * @private
       */
      TabSelector.prototype._positionMenu = function($selected) {
        var pos;
        if ($selected) {
          pos = this.$triggersWrapperInner.hasClass(this.selectors.activeClass) ? -1 * $selected.position().top : 0;
          $selected.length && this.$triggersWrapperInner.css('top', pos);
        }

        return this;
      };

      /**
       * Activate / deactivate trigger
       * @param {string} targetAttr - the value of the clicked trigger
       * @returns {TabSelector}
       * @private
       */
      TabSelector.prototype._updateTriggers = function(targetAttr) {
        var $selectedTriggers = this.$el.find('[' + selectors.trigger + '="' + targetAttr + '"]'),
            $unselectedTriggers = this.$el.find('[' + selectors.trigger + ']')
                .not($selectedTriggers);

        $selectedTriggers
            .removeClass(this.selectors.inactiveClass)
            .addClass(this.selectors.activeClass)
            .hide().show() // webkit clips / hides the button content unless a re-render is forced
            .attr({
              'aria-selected': 'true'
            })
            .find('[data-dough-tab-selector-show]')
            .text(this.i18nStrings.selected);

        $selectedTriggers.closest('[' + selectors.triggerContainer + ']')
            .removeClass(this.selectors.inactiveClass)
            .addClass(this.selectors.activeClass);

        $unselectedTriggers
            .removeClass(this.selectors.activeClass)
            .addClass(this.selectors.inactiveClass)
            .attr('aria-selected', 'false')
            .find('[data-dough-tab-selector-show]')
            .text(this.i18nStrings.show);

        $unselectedTriggers.closest('[' + selectors.triggerContainer + ']')
            .removeClass(this.selectors.activeClass)
            .addClass(this.selectors.inactiveClass);

        return this;
      };

      /**
       * Activate / deactivate any targets based on the trigger clicked
       * @param {string} targetAttr - the value of the clicked trigger
       * @returns {TabSelector}
       * @private
       */
      TabSelector.prototype._updateTargets = function(targetAttr) {
        var $selectedTarget = this.$el.find('[' + selectors.target + '="' + targetAttr + '"]'),
            $unselectedTargets = this.$el.find('[' + selectors.target + ']')
                .not('[' + selectors.target + '="' + targetAttr + '"]');

        $selectedTarget
            .removeClass(this.selectors.inactiveClass)
            .addClass(this.selectors.activeClass)
            .attr({
              'aria-hidden': 'false',
              'tabindex': -1
            });

        this._focusTarget($selectedTarget);

        $unselectedTargets
            .removeClass(this.selectors.activeClass)
            .addClass(this.selectors.inactiveClass)
            .attr({
              'aria-hidden': 'true'
            })
            .removeAttr('tabindex');

        return this;
      };

      /**
       * Focus the selected target panel
       * @param {jQuery} $selectedTarget
       * @private
       */
      TabSelector.prototype._focusTarget = function($selectedTarget) {
        var scrollTop;

        //only focus if tabs not collapsed into a dropdown
        if (!mediaQueries.atSmallViewport()) {
          scrollTop = $(window).scrollTop();
          $selectedTarget.focus();
          // stop the focus from scrolling the page
          $('html,body').scrollTop(scrollTop);
        }
      };

      return TabSelector;


    });
