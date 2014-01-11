
/* typewatch() borrowed from http://stackoverflow.com/questions/2219924/idiomatic-jquery-delayed-event-only-after-a-short-pause-in-typing-e-g-timew  */
var typewatch = (function(){  
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  }  
})();

function autosave_request(e) {
  $('#article_form').keyup(function() {
    typewatch(function() {
      $.ajax({
        type: "POST",
        url: '/admin/content/autosave',
        data: $("#article_form").serialize()});
    }, 1000)
  });
}

function set_widerea(element) {
  if ($("#article_id").value() == "") {
    wideArea().clearData(element);
  }

  wideArea();
}

$(document).ready(function() {
  $('#article_form').each(function(e){autosave_request(e)});
  $('#article_form').each(function(e){set_widerea($('#article_body_and_extended'))});
  $('#page_form').each(function(e){set_widerea($('#page_body'))});
  $('.merge_link').each(function(merge_link){ merge_link.click(bind_merge_link); });
});
