$(document).ready(function(){
  var timer = 0;

  var handle_field_change = function(evt) {
    var $field = $(evt.target);
    var url = $field.data('url');
    var target = $field.data('target');
    var spinner = $field.data('spinner');
    $(spinner).show();
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'html',
      data: $field.serialize(),
      success: function(data) { $(target).html(data); },
      complete: function() { $(spinner).hide(); }
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
