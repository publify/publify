// Admin javascript manifest
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/datepicker-da
//= require jquery-ui/datepicker-de
//= require jquery-ui/datepicker-es
//= require jquery-ui/datepicker-fr
//= require jquery-ui/datepicker-he
//= require jquery-ui/datepicker-it
//= require jquery-ui/datepicker-ja
//= require jquery-ui/datepicker-lt
//= require jquery-ui/datepicker-nb
//= require jquery-ui/datepicker-nl
//= require jquery-ui/datepicker-pl
//= require jquery-ui/datepicker-pt-BR
//= require jquery-ui/datepicker-ro
//= require jquery-ui/datepicker-ru
//= require jquery-ui/datepicker-zh-CN
//= require jquery-ui/datepicker-zh-TW
//= require datetimepicker
//= require bootstrap
//= require quicktags
//= require widearea
//= require tagmanager
//= require typeahead
//= require sidebar
//= require spinnable
//= require lightbox
//
//= require_self

/* typewatch() borrowed from
 * http://stackoverflow.com/questions/2219924/idiomatic-jquery-delayed-event-only-after-a-short-pause-in-typing-e-g-timew
 */
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
    }, 5000)
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
    prefilled: $('#article_keywords').val()
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

function doneTyping () {
  $( "#save-bar").fadeIn(2000, function() {

  });
}

function set_savebar() {
  var typingTimer;
  var doneTypingInterval = 3000;

  $( "#article_body_and_extended" ).keydown(function() {
    $( "#save-bar").fadeOut(2000, function() {

    });
    clearTimeout(typingTimer);
  });

  $('#article_body_and_extended').keyup(function(){
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
  });
}

// From http://www.shawnolson.net/scripts/public_smo_scripts.js
function check_all(checkbox) {
  var form = checkbox.form, z = 0;
  for(z=0; z<form.length;z++){
    if(form[z].type == 'checkbox' && form[z].name != 'checkall'){
      form[z].checked = checkbox.checked;
    }
  }
}

$(document).ready(function() {
  $('#article_form').each(function(e){autosave_request(e)});
  $('#article_form').submit(function(e){save_article_tags()});
  $('#article_form').each(function(e){tag_manager()});
  $('#article_form').each(function(e){set_widerea($('#article_body_and_extended'))});
  $('#article_body_and_extended').each(function(e){set_savebar()});
  $('#page_form').each(function(e){set_widerea($('#page_body'))});

  // DatePickers
  $('.datepicker').each(function() {
    $(this).datepicker($.datepicker.regional[this.dataset.locale]);
  });

  // Date time picker (not related to date picker at all!)
  $( "#article_published_at" ).datetimepicker();

  // DropDown
  $(".dropdown-toggle").dropdown();
});

$(document).delegate('*[data-toggle="lightbox"]', 'click',
    function(event) {
      event.preventDefault();
      $(this).ekkoLightbox();
    });
