window._lang = window._lang || "default" ;
window._l10s = window._l10s || { } ;
window._l10s[_lang] = window._l10s[_lang] || { }

function _(string_to_localize) {
    var args = [ ] ;
    var string_to_localize = arguments[0] ;
    for(var i=1 ; i<arguments.length ; i++) {
      args.push( arguments[i] ) ;
    }
    var translated = _l10s[_lang][string_to_localize] || string_to_localize
    if ( typeof(translated)=='function' ) { return translated.apply(window,args) ; }
    if ( typeof(translated)=='array' ) {
      if (translated.length == 3) {
        translated = translated[args[0]==0 ? 0 : (args[0]>1 ? 2 : 1)] ;
      } else {
        translated = translated[args[0]>1 ? 1 : 0] ;
      }
    }
    return translated.interpolate(args) ;
}

function register_onload(func) {
  Event.observe(window, 'load', func, false);
}

function commentAdded(request) {
  Element.cleanWhitespace('commentList');
  new Effect.BlindDown($('commentList').lastChild);
  if ($('dummy_comment')) { Element.remove('dummy_comment'); }
  $('commentform').elements["comment_body"].value = '';
  $('commentform').elements["comment_body"].focus();
}

function failure(request) {
  $('errors').innerHTML = request.responseText;
  new Effect.Highlight('errors');
}

function loading() {
  $('form-submit-button').disabled = true;
  Element.show('comment_loading');
  new Element.hide('preview');
}

function complete(request) {
  Element.hide('comment_loading');
  Element.show('commentform');
  $('form-submit-button').disabled = false;

  if (request.status == 200) { commentAdded() };
}

function popup(mylink, windowname)
{
  if (! window.focus) return true;
  var href;
  window.open(mylink, windowname, 'width=400,height=500,scrollbars=yes');
  return false;
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

register_onload(function() {
  if ($('commentform')) {
    var _author = getCookie('author');
    var _url = getCookie('url');

    if(_author != null) { $('commentform').elements['comment[author]'].value = _author }
    if(_url != null) { $('commentform').elements['comment[url]'].value = _url }

    if ($('commentform').elements['comment[url]'].value != ''
        || $('commentform').elements['comment[email]'].value != '') {
      Element.show('guest_url'); Element.show('guest_email');
    }
  }
})
register_onload(function() { if ($('q')) {$('q').setAttribute('autocomplete', 'off');} })

