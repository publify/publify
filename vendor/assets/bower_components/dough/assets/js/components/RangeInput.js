/**
 * Clone a range input / slider from an existing text / number input, when the range type is supported by the browser
 * @param  {jQuery} $                  [description]
 * @param  {object} DoughBaseComponent [description]
 * @param  {object} featureDetect      [description]
 * @param  {object} eventsWithPromises [description]
 * @return {object}                    [description]
 */
define(['jquery', 'DoughBaseComponent', 'featureDetect', 'eventsWithPromises'],
    function($, DoughBaseComponent, featureDetect, eventsWithPromises) {
  'use strict';

  var defaultConfig = {
        keepSynced: true
      },

      /**
       * Call base constructor
       * @constructor
       */
      RangeInput = function($el, config) {
        RangeInput.baseConstructor.call(this, $el, config, defaultConfig);

        if (featureDetect.inputtypes.range) {
          this._cloneElements();
        }
      };

  DoughBaseComponent.extend(RangeInput);

  /**
   * Init - detect range type support and clone input / label
   * @param {boolean} initialised
   */
  RangeInput.prototype.init = function(initialised) {
    this._initialisedSuccess(initialised);
  };

  RangeInput.prototype._cloneElements = function() {
    var $textInput,
        $rangeInput;

    $textInput = this.$el.find('[data-dough-range-input]');
    $rangeInput = $textInput
        .clone()
        .removeClass('input--label')
        .addClass('form__input-range')
        .attr({
          'id': $textInput.attr('id') + '_range',
          'type': 'range',
          'aria-role': 'slider'
        })
        .removeAttr('name data-dough-range-input')
        .on('input change', function() { // recapture focus on slider for iOS w/ Voiceover
          $(this).focus();
        })
        .appendTo(this.$el);

    if (this.config.keepSynced === true) {
      this._setupSyncInputs($textInput, $rangeInput);
    }
  };

  RangeInput.prototype._setupSyncInputs = function($textInput, $rangeInput) {
    $textInput.on('change keyup', function() {
      var val = $textInput.val();
      $rangeInput.val(val);
      eventsWithPromises.publish('rangeInput:change', {
        emitter: $textInput,
        value: val
      });
    });
    $rangeInput.on('change input', function() {
      $textInput.val($rangeInput.val());
    });
  };

  return RangeInput;

});
