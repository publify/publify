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

function show_dates_as_local_time() {
    $$('span.typo_date').each(function(e){
        var classname = e.className ;
        var gmtdate = '' ;
        res = classname.match( /gmttimestamp-(\d+)/ ) ;
        if (!res) {
          gmtdate = e.title ;
        } else {
          gmtdate = new Date() ;
          gmtdate.setTime( parseInt(res[1]) * 1000 )  ;
        }
        e.update(get_local_time_for_date(gmtdate))
    })
}

function get_local_time_for_date(time) {
  if (typeof(time)=='date') {
    system_date = time ;
  } else {
    system_date = new Date(time);
  }
  user_date = new Date();
  delta_minutes = Math.floor((user_date - system_date) / (60 * 1000));
  if (Math.abs(delta_minutes) <= (8*7*24*60)) { // eight weeks... I'm lazy to count days for longer than that
    distance = distance_of_time_in_words(delta_minutes);
    if (delta_minutes < 0) {
      return _("#{0} from now", distance) ;
    } else {
      return _("#{0} ago", distance) ;
    }
  } else {
    return _('on #{0}', system_date.toLocaleDateString());
  }
}

// a vague copy of rails' inbuilt function,
// but a bit more friendly with the hours.
function distance_of_time_in_words(minutes) {
  if (minutes.isNaN) return "";
  minutes = Math.abs(minutes);
  if (minutes < 1) return (_('less than a minute'));
  if (minutes < 50) return (_( '#{0} minute' + (minutes == 1 ? '' : 's'), minutes));
  if (minutes < 90) return (_('about one hour'));
  if (minutes < 1080) return (_("#{0} hours", Math.round(minutes / 60)));
  if (minutes < 1440) return (_('one day'));
  if (minutes < 2880) return (_('about one day'));
  else return (_("#{0} days", Math.round(minutes / 1440))) ;
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

