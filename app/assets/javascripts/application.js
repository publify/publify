// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require require_config

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
