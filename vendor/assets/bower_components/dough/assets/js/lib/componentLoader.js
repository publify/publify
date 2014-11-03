/**
 * UI component loader. Scans the supplied DOM for 'data-dough-component' attributes and initialises
 * components based on those attribute values
 * eg. the following markup will cause 2 components to be initialised, DropdownList and MultiToggler
 *
 <div class="container">
 <div data-dough-component="DropdownList">
 </div>
 <div data-dough-component="MultiToggler">
 </div>
 </div>

 * Components are created in 2 separate passes. The reason for this is so that all components can
 * have a chance to set up listeners to any other components they need. Once they are all created,
 * they are initialised (the 'init' method of each is called) in a second pass.
 */
define(['jquery', 'rsvp'], function($, RSVP) {

  'use strict';

  return {

    /**
     * Will store a hash. Each key will store a component name. Each value will store an array of
     * instances of that component type
     * @attribute
     * @type {object}
     */
    components: {},

    /**
     * Create components based on the supplied DOM fragment (or document if not supplied)
     * @param {jQuery} [$container]
     * @returns {object} - a promise that will resolve or reject depending on whether all modules
     * initialise successfully
     */
    init: function($container) {
      var componentsToCreate,
          instantiatedList,
          initialisedList,
          self = this,
          promises;

      this.components = {};
      // if no DOM fragment supplied, use the document
      $container = $container || $('body');
      componentsToCreate = this._listComponentsToCreate($container);
      instantiatedList = this._createPromises(componentsToCreate);
      initialisedList = this._createPromises(componentsToCreate);
      if (componentsToCreate.length) {
        this._instantiateComponents(componentsToCreate, instantiatedList.deferreds);
        // Wait until all components are instantiated before initialising them in a second pass
        RSVP.allSettled(instantiatedList.promises).then(function() {
          self._initialiseComponents(self.components, initialisedList.deferreds);
        });
      }
      promises = RSVP.allSettled(initialisedList.promises);
      promises.then(function() {
        $('body').attr('data-dough-component-loader-all-loaded', 'yes');
      });
      return promises;
    },

    /**
     * Make an array of objects, each containing pointers to a component container and name
     * @param {object} $container
     * @returns {Array}
     * @private
     */
    _listComponentsToCreate: function($container) {
      var componentsToCreate = [],
          $els,
          $el,
          attrs;

      $els = $container.find('[data-dough-component]');
      $els.each(function() {
        $el = $(this);
        attrs = $el.attr('data-dough-component').split(' ');
        $.each(attrs, function(idx, val) {
          if (!$el.is('[data-dough-' + val + '-initialised="yes"]')) {
            componentsToCreate.push({
              $el: $el,
              componentName: val
            });
          }
        });
      });
      return componentsToCreate;
    },

    /**
     * Create a hash of deferreds and their associated promise properties (useful for passing to a
     * 'master' deferred for resolution)
     * @param {Array} componentsToCreate
     * @returns {{deferreds: Array, promises: Array}}
     * @private
     */
    _createPromises: function(componentsToCreate) {
      var obj = {
        deferreds: [],
        promises: []
      };

      $.each(componentsToCreate, function(idx) {
        obj.deferreds.push(RSVP.defer());
        obj.promises.push(obj.deferreds[idx].promise);
      });
      return obj;
    },

    /**
     * Instantiate all components
     * @param {Array} componentsToCreate
     * @param {Array} instantiatedList - array of deferreds, one to be assigned to each new
     * component
     * @private
     */
    _instantiateComponents: function(componentsToCreate, instantiatedList) {
      var self = this;
      $.each(componentsToCreate, function(idx, componentData) {
        self._instantiateComponent(componentData.componentName, componentData.$el, instantiatedList[idx]);
      });
    },

    /**
     * Instantiate an individual component
     * @param {string} componentName
     * @param {object} $el
     * @param {object} instantiated - a deferred, to be resolved after each component is required /
     * instantiated, which may be async, hence the use of a deferred
     * @private
     */
    _instantiateComponent: function(componentName, $el, instantiated) {
      var self = this,
          config = this._parseConfig($el, componentName);

      require([componentName], function(Constr) {
        config.componentName = componentName;
        if (!self.components[componentName]) {
          self.components[componentName] = [];
        }
        self.components[componentName].push(new Constr($el, config));
        instantiated.resolve();
      });
    },

    /**
     * The second pass - all components have been instantiated, so now call init() on each. This
     * has given all components a chance to subscribe to events from other components, before they
     * are initialised. If one component errors, catch it so others to initialise
     * @param {object} components - a hash of component names and arrays of instances
     * @param {array} initialisedList - list of promises, one to pass to each component so it can
     * indicate when it has initialised (it might need to conduct async activity to do so, so it's
     * not enough to just set a flag after the constructor is called)
     * @private
     */
    _initialiseComponents: function(components, initialisedList) {
      var i = 0;

      $.each(components, function(componentName, list) {
        $.each(list, function(idx, instance) {
          try {
            instance.init && instance.init(initialisedList[i]);
          } catch (err) {
            initialisedList[i].reject(err);
          }
          i++;
        });
      });
    },

    /**
     * Extract any config from the DOM for a given component
     * @param {jQuery} $el - component container
     * @param {string} componentName
     * @returns {object} - parsed JSON config or empty object
     * @private
     */
    _parseConfig: function($el, componentName) {
      var config = $el.attr('data-dough-' + this._convertComponentNameToDashed(componentName) + '-config');
      try {
        config = JSON.parse(config);
      } catch (err) {
        config = {};
      }
      return config;
    },

    /**
     * Converts camelcase component name to dashed
     * @param {string} componentName eg. TabSelector
     * @private
     * @returns {string} eg. tab-selector
     */
    _convertComponentNameToDashed: function(componentName) {
      var val = componentName.replace(/([A-Z])/g, function($1) {
        return '-' + $1.toLowerCase();
      });
      return val.substr(1);
    }

  };

});
