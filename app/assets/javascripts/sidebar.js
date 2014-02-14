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

  $('.draggable').draggable({ 
                                  connectToSortable: '.sortable',
                                  helper: "clone",
                                  revert: "invalid"
                            });
  $('.sidebar_item').on('ajax:success', function(data, textStatus, xhr) {
                                         $(this).parent().replaceWith(data);
                                       }
                       );
  $('.deletion_link').on('ajax:success', function(data, textStatus, xhr) {
                                         $(this).parent().remove();
                                       }
                       );
}
$(document).ready(function() {
  bind_sortable();
});
