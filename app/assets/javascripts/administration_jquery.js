$(document).ready(function(){
  // Spinners
  $('form.spinnable').on('ajax:before', function(evt, xhr, status){ $('#spinner').show();})
  $('form.spinnable').on('ajax:after', function(evt, xhr, status){ $('#spinner').hide();})

  // DatePickers
  $('.datepicker').datepicker();

  // DropDown
  $(".dropdown-toggle").dropdown();
});
