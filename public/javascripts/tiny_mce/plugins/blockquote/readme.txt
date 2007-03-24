Blockquote Plugin
============================================================

This adds a blockquote button to tinyMCE.
Developed by Bit Santos <bit@bitdesigns.net>

Instead of using the indent/outdent buttons to insert
content into blockquote tags, IMHO, it's a much better idea
to have a dedicated button for it.

Click it once, and it adds the selected block/s of content
into a blockquote tag. Click it again and the selected
block/s are removed from the blockquote tag.



Version History
------------------------------------------------------------

0.2
    - Can apply blockquote tags to multiple block-level
      elements.
    - Will apply the paragraph tag when the blockquote tag
      is removed and the remaining content doesn't have a
      parent block-level element.
    - Much better support for nested tags.

0.1 (not released)
    - Apply blockquote tags to content, one block-level
      element at a time.
    - Could not properly handle content nested tags, including
      lists.
      
      
      
Plugin-specific Parameters
------------------------------------------------------------

blockquote_clear_tag :
    (optional) the HTML tag to be applied when the
    blockquote tag is removed and the remaining content does
    not have a block-level parent. Defaults to 'p'.



Installation
------------------------------------------------------------

1. Copy the blockquote directory to the tinyMCE plugins
   directory.
2. Add 'blockquote' to the plugin list.
3. Add 'blockquote' to the button list.

      
      
Sample initialization
------------------------------------------------------------

tinyMCE.init({
    theme : "advanced",
    mode : "textareas",
    plugins : "blockquote",
    blockquote_clear_tag : "p",
    theme_advanced_buttons1_add : "blockquote",
});
