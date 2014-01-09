
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
  if ($("#article_body_and_extended").val() == "") {
    wideArea().clearData("#article_body_and_extended");
  }

  wideArea("#editor");

}

$(document).ready(function() {
  $('#article_form').each(function(e){autosave_request(e)});
  $('#article_form').each(function(e){set_widerea($('#article_body_and_extended'))});
//  $('#article_form .new_category').each(function(cat_link){ cat_link.click(bind_new_category_overlay); });
  $('.merge_link').each(function(merge_link){ merge_link.click(bind_merge_link); });
  $('#page_form').each(function(){load_page_form();})
  $('#page_form').submit(function(){submit_page_form()});
});
