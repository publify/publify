//= require jquery
//= require jquery_ujs
//= require quicktags
//= require_self
//= require_tree .

/* typewatch() borrowed from http://stackoverflow.com/questions/2219924/idiomatic-jquery-delayed-event-only-after-a-short-pause-in-typing-e-g-timew  */
var typewatch = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  }  
})();

function autosave_request(e) {
  e.find('textarea').keyup(function() {
    typewatch(function() {
      e.up('form.autosave').ajax('/admin/content/autosave', e.serialize());
    }
  }));
}
$(document).ready(function() {
  $('.autosave').each(function(e){autosave_request(e)});
  $('#article_form .new_category').each(function(cat_link){ cat_link.click(bind_new_category_overlay); });
  $('.merge_link').each(function(merge_link){ merge_link.click(bind_merge_link); });
})
