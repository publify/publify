




// RequireJS config
if(window.requirejs) {
  requirejs.config({
  "baseUrl": "/assets",
  "paths": {
    "jquery": "/assets/jquery/dist/jquery",
    "rsvp": "/assets/rsvp/rsvp",
    "eventsWithPromises": "/assets/eventsWithPromises/src/eventsWithPromises",
    "Header": "/assets/components/Header",
    "componentLoader": "/assets/dough/assets/js/lib/componentLoader",
    "DoughBaseComponent": "/assets/dough/assets/js/components/DoughBaseComponent",
    "Collapsable": "/assets/dough/assets/js/components/Collapsable"
  },
  "shim": {
  }
});
}
;
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



if (MAS.fonts.loadWithJS && MAS.fonts.url && !MAS.fonts.localstorage) {
  require(['jquery'], function($) {
    $.ajax({
      url: MAS.fonts.url,
      success: function(res) {
        $('html').addClass(MAS.fonts.loadClass);
        $('head').append('<style>' + res + '</style>');
        if (MAS.supports.localstorage) {
          localStorage.setItem(MAS.fonts.cacheName, res);
        }
      },
      dataType: 'text'
    });
  });
}

require(['componentLoader', 'eventsWithPromises'], function(componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
  eventsWithPromises.subscribe('component:contentChange', function(data) {
    componentLoader.init(data.$container);
  });
});
