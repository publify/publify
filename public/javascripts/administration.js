function autosave_request(e) {

  new Form.Observer (e, 30, function(element, value) {
			if ($('current_editor').value == 'visual') {
				$('article__body_and_extended_editor').value = CKEDITOR.instances.article__body_and_extended_editor.getData();;
			}

      new Ajax.Request(e.action.gsub(/\/admin\/content\/{0,1}.*/, '/admin/content/autosave') , {
                                        asynchronous:true,
                                        evalScripts:true,
                                        parameters: Form.serialize(e)
                                      })
			var g = new k.Growler({location : 'br'});
			g.info('Article was successfully saved', {life: 3});
})

}

Event.observe(window, 'load', function() {
  $$('.autosave').each(function(e){autosave_request(e)});
  $$('#article_form .new_category').each(function(cat_link){ cat_link.observe('click', bind_new_category_overlay); });
  $$('.merge_link').each(function(merge_link){ merge_link.observe('click', bind_merge_link); });
})

// UJS for new category link in admin#new_article
function bind_new_category_overlay(event) {
  new Ajax.Request(event.element().readAttribute('href'),
  {
    method:'get',
    onSuccess: function(transport){
      var response = transport.responseText;
      Element.insert(document.body, {top: response });
      window.scrollTo(window.pageXOffset, 0); 
    },
    onFailure: function(){ alert('Something went wrong...') }
  });
  event.stop();
}

// JS for merging tags links in admin#tags
function bind_merge_link(e) {
  var merger = $('tag_merger');
  if(!merger) { return; }
  merger.hide();
  // Take calling element, then take informations
  var tag_id = e.element()['id'] + 0;
  var tag_name = e.element().up(1).previous().text;
  merger.down('span').update(tag_name);
  merger.show();
  e.stop();
}

// JS QuickTags version 1.3.1
//
// Copyright (c) 2002-2008 Alex King
// http://alexking.org/projects/js-quicktags
//
// Thanks to Greg Heo <greg@node79.com> for his changes
// to support multiple toolbars per page.
//
// Licensed under the LGPL license
// http://www.gnu.org/copyleft/lesser.html
//
// **********************************************************************
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// **********************************************************************


var dictionaryUrl = 'http://www.ninjawords.com/';
var edButtons = new Array();
var edLinks = new Array();
var edOpenTags = new Array();

function edButton(id, display, tagStart, tagEnd, access, open) {
	this.id = id;				// used to name the toolbar button
	this.display = display;		// label on button
	this.tagStart = tagStart; 	// open tag
	this.tagEnd = tagEnd;		// close tag
	this.access = access;			// set to -1 if tag does not need to be closed
	this.open = open;			// set to -1 if tag does not need to be closed
}

edButtons.push(
	new edButton(
		'ed_bold'
		,'b'
		,'<strong>'
		,'</strong>'
		,'b'
	)
);

edButtons.push(
	new edButton(
		'ed_italic'
		,'i'
		,'<em>'
		,'</em>'
		,'i'
	)
);

edButtons.push(
	new edButton(
		'ed_link'
		,'link'
		,''
		,'</a>'
		,'a'
	)
); // special case

edButtons.push(
	new edButton(
		'ed_img'
		,'img'
		,''
		,''
		,'m'
		,-1
	)
); // special case

edButtons.push(
	new edButton(
		'ed_ul'
		,'ul'
		,'<ul>\n'
		,'</ul>\n\n'
		,'u'
	)
);

edButtons.push(
	new edButton(
		'ed_ol'
		,'ol'
		,'<ol>\n'
		,'</ol>\n\n'
		,'o'
	)
);

edButtons.push(
	new edButton(
		'ed_li'
		,'li'
		,'\t<li>'
		,'</li>\n'
		,'l'
	)
);

edButtons.push(
	new edButton(
		'ed_block'
		,'b-quote'
		,'<blockquote>'
		,'</blockquote>'
		,'q'
	)
);

