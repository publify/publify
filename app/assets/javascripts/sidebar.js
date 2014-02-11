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
  $('.fake_button').on('ajax:beforeSend', function(e, xhr, settings) {

                         console.log('BS befr');
                         settings.data = $(this).parents('.active').find('input').serializeArray();
                         console.log('BS after');
                       });
  $('.fake_button').on('ajax:after', function(e, xhr, settings) {
                         console.log('after');
                       });

}
$(document).ready(function() {
  bind_sortable();
});
