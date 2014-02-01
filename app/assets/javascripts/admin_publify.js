
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
  if ($("#article_id").val() == "") {
    wideArea().clearData(element);
  }

  wideArea();
}

function tag_manager() {
  var tagApi = jQuery("#article_keywords").tagsManager({
        prefilled: $('#article_keywords').val(),
      });
 
      jQuery("#article_keywords").typeahead({
        name: 'tags',
        limit: 15,
        prefetch: '/admin/content/auto_complete_for_article_keywords'
      }).on('typeahead:selected', function (e, d) {
 
        tagApi.tagsManager("pushTag", d.value);
 
      });
}

function save_article_tags() {
  $('#article_keywords').val($('#article_form').find('input[name="hidden-article[keywords]"]').val());
}

$(document).ready(function() {
  $('#article_form').each(function(e){autosave_request(e)});
  $('#article_form').submit(function(e){save_article_tags()});
  
  $('#article_form').each(function(e){tag_manager()});
  $('#article_form').each(function(e){set_widerea($('#article_body_and_extended'))});
  $('#page_form').each(function(e){set_widerea($('#page_body'))});
  $('.merge_link').each(function(merge_link){ merge_link.click(bind_merge_link); });
});

