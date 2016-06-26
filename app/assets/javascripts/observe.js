$(document).ready(function(){
  $('.observable').on('change',
      function(evt) {
        var $field = $(evt.target);
        var url = $field.data('url');
        var target = $field.data('target');
        $.get(url, $field.serialize(),
            function(data) {
              $(target).html(data);
            });
      });
});
