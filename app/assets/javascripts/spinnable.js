// Show and hide spinners on Ajax requests.
$(document).ready(function(){
  $('form.spinnable').on('ajax:before', function(evt, xhr, status){ $('#spinner').show();})
  $('form.spinnable').on('ajax:after', function(evt, xhr, status){ $('#spinner').hide();})
});