edButtons.push(
	new edButton(
		'ed_del'
		,'del'
		,'<del>'
		,'</del>'
	)
);

edButtons.push(
	new edButton(
		'ed_code'
		,'code'
		,'<code>'
		,'</code>'
		,'c'
	)
);

edButtons.push(
	new edButton(
		'ed_more'
		,'more'
		,'\n<!--more-->\n'
		,''
		,''
	)
);

edButtons.push(
	new edButton(
		'ed_typocode'
		,'typo:code'
		,''
		,'\n</typo:code>\n\n'
		,'typo:code'
	)
);

var extendedStart = edButtons.length;

function edLink(display, URL, newWin) {
	this.display = display;
	this.URL = URL;
	if (!newWin) {
		newWin = 0;
	}
	this.newWin = newWin;
}


edLinks[edLinks.length] = new edLink('alexking.org'
                                    ,'http://www.alexking.org/'
                                    );

function edShowButton(which, button, i) {
	if (button.access) {
		var accesskey = ' accesskey = "' + button.access + '"'
	}
	else {
		var accesskey = '';
	}
	switch (button.id) {
		case 'ed_img':
			document.write('<input type="button" id="' + button.id + '_' + which + '" ' + accesskey + ' class="btn  ' + button.id + '" onclick="edInsertImage(\'' + which + '\');" value="' + button.display + '" />');
			break;
		case 'ed_link':
			document.write('<input type="button" id="' + button.id + '_' + which + '" ' + accesskey + ' class="btn ' + button.id + '" onclick="edInsertLink(\'' + which + '\', ' + i + ');" value="' + button.display + '" />');
			break;
		case 'ed_typocode':
			document.write('<input type="button" id="' + button.id + '_' + which + '" ' + accesskey + ' class="btn ' + button.id + '" onclick="edInsertTypoCode(\'' + which + '\', ' + i + ');" value="' + button.display + '" />');
			break;
		default:
			document.write('<input type="button" id="' + button.id + '_' + which + '" ' + accesskey + ' class="btn ' + button.id + '" onclick="edInsertTag(\'' + which + '\', ' + i + ');" value="' + button.display + '"  />');
			break;
	}
}

function edShowLinks() {
	var tempStr = '<select onchange="edQuickLink(this.options[this.selectedIndex].value, this);"><option value="-1" selected>(Quick Links)</option>';
	for (i = 0; i < edLinks.length; i++) {
		tempStr += '<option value="' + i + '">' + edLinks[i].display + '</option>';
	}
	tempStr += '</select>';
	document.write(tempStr);
}

function edAddTag(which, button) {
	if (edButtons[button].tagEnd != '') {
		edOpenTags[which][edOpenTags[which].length] = button;
		document.getElementById(edButtons[button].id + '_' + which).value = '/' + document.getElementById(edButtons[button].id + '_' + which).value;
	}
}

function edRemoveTag(which, button) {
	for (i = 0; i < edOpenTags[which].length; i++) {
		if (edOpenTags[which][i] == button) {
			edOpenTags[which].splice(i, 1);
			document.getElementById(edButtons[button].id + '_' + which).value = document.getElementById(edButtons[button].id + '_' + which).value.replace('/', '');
		}
	}
}

function edCheckOpenTags(which, button) {
	var tag = 0;
	for (i = 0; i < edOpenTags[which].length; i++) {
		if (edOpenTags[which][i] == button) {
			tag++;
		}
	}
	if (tag > 0) {
		return true; // tag found
	}
	else {
		return false; // tag not found
	}
}

function edCloseAllTags(which) {
	var count = edOpenTags[which].length;
	for (o = 0; o < count; o++) {
		edInsertTag(which, edOpenTags[which][edOpenTags[which].length - 1]);
	}
}

