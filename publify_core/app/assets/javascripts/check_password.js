// Show and hide spinners on Ajax requests.
$(document).ready(function() {
  $('form.check_password').on('ajax:complete',
    function(evt, xhr, stat) {
      var form = evt.currentTarget;
      var elem = document.getElementById(form.dataset["update"]);
      elem.outerHTML = xhr.responseText;
    })
});
