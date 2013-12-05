$(document).ready(function() {
  $('#available_box, #active').children().draggable({ revert: 'invalid' });
  $('#available_box').droppable({ 
                                  accept: '#active > *',
                                  drop: function(evt, ui) {
                                    var draggable_id = parseInt(ui.draggable.attr('id').split(/-/)[1])
                                    $.ajax({
                                      url: '/admin/sidebar/staging',
                                      method: 'PUT',
                                      dataType: 'html',
                                      data: {id: draggable_id, active: false}
                                    })
                                  }
                                });
  $('#active').droppable({ accept: '#available_box > *' });
});
