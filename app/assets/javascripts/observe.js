$(document).ready(function(){
  var timer = 0;

  var handle_field_change = function(evt) {
    var $field = $(evt.target);
    var url = $field.data('url');
    var target = $field.data('target');
    $.get(url, $field.serialize(),
        function(data) {
          $(target).html(data);
        });
  };

  var delay_callback = function(callback) {
    clearTimeout(timer);
    timer = setTimeout(callback, 200);
  }

  $('.observable').on('keyup keydown paste', function(evt) {
    delay_callback(function() { handle_field_change(evt) });
  });
});
