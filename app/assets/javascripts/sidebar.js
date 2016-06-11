var bind_sortable = function() {
  $('.sortable').sortable({
    dropOnEmpty: true,
    stop: function(evt, ui) {
      var data = $(this).sortable('serialize', {attribute: 'data-sortable'});
      var callback_url = $(this).data('callback_url');

      $.ajax({
        data: data,
        type: 'POST',
        dataType: 'script',
        url: callback_url
      }).fail(function(jqXHR, textStatus, errorThrown) { alert('Oups?'); });
    }
  });

  $('.draggable').draggable({
    connectToSortable: '.sortable',
    helper: "clone",
    revert: "invalid"
  });
};
$(document).ready(function() {
  bind_sortable();
});