function edQuickLink(i, thisSelect) {
	if (i > -1) {
		var newWin = '';
		if (edLinks[i].newWin == 1) {
			newWin = ' target="_blank"';
		}
		var tempStr = '<a href="' + edLinks[i].URL + '"' + newWin + '>'
		            + edLinks[i].display
		            + '</a>';
		thisSelect.selectedIndex = 0;
		edInsertContent(edCanvas, tempStr);
	}
	else {
		thisSelect.selectedIndex = 0;
	}
}

function edSpell(which) {
    myField = document.getElementById(which);
	var word = '';
	if (document.selection) {
		myField.focus();
	    var sel = document.selection.createRange();
		if (sel.text.length > 0) {
			word = sel.text;
		}
	}
	else if (myField.selectionStart || myField.selectionStart == '0') {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		if (startPos != endPos) {
			word = myField.value.substring(startPos, endPos);
		}
	}
	if (word == '') {
		word = prompt('Enter a word to look up:', '');
	}
	if (word != '') {
		window.open(dictionaryUrl + escape(word));
	}
}

function edToolbar(which) {
	document.write('<div id="ed_toolbar_' + which + '" class="btn-toolbar"><div class="btn-group">');
	for (i = 0; i < extendedStart; i++) {
		edShowButton(which, edButtons[i], i);
	}
	if (edShowExtraCookie()) {
		document.write(
			'<input type="button" id="ed_close_' + which + '" class="btn" onclick="edCloseAllTags(\'' + which + '\');" value="Close Tags" />'
			+ '<input type="button" id="ed_spell_' + which + '" class="btn" onclick="edSpell(\'' + which + '\');" value="Dict" />'
		);
	}
	else {
		document.write(
			'<input type="button" id="ed_close_' + which + '" class="btn" onclick="edCloseAllTags(\'' + which + '\');" value="Close Tags" />'
			+ '<input type="button" id="ed_spell_' + which + '" class="btn" onclick="edSpell(\'' + which + '\');" value="Dict" />'
		);
	}
	for (i = extendedStart; i < edButtons.length; i++) {
		edShowButton(which, edButtons[i], i);
	}
//	edShowLinks();
	document.write('</div></div>');
    edOpenTags[which] = new Array();
}

// insertion code

function edInsertTag(which, i) {
    myField = document.getElementById(which);
	//IE support
	if (document.selection) {
		myField.focus();
	    sel = document.selection.createRange();
		if (sel.text.length > 0) {
			sel.text = edButtons[i].tagStart + sel.text + edButtons[i].tagEnd;
		}
		else {
			if (!edCheckOpenTags(which, i) || edButtons[i].tagEnd == '') {
				sel.text = edButtons[i].tagStart;
				edAddTag(which, i);
			}
			else {
				sel.text = edButtons[i].tagEnd;
				edRemoveTag(which, i);
			}
		}
		myField.focus();
	}
	//MOZILLA/NETSCAPE support
	else if (myField.selectionStart || myField.selectionStart == '0') {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		var cursorPos = endPos;
		var scrollTop = myField.scrollTop;
		if (startPos != endPos) {
			myField.value = myField.value.substring(0, startPos)
			              + edButtons[i].tagStart
			              + myField.value.substring(startPos, endPos)
			              + edButtons[i].tagEnd
			              + myField.value.substring(endPos, myField.value.length);
			cursorPos += edButtons[i].tagStart.length + edButtons[i].tagEnd.length;
		}
		else {
			if (!edCheckOpenTags(which, i) || edButtons[i].tagEnd == '') {
				myField.value = myField.value.substring(0, startPos)
				              + edButtons[i].tagStart
				              + myField.value.substring(endPos, myField.value.length);
				edAddTag(which, i);
				cursorPos = startPos + edButtons[i].tagStart.length;
			}
			else {
				myField.value = myField.value.substring(0, startPos)
				              + edButtons[i].tagEnd
				              + myField.value.substring(endPos, myField.value.length);
				edRemoveTag(which, i);
				cursorPos = startPos + edButtons[i].tagEnd.length;
			}
		}
		myField.focus();
		myField.selectionStart = cursorPos;
		myField.selectionEnd = cursorPos;
		myField.scrollTop = scrollTop;
	}
	else {
		if (!edCheckOpenTags(which, i) || edButtons[i].tagEnd == '') {
			myField.value += edButtons[i].tagStart;
			edAddTag(which, i);
		}
		else {
			myField.value += edButtons[i].tagEnd;
			edRemoveTag(which, i);
		}
		myField.focus();
	}
}

