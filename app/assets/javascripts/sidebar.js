$(document).ready(function() {
  $('.sortable').sortable({
                            stop: function(evt, ui) {
                                    var data = $(this).sortable('serialize');

                                    $.ajax({
                                        data: data,
                                        type: 'PUT',
                                        dataType: 'json',
                                        url: '/admin/sidebar/sortable'
                                    });
                            },
                          
  });
  //$('.sortable').disableSelection();

  $('#available_box, #active').children().draggable({ revert: 'invalid' });
  $('#available_box').draggable({ 
                                  accept: '.draggable',
                                  hoverClass: 'draggable-hover',
                                  connectToSortable: '.sortable',
                                  revert: true 
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
  $('#active').droppable({ accept: '#available_box > *' });
});
