function autosave_request(e) {
  new Form.Observer (e, 60, function(element, value) {
      new Ajax.Request(e.action.gsub(/\/new\/{0,1}/, '/autosave/') , {
                                        asynchronous:true, 
                                        evalScripts:true, 
                                        parameters: Form.serialize(e)
                                      })})
}

Event.observe(window, 'load', function() {
  $$('.autosave').each(function(e){autosave_request(e)})
})