function edInsertContent(which, myValue) {
    myField = document.getElementById(which);
	//IE support
	if (document.selection) {
		myField.focus();
		sel = document.selection.createRange();
		sel.text = myValue;
		myField.focus();
	}
	//MOZILLA/NETSCAPE support
	else if (myField.selectionStart || myField.selectionStart == '0') {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		var scrollTop = myField.scrollTop;
		myField.value = myField.value.substring(0, startPos)
		              + myValue
                      + myField.value.substring(endPos, myField.value.length);
		myField.focus();
		myField.selectionStart = startPos + myValue.length;
		myField.selectionEnd = startPos + myValue.length;
		myField.scrollTop = scrollTop;
	} else {
		myField.value += myValue;
		myField.focus();
	}
}

function edInsertLink(which, i, defaultValue) {
    myField = document.getElementById(which);
	if (!defaultValue) {
		defaultValue = 'http://';
	}
	if (!edCheckOpenTags(which, i)) {
		var URL = prompt('Enter the URL' ,defaultValue);
		if (URL) {
			edButtons[i].tagStart = '<a href="' + URL + '">';
			edInsertTag(which, i);
		}
	}
	else {
		edInsertTag(which, i);
	}
}

function edInsertTypoCode(which, i, defaultValue) {
    myField = document.getElementById(which);
	if (!defaultValue) {
		defaultValue = '';
	}
	if (!edCheckOpenTags(which, i)) {
		var code = prompt('Choose language' ,defaultValue);
		if (code) {
			edButtons[i].tagStart = '<typo:code lang="' + code + '">\n';
			edInsertTag(which, i);
		}
	}
	else {
		edInsertTag(which, i);
	}
}


function edInsertImage(which) {
    myField = document.getElementById(which);
	var myValue = prompt('Enter the URL of the image', 'http://');
	if (myValue && myValue.length > 0) {
		myValue = '<img src="'
				+ myValue
				+ '" alt="' + prompt('Enter a description of the image', '')
				+ '" />';
		edInsertContent(which, myValue);
	}
}

function edInsertImageFromCarousel(which, image) {
    myField = document.getElementById(which);
	if (image) {
		myValue = '<img src="'
				+ image
				+ '" alt="' + prompt('Enter a description of the image', '')
				+ '" />';
		edInsertContent(which, myValue);
	}
}

function countInstances(string, substr) {
	var count = string.split(substr);
	return count.length - 1;
}

function edInsertVia(which) {
    myField = document.getElementById(which);
	var myValue = prompt('Enter the URL of the source link', 'http://');
	if (myValue) {
		myValue = '(Thanks <a href="' + myValue + '" rel="external">'
				+ prompt('Enter the name of the source', '')
				+ '</a>)';
		edInsertContent(which, myValue);
	}
}


function edSetCookie(name, value, expires, path, domain) {
	document.cookie= name + "=" + escape(value) +
		((expires) ? "; expires=" + expires.toGMTString() : "") +
		((path) ? "; path=" + path : "") +
		((domain) ? "; domain=" + domain : "");
}

function edShowExtraCookie() {
	var cookies = document.cookie.split(';');
	for (var i=0;i < cookies.length; i++) {
		var cookieData = cookies[i];
		while (cookieData.charAt(0) ==' ') {
			cookieData = cookieData.substring(1, cookieData.length);
		}
		if (cookieData.indexOf('js_quicktags_extra') == 0) {
			if (cookieData.substring(19, cookieData.length) == 'show') {
				return true;
			}
			else {
				return false;
			}
		}
	}
	return false;
}
