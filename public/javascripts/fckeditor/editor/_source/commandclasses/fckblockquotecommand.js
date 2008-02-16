/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2007 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * FCKBlockQuoteCommand Class: adds or removes blockquote tags.
 */

var FCKBlockQuoteCommand = function()
{
}

FCKBlockQuoteCommand.prototype = 
{
	Execute : function()
	{
		FCKUndo.SaveUndoStep() ;

		var state = this.GetState() ;
		var range = new FCKDomRange( FCK.EditorWindow ) ;
		range.MoveToSelection() ;
		var bookmark = range.CreateBookmark() ;
		var iterator = new FCKDomRangeIterator( range ) ;
		var block ;

		if ( state == FCK_TRISTATE_OFF )
		{
			iterator.EnforceRealBlocks = true ;
			var paragraphs = [] ;
			while ( ( block = iterator.GetNextParagraph() ) )
				paragraphs.push( block ) ;

			// Make sure all paragraphs have the same parent.
			var commonParent = paragraphs[0].parentNode ;
			var tmp = [] ;
			for ( var i = 0 ; i < paragraphs.length ; i++ )
			{
				block = paragraphs[i] ;
				commonParent = FCKDomTools.GetCommonParents( block.parentNode, commonParent ).pop() ;
			}
			var lastBlock = null ;
			while ( paragraphs.length > 0 )
			{
				block = paragraphs.shift() ;
				while ( block.parentNode != commonParent )
					block = block.parentNode ;
				if ( block != lastBlock )
					tmp.push( block ) ;
				lastBlock = block ;
			}

			// If any of the selected blocks is a blockquote, remove it to prevent nested blockquotes.
			while ( tmp.length > 0 )
			{
				block = tmp.shift() ;
				if ( block.nodeName.IEquals( 'blockquote' ) )
				{
					var docFrag = block.ownerDocument.createDocumentFragment() ;
					while ( block.firstChild )
					{
						docFrag.appendChild( block.removeChild( block.firstChild ) ) ;
						paragraphs.push( docFrag.lastChild ) ;
					}
					block.parentNode.replaceChild( docFrag, block ) ;
				}
				else
					paragraphs.push( block ) ;
			}

			// Now we have all the blocks to be included in a new blockquote node.
			var bqBlock = range.Window.document.createElement( 'blockquote' ) ;
			commonParent.insertBefore( bqBlock, paragraphs[0] ) ;
			while ( paragraphs.length > 0 )
			{
				block = paragraphs.shift() ;
				bqBlock.appendChild( block ) ;
			}
		}
		else if ( state == FCK_TRISTATE_ON )
		{
			var moveOutNodes = [] ;
			while ( ( block = iterator.GetNextParagraph() ) )
			{
				var bqParent = null ;
				var bqChild = null ;
				while ( block.parentNode )
				{
					if ( block.parentNode.nodeName.IEquals( 'blockquote' ) )
					{
						bqParent = block.parentNode ;
						bqChild = block ;
						break ;
					}
					block = block.parentNode ;
				}

				if ( bqParent && bqChild )
					moveOutNodes.push( bqChild ) ;
			}

			var movedNodes = [] ;
			while ( moveOutNodes.length > 0 )
			{
				var node = moveOutNodes.shift() ;
				var bqBlock = node.parentNode ;

				// If the node is located at the beginning or the end, just take it out without splitting.
				// Otherwise, split the blockquote node and move the paragraph in between the two blockquote nodes.
				if ( node == node.parentNode.firstChild )
				{
					bqBlock.parentNode.insertBefore( bqBlock.removeChild( node ), bqBlock ) ;
					if ( ! bqBlock.firstChild )
						bqBlock.parentNode.removeChild( bqBlock ) ;
				}
				else if ( node == node.parentNode.lastChild )
				{
					bqBlock.parentNode.insertBefore( bqBlock.removeChild( node ), bqBlock.nextSibling ) ;
					if ( ! bqBlock.firstChild )
						bqBlock.parentNode.removeChild( bqBlock ) ;
				}
				else
					FCKDomTools.BreakParent( node, node.parentNode, range ) ;

				movedNodes.push( node ) ;
			}

			if ( FCKConfig.EnterMode.IEquals( 'br' ) )
			{
				while ( movedNodes.length )
				{
					var node = movedNodes.shift() ;
					var firstTime = true ;
					if ( node.nodeName.IEquals( 'div' ) )
					{
						var docFrag = node.ownerDocument.createDocumentFragment() ;
						var needBeginBr = firstTime && node.previousSibling && 
							!FCKListsLib.BlockBoundaries[node.previousSibling.nodeName.toLowerCase()] ;
						if ( firstTime && needBeginBr )
							docFrag.appendChild( node.ownerDocument.createElement( 'br' ) ) ;
						var needEndBr = node.nextSibling && 
							!FCKListsLib.BlockBoundaries[node.nextSibling.nodeName.toLowerCase()] ;
						while ( node.firstChild )
							docFrag.appendChild( node.removeChild( node.firstChild ) ) ;
						if ( needEndBr )
							docFrag.appendChild( node.ownerDocument.createElement( 'br' ) ) ;
						node.parentNode.replaceChild( docFrag, node ) ;
						firstTime = false ;
					}
				}
			}
		}
		range.MoveToBookmark( bookmark ) ;
		range.Select() ;

		FCK.Focus() ;
		FCK.Events.FireEvent( 'OnSelectionChange' ) ;
	},

	GetState : function()
	{
		// Disabled if not WYSIWYG.
		if ( FCK.EditMode != FCK_EDITMODE_WYSIWYG || ! FCK.EditorWindow )
			return FCK_TRISTATE_DISABLED ;

		var path = new FCKElementPath( FCKSelection.GetBoundaryParentElement( true ) ) ;
		var firstBlock = path.Block || path.BlockLimit ;

		if ( !firstBlock || firstBlock.nodeName.toLowerCase() == 'body' )
			return FCK_TRISTATE_OFF ;

		// See if the first block has a blockquote parent.
		for ( var i = 0 ; i < path.Elements.length ; i++ )
		{
			if ( path.Elements[i].nodeName.IEquals( 'blockquote' ) )
				return FCK_TRISTATE_ON ;
		}
		return FCK_TRISTATE_OFF ;
	}
} ;
