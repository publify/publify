var bind_sortable = function() {
  $('.sortable').sortable({
                            dropOnEmpty: true,
                            stop: function(evt, ui) {
                                    var data = $(this).sortable('serialize', {attribute: 'data-sortable'});

                                    $.ajax({
                                        data: data,
                                        type: 'PUT',
                                        dataType: 'json',
                                        url: '/admin/sidebar/sortable',
                                        statusCode: {
                                          200: function(data, textStatus, jqXHR) {
                                                 $('#sidebar-config').replaceWith(data.html);
                                                 bind_sortable();
                                               },
                                          500: function(jqXHR, textStatus, errorThrown) {
                                                 alert('Oups?');
                                               } 
                                        }
                                    });
                            },
                          
  });
  //$('.sortable').disableSelection();

  $('.draggable').draggable({ 
                                  connectToSortable: '.sortable',
                                  helper: "clone",
                                  revert: "invalid"
                                  //drop: function(evt, ui) {
                                  //  var draggable_id = parseInt(ui.draggable.attr('id').split(/-/)[1])
                                  //  $.ajax({
                                  //    url: '/admin/sidebar/staging',
                                  //    method: 'PUT',
                                  //    dataType: 'html',
                                  //    data: {sidebar_id: draggable_id, staged_position: -1},
                                  //    statusCode: {
                                  //      200: function(data, textStatus, jqXHR) {
                                  //             $('#sidebar-config').replaceWith(data)
                                  //           }
                                  //    }
                                  //  })
                                  //}
                                });
}
$(document).ready(function() {
  bind_sortable();
});
