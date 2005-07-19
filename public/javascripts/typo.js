function register_onload(func) {
  var old_event = window.onload;
  if (typeof window.onload != 'function') { window.onload = func; }
  else { window.onload = function() { old_event(); func(); }; }
}
  
function show_date_as_local_time() {
  var spans = document.getElementsByTagName('span');
  for (var i=0; i<spans.length; i++) {
    if (spans[i].className.match(/\btypo_date\b/i)) {
      system_date = new Date(spans[i].title);
      user_date = new Date();
      delta_minutes = Math.round((user_date - system_date) / (60 * 1000));
      if (Math.abs(delta_minutes) <= (8*7*24*60)) { // eight weeks... I'm lazy to count days for longer than that
        spans[i].innerHTML = distance_of_time_in_words(delta_minutes) + ' ago';
      } else {
        spans[i].innerHTML = 'on ' + post_date.toLocaleDateString();
      }
    }
  }
}

// a vague copy of rails' inbuilt function, 
// but a bit more friendly with the hours.
function distance_of_time_in_words(minutes) {
  if (minutes.isNaN) return "";
  minutes = Math.abs(minutes);
  if (minutes < 1) return ('less than a minute');
  if (minutes < 50) return (minutes + ' minutes');
  if (minutes < 90) return ('about one hour');
  if (minutes < 1080) return (Math.round(minutes / 60) + ' hours');
  if (minutes < 1440) return ('one day');
  if (minutes < 2880) return ('about one day');
  else return (Math.round(minutes / 1440) + ' days')
}

function commentAdded(request) {
  new Effect.BlindDown($('commentList').lastChild);
  $('commentform').elements[3].value = '';
  $('commentform').elements[3].focus();
}

function failure(request) {
  $('errors').innerHTML = request.responseText;
  new Effect.Highlight('errors');
}

function loading() {
  $('form-submit-button').disabled = true;
  Element.show('comment_loading');
}

function complete(request) {
  Element.hide('comment_loading');
  Element.show('commentform');
  $('form-submit-button').disabled = false;  

  if (request.status == 200) { commentAdded() };  
}

register_onload(function() {
  if ($('commentform')) {
    $('commentform').elements('comment[author]').value = getCookie('author');
    $('commentform').elements('comment[url]').value = getCookie('url');
    
    if ($('commentform').elements('comment[url]').value != ''
        || $('commentform').elements('comment[email]').value != '') {
      Element.show('guest_url'); Element.show('guest_email');
    }
  }
})
register_onload(function() { $('q').setAttribute('autocomplete', 'off'); })
register_onload(function () { show_date_as_local_time(); })
