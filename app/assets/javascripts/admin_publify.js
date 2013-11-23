
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
    })
  });
}

i=0;
j=0;

$(document).ready(function() {
  $("#article_body_and_extended").keyup(function (e) { adaptiveheight(this); });
  $("#page_body").keyup(function (e) { adaptiveheight(this); });
  $('.autosave').each(function(e){autosave_request(e)});
  $('#article_form .new_category').each(function(cat_link){ cat_link.click(bind_new_category_overlay); });
  $('.merge_link').each(function(merge_link){ merge_link.click(bind_merge_link); });
});

function adaptiveheight(a) {
    $(a).height(0);
    var scrollval = $(a)[0].scrollHeight;
    $(a).height(scrollval);
    if (parseInt(a.style.height) > $(window).height()) {
        if(j==0){
            max=a.selectionEnd;
        }
        j++;
        var i =a.selectionEnd;
        console.log(i);
        if(i >=max){
            $(document).scrollTop(parseInt(a.style.height));
        }else{
            $(document).scrollTop(0);
        }
    }
}

