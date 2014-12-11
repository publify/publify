define(['rsvp'], function (RSVP) {
  var subscriptions = {};

  return {

    /**
     * Add a subscription to the specified event name. If a context is supplied, the subscription
     * can later be removed using unsubscribe
     * @param {string} eventName
     * @param {function} callback
     * @param {object} [context]
     */
    subscribe: function (eventName, callback, context) {
      var found = false;

      if (!eventName || (typeof eventName !== 'string')) {
        throw "Event name not supplied to subscribe method";
      }
      if (!callback || (typeof callback !== 'function')) {
        throw "Callback not supplied to subscribe method";
      }

      if (!subscriptions[eventName]) {
        subscriptions[eventName] = [];
      } else {
        for (var i = 0, j = subscriptions[eventName].length; i < j; i++) {
          if (subscriptions[eventName][i].callback === callback) {
            found = true;
            break;
          }
        }
      }
      if (!found) {
        subscriptions[eventName].push({
          callback: callback,
          context: context
        });
      }
    },

    /**
     * Unsubscribe from the supplied event. The original subscription must have supplied a context, so the
     * it can be found in the stored list of subscriptions.
     * @param {string} eventName
     * @param {object} context
     */
    unsubscribe: function (eventName, context) {
      if (!eventName || (typeof eventName !== 'string')) {
        throw "Event name not supplied to unsubscribe method";
      }
      if (!context || (typeof context !== 'object')) {
        throw "Context not supplied to unsubscribe method";
      }
      if (subscriptions[eventName]) {
        for (var i = 0, j = subscriptions[eventName].length; i < j; i++) {
          if (subscriptions[eventName][i].context === context) {
            subscriptions[eventName].splice(i, 1);
            break;
          }
        }
      }
    },

    /**
     * Unsubscribe all events
     */
    unsubscribeAll: function () {
      subscriptions = {};
    },

    /**
     * Publish an event. Every listener will be supplied with its own individual
     * promise, which it can resolve or reject. If all are resolved successfully, the main promise will be resolved.
     * If even one of them is rejected or fails, the main promise will fail.
     * @param {string} eventName
     * @param {*} data
     * @returns {object} Promise
     */
    publish: function (eventName, data) {
      var subscriptionsForEvent,
          promises = [],
          deferreds = [],
          master;

      if (subscriptions[eventName]) {
        subscriptionsForEvent = subscriptions[eventName];
        for (var i = 0, j = subscriptionsForEvent.length; i < j; i++) {
          deferreds.push(RSVP.defer());
          promises.push(deferreds[i].promise);
        }
        master = RSVP.allSettled(promises);
        for (var i = 0, j = subscriptionsForEvent.length; i < j; i++) {
          if (subscriptionsForEvent[i].context) {
            subscriptionsForEvent[i].callback.call(subscriptionsForEvent[i].context, data, deferreds[i] || null)
          } else {
            subscriptionsForEvent[i].callback(data, deferreds[i] || null);
          }
        }
        return master;

      }
    }

  }
});
