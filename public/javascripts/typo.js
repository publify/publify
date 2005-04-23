function register_onload(func) {
  var old_event = window.onload;
  if (typeof window.onload != 'function')
    window.onload = func;
  else  
    window.onload = function() { old_event(); func(); };
}

register_onload(function () { 
  $('q').setAttribute('autocomplete', 'off'); 
  })