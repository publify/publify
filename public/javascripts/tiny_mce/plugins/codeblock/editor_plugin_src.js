/**
 * Codeblock plugin
 *
 * Some code is based on the Heading plugin by Andrey G and ggoodd.
 * Base code stolen from Bit Santos blockquote plugin.
 *
 * @author Blake Watters
 * @copyright Copyright © 2006, Blake Watters, All rights reserved.
 */
 
tinyMCE.importPluginLanguagePack('codeblock', 'en');
var TinyMCE_CodeblockPlugin = {

    getInfo : function() {
        return {
            longname :  'Codeblock plugin',
            author :    'Blake Watters',
            authorurl : 'http://thatswhatimtalkingabout.org/',
            infourl :   'mailto:blake@near-time.com',
            version :   '0.1'
        };
    },

    initInstance : function(inst) {
        inst.addShortcut('alt', '|', 'lang_codeblock_desc', 'mceCodeblock', false, 1);
    },

    getControlHTML : function(cn) {
        switch (cn) {
            case "codeblock": return tinyMCE.getButtonHTML(cn, 'lang_codeblock_desc', '{$pluginurl}/images/code.gif', 'mceCodeblock', false, 1);
        }

        return '';
    },


    execCommand : function(editor_id, element, command, user_interface, value) {
        switch (command) {
            case "mceCodeblock": {
								//debugger;
                var currentNode = tinyMCE.selectedElement;

                // alert("Selected node: " + currentNode.nodeName.toLowerCase());
                
                var n = currentNode;
                while(n.nodeName.toLowerCase() != 'body') {
                    if(n.nodeName.toLowerCase() == 'pre') {
                        break;
                    }
                    n = n.parentNode;
                }
                
                if(n.nodeName.toLowerCase() != 'body') {
                    if(currentNode == n) {
                        //alert("I am a codeblock.");
                        onlyChild = (currentNode.childNodes.length == 1);
                    
                        tinyMCE.execInstanceCommand(editor_id, 'mceRemoveNode', false);
                        
                        if(onlyChild){
														tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<pre>");
														tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<code>");
												}
                    }else {
                        //alert("My parent is a codeblock.");
                    
                        var codeblock = n;
                        var parent = codeblock.parentNode;

                        for(var i = 0; i < codeblock.childNodes.length; i++) {
                            // alert("Child #" + i + ": " + codeblock.childNodes[i].nodeName);
                            parent.insertBefore(codeblock.childNodes[i].cloneNode(true), codeblock);
                        }
                        parent.removeChild(codeblock);
                    }
                }else {
                    tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<code>");
										tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<pre>");
                }

                return true;
            }
        }
        return false;
    },


    handleNodeChange : function(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
        if (node == null)
            return;

        tinyMCE.switchClass(editor_id + '_codeblock', tinyMCE.getParentElement(node, "pre") ? 'mceButtonSelected' : 'mceButtonNormal');

        return true;
    }
};

tinyMCE.addPlugin("codeblock", TinyMCE_CodeblockPlugin);
