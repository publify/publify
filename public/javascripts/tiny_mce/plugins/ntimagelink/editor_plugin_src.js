/* Import plugin specific language pack */
// tinyMCE.importPluginLanguagePack('ntimagelink', 'en,tr,de,sv,zh_cn,cs,fa,fr_ca,fr,pl,pt_br,nl,he,nb,ru,ru_KOI8-R,ru_UTF-8,nn,cy,es,is,zh_tw,zh_tw_utf8,sk,da');

var TinyMCE_NTImageLinkPlugin = {
	getInfo : function() {
		return {
			longname : 'Near-Time Image Linker',
			author : 'Blake Watters',
			authorurl : 'http://thatswhatimtalkingabout.org/',
			infourl : 'http://www.near-time.net/',
			version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
		};
	},

	getControlHTML : function(cn) {
		switch (cn) {
			case "ntimagelink":
				return tinyMCE.getButtonHTML(cn, 'lang_image_desc', '{$themeurl}/images/image.gif', 'mceNearTimeImageLink');
		}

		return "";
	},

	execCommand : function(editor_id, element, command, user_interface, value) {
		switch (command) {
			case "mceNearTimeImageLink":				
				Element.hide('formatbar_link');
				Element.hide('formatbar_attach');
				Element.toggleWithHighlight('formatbar_image');
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
			tinyMCE.switchClass(editor_id + '_Imagelinker', 'mceButtonNormal');
			return true;
		}

		tinyMCE.switchClass(editor_id + '_Imagelinker', 'mceButtonDisabled');

		return true;
	}
};

tinyMCE.addPlugin("ntimagelink", TinyMCE_NTImageLinkPlugin);
