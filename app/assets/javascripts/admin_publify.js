/* typewatch() borrowed from http://stackoverflow.com/questions/2219924/idiomatic-jquery-delayed-event-only-after-a-short-pause-in-typing-e-g-timew  */
var typewatch = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  }
})();

function set_widerea(element) {
  if ($("#article_id").val() == "") {
    wideArea().clearData(element);
  }

  wideArea();
}

function tag_manager() {
  var tagUrl = "/admin/content/auto_complete_for_article_keywords";

  $.getJSON(tagUrl, function (tags) {

    $('#article_keywords').val($('#article_keywords').val().replace(/\"/g,""));

    var tagApi = $("#article_keywords").tagsManager({
      prefilled: $('#article_keywords').val(),
      onlyTagList: true,
      tagList: tags
    });

    $("#article_keywords").typeahead({
      limit: 15,
      prefetch: tagUrl
    }).on('typeahead:selected', function (e, d) {
      tagApi.tagsManager("pushTag", d.value);
    });
  });
}

function save_article_tags() {
  var hiddenArticleKeywords = $('#article_form').find('input[name="hidden-article[keywords]"]').val(),
      keywords = hiddenArticleKeywords.split(',');

  if (hiddenArticleKeywords == "") {
    $('#article_keywords').val("");
    return;
  }

  for (keyword in keywords) {
    keywords[keyword] = '"' + keywords[keyword] + '"'
  }

  $('#article_keywords').val(keywords.join(','));
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

$(document).ready(function() {
  $('#article_form').submit(function(e){save_article_tags()});
  $('#article_form').each(function(e){tag_manager()});
  $('#article_form').each(function(e){set_widerea($('#article_body_and_extended'))});
  $('#article_body_and_extended').each(function(e){set_savebar()});
  $('#page_form').each(function(e){set_widerea($('#page_body'))});
});

$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
    event.preventDefault();
    $(this).ekkoLightbox();
});
