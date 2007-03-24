/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('ntattachlink', 'en,tr,de,sv,zh_cn,cs,fa,fr_ca,fr,pl,pt_br,nl,he,nb,ru,ru_KOI8-R,ru_UTF-8,nn,cy,es,is,zh_tw,zh_tw_utf8,sk,da');

var TinyMCE_NTAttachLinkPlugin = {
	getInfo : function() {
		return {
			longname : 'Near-Time Attach Linker',
			author : 'Blake Watters',
			authorurl : 'http://thatswhatimtalkingabout.org/',
			infourl : 'http://www.near-time.net/',
			version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
		};
	},

	getControlHTML : function(cn) {
		switch (cn) {
			case "ntattachlink":
				return tinyMCE.getButtonHTML(cn, 'lang_attach_desc', '{$themeurl}/images/attach.gif', 'mceNearTimeAttachLink');
		}

		return "";
	},

	execCommand : function(editor_id, element, command, user_interface, value) {
		switch (command) {
			case "mceNearTimeAttachLink":
				Element.hide('formatbar_image');				
				Element.hide('formatbar_link');
				Element.toggleWithHighlight('formatbar_attach');
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
			tinyMCE.switchClass(editor_id + '_Attachlinker', 'mceButtonNormal');
			return true;
		}

		tinyMCE.switchClass(editor_id + '_Attachlinker', 'mceButtonDisabled');

		return true;
	}
};

tinyMCE.addPlugin("ntattachlink", TinyMCE_NTAttachLinkPlugin);
