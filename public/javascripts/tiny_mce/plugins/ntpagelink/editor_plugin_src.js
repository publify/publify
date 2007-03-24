/* Import plugin specific language pack */
//tinyMCE.importPluginLanguagePack('ntpagelink', 'en,tr,de,sv,zh_cn,cs,fa,fr_ca,fr,pl,pt_br,nl,he,nb,ru,ru_KOI8-R,ru_UTF-8,nn,cy,es,is,zh_tw,zh_tw_utf8,sk,da');

var TinyMCE_NTPageLinkPlugin = {
	getInfo : function() {
		return {
			longname : 'Near-Time Page Linker',
			author : 'Blake Watters',
			authorurl : 'http://thatswhatimtalkingabout.org/',
			infourl : 'http://www.near-time.net/',
			version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
		};
	},

	getControlHTML : function(cn) {
		switch (cn) {
			case "ntpagelink":
				return tinyMCE.getButtonHTML(cn, 'lang_link_desc', '{$themeurl}/images/link.gif', 'mceNearTimePageLink');
		}

		return "";
	},

	execCommand : function(editor_id, element, command, user_interface, value) {
		switch (command) {
			case "mceNearTimePageLink":
				Element.hide('formatbar_image');
				Element.hide('formatbar_attach');
				Element.toggleWithHighlight('formatbar_link');
				// TODO - Toggle the editor into toolbar
				// $$('td.mceToolbarTop')[0].toggle();
				return true;
				
			case "mceAddControl":
				
				return true;
		}

		return false;
	},

	handleNodeChange : function(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
		if (node == null)
			return;

		do {
			if (node.nodeName == "A" && tinyMCE.getAttrib(node, 'href') != "") {
				tinyMCE.switchClass(editor_id + '_advlink', 'mceButtonSelected');
				return true;
			}
		} while ((node = node.parentNode));

		if (any_selection) {
			tinyMCE.switchClass(editor_id + '_pagelinker', 'mceButtonNormal');
			return true;
		}

		tinyMCE.switchClass(editor_id + '_pagelinker', 'mceButtonDisabled');

		return true;
	}
};

tinyMCE.addPlugin("ntpagelink", TinyMCE_NTPageLinkPlugin);
