function autosave_request(e) {
  new Form.Observer (e, 30, function(element, value) {
			if ($('current_editor').value == 'visual') {
				$('article__body_and_extended_editor').value = CKEDITOR.instances.article__body_and_extended_editor.getData();;
			}
			
      new Ajax.Request(e.action.gsub(/\/new\/{0,1}/, '/autosave/') , {
                                        asynchronous:true, 
                                        evalScripts:true, 
                                        parameters: Form.serialize(e)
                                      })
			var g = new k.Growler({location : 'br'}); 
			g.info('Article was successfully saved', {life: 3});
})
  
}

Event.observe(window, 'load', function() {
  $$('.autosave').each(function(e){autosave_request(e)})
})
