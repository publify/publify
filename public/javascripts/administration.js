function autosave_request(e) {
  new Form.Observer (e, 30, function(element, value) {
			if ($('current_editor').value == 'visual') {
				$('article__body_and_extended_editor').value = FCKeditorAPI.GetInstance('article__body_and_extended_editor').GetHTML();
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

function FCKeditor_OnComplete( editorInstance )
{
	if((editorInstance.Name == 'article__body_and_extended_editor' || editorInstance.Name == 'page__body_editor') && typeof(html2) != 'undefined') {
		FCKeditorAPI.GetInstance(editorInstance.Name).InsertHtml(html2);
		html2 = null;
		$('simple_editor').innerHTML = "";
	} 
}