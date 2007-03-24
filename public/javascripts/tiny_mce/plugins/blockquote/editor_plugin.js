/**
 * Blockquote plugin
 *
 * Some code is based on the Heading plugin by Andrey G and ggoodd.
 *
 * @author Bit Santos
 * @copyright Copyright © 2006, Bit Santos, All rights reserved.
 */
 
tinyMCE.importPluginLanguagePack('blockquote', 'en');
var TinyMCE_BlockquotePlugin = {

    getInfo : function() {
        return {
            longname :  'Blockquote plugin',
            author :    'Bit Santos',
            authorurl : 'http://bitdesigns.net/',
            infourl :   'mailto:bit@bitdesigns.net',
            version :   '0.2'
        };
    },

    initInstance : function(inst) {
        inst.addShortcut('alt', 'q', 'lang_blockquote_desc', 'mceBlockquote', false, 1);
    },

    getControlHTML : function(cn) {
        switch (cn) {
            case "blockquote": return tinyMCE.getButtonHTML(cn, 'lang_blockquote_desc', '{$pluginurl}/images/quote.gif', 'mceBlockquote', false, 1);
        }

        return '';
    },


    execCommand : function(editor_id, element, command, user_interface, value) {
        switch (command) {
            case "mceBlockquote": {
                var ct = tinyMCE.getParam("blockquote_clear_tag", false) ? tinyMCE.getParam("blockquote_clear_tag","") : "p";

                var currentNode = tinyMCE.selectedElement;

                // alert("Selected node: " + currentNode.nodeName.toLowerCase());
                
                var n = currentNode;
                while(n.nodeName.toLowerCase() != 'body') {
                    if(n.nodeName.toLowerCase() == 'blockquote') {
                        break;
                    }
                    n = n.parentNode;
                }
                
                if(n.nodeName.toLowerCase() != 'body') {
                    if(currentNode == n) {
                        //alert("I am a blockquote.");
                        onlyChild = (currentNode.childNodes.length == 1);
                    
                        tinyMCE.execInstanceCommand(editor_id, 'mceRemoveNode', false);
                        
                        if(onlyChild)
                            tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<"+ct+">");
                    }else {
                        //alert("My parent is a blockquote.");
                    
                        var blockquote = n;
                        var parent = blockquote.parentNode;

                        for(var i = 0; i < blockquote.childNodes.length; i++) {
                            // alert("Child #" + i + ": " + blockquote.childNodes[i].nodeName);
                            parent.insertBefore(blockquote.childNodes[i].cloneNode(true), blockquote);
                        }
                        parent.removeChild(blockquote);
                    }
                }else {
                    tinyMCE.execInstanceCommand(editor_id, 'FormatBlock', false, "<blockquote>");
                }

                return true;
            }
        }
        return false;
    },


    handleNodeChange : function(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
        if (node == null)
            return;

        tinyMCE.switchClass(editor_id + '_blockquote', tinyMCE.getParentElement(node, "blockquote") ? 'mceButtonSelected' : 'mceButtonNormal');

        return true;
    }
};

tinyMCE.addPlugin("blockquote", TinyMCE_BlockquotePlugin);
