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
 * Controls the [Enter] keystroke behavior in a document.
 */

/*
 *	Constructor.
 *		@targetDocument : the target document.
 *		@enterMode : the behavior for the <Enter> keystroke.
 *			May be "p", "div", "br". Default is "p".
 *		@shiftEnterMode : the behavior for the <Shift>+<Enter> keystroke.
 *			May be "p", "div", "br". Defaults to "br".
 */
var FCKEnterKey = function( targetWindow, enterMode, shiftEnterMode, tabSpaces )
{
	this.Window			= targetWindow ;
	this.EnterMode		= enterMode || 'p' ;
	this.ShiftEnterMode	= shiftEnterMode || 'br' ;

	// Setup the Keystroke Handler.
	var oKeystrokeHandler = new FCKKeystrokeHandler( false ) ;
	oKeystrokeHandler._EnterKey = this ;
	oKeystrokeHandler.OnKeystroke = FCKEnterKey_OnKeystroke ;

	oKeystrokeHandler.SetKeystrokes( [
		[ 13		, 'Enter' ],
		[ SHIFT + 13, 'ShiftEnter' ],
		[ 9 		, 'Tab' ],
		[ 8			, 'Backspace' ],
		[ CTRL + 8		, 'CtrlBackspace' ],
		[ 46		, 'Delete' ]
	] ) ;

	if ( tabSpaces > 0 )
	{
		this.TabText = '' ;
		while ( tabSpaces-- > 0 )
			this.TabText += '\xa0' ;
	}

	oKeystrokeHandler.AttachToElement( targetWindow.document ) ;
}


function FCKEnterKey_OnKeystroke(  keyCombination, keystrokeValue )
{
	var oEnterKey = this._EnterKey ;

	try
	{
		switch ( keystrokeValue )
		{
			case 'Enter' :
				return oEnterKey.DoEnter() ;
				break ;
			case 'ShiftEnter' :
				return oEnterKey.DoShiftEnter() ;
				break ;
			case 'Backspace' :
				return oEnterKey.DoBackspace() ;
				break ;
			case 'Delete' :
				return oEnterKey.DoDelete() ;
				break ;
			case 'Tab' :
				return oEnterKey.DoTab() ;
				break ;
			case 'CtrlBackspace' :
				return oEnterKey.DoCtrlBackspace() ;
				break ;
		}
	}
	catch (e)
	{
		// If for any reason we are not able to handle it, go
		// ahead with the browser default behavior.
	}

	return false ;
}

/*
 * Executes the <Enter> key behavior.
 */
FCKEnterKey.prototype.DoEnter = function( mode, hasShift )
{
	// Save an undo snapshot before doing anything
	FCKUndo.SaveUndoStep() ;

	this._HasShift = ( hasShift === true ) ;

	var parentElement = FCKSelection.GetParentElement() ;
	var parentPath = new FCKElementPath( parentElement ) ;
	var sMode = mode || this.EnterMode ;
	
	if ( sMode == 'br' || parentPath.Block && parentPath.Block.tagName.toLowerCase() == 'pre' )
		return this._ExecuteEnterBr() ;
	else
		return this._ExecuteEnterBlock( sMode ) ;
}

/*
 * Executes the <Shift>+<Enter> key behavior.
 */
FCKEnterKey.prototype.DoShiftEnter = function()
{
	return this.DoEnter( this.ShiftEnterMode, true ) ;
}

/*
 * Executes the <Backspace> key behavior.
 */
FCKEnterKey.prototype.DoBackspace = function()
{
	var bCustom = false ;

	// Get the current selection.
	var oRange = new FCKDomRange( this.Window ) ;
	oRange.MoveToSelection() ;

	// Kludge for #247
	if ( FCKBrowserInfo.IsIE && this._CheckIsAllContentsIncluded( oRange, this.Window.document.body ) )
	{
		this._FixIESelectAllBug( oRange ) ;
		return true ;
	}

	var isCollapsed = oRange.CheckIsCollapsed() ;

	if ( !isCollapsed )
	{
		// Bug #327, Backspace with an img selection would activate the default action in IE.
		// Let's override that with our logic here.
		if ( FCKBrowserInfo.IsIE && this.Window.document.selection.type.toLowerCase() == "control" )
		{
			var controls = this.Window.document.selection.createRange() ;
			for ( var i = controls.length - 1 ; i >= 0 ; i-- )
			{
				var el = controls.item( i ) ;
				el.parentNode.removeChild( el ) ;
			}
			return true ;
		}

		return false ;
	}

	var oStartBlock = oRange.StartBlock ;
	var oEndBlock = oRange.EndBlock ;

	// The selection boundaries must be in the same "block limit" element
	if ( oRange.StartBlockLimit == oRange.EndBlockLimit && oStartBlock && oEndBlock )
	{
		if ( !isCollapsed )
		{
			var bEndOfBlock = oRange.CheckEndOfBlock() ;

			oRange.DeleteContents() ;

			if ( oStartBlock != oEndBlock )
			{
				oRange.SetStart(oEndBlock,1) ;
				oRange.SetEnd(oEndBlock,1) ;

//				if ( bEndOfBlock )
//					oEndBlock.parentNode.removeChild( oEndBlock ) ;
			}

			oRange.Select() ;

			bCustom = ( oStartBlock == oEndBlock ) ;
		}

		if ( oRange.CheckStartOfBlock() )
		{
			var oCurrentBlock = oRange.StartBlock ;

			var ePrevious = FCKDomTools.GetPreviousSourceElement( oCurrentBlock, true, [ 'BODY', oRange.StartBlockLimit.nodeName ], ['UL','OL'] ) ;

			bCustom = this._ExecuteBackspace( oRange, ePrevious, oCurrentBlock ) ;
		}
		else if ( FCKBrowserInfo.IsGeckoLike )
		{
			// Firefox and Opera (#1095) loose the selection when executing
			// CheckStartOfBlock, so we must reselect.
			oRange.Select() ;
		}
	}

	oRange.Release() ;
	return bCustom ;
}

FCKEnterKey.prototype.DoCtrlBackspace = function()
{
	FCKUndo.SaveUndoStep() ;
	var oRange = new FCKDomRange( this.Window ) ;
	oRange.MoveToSelection() ;
	if ( FCKBrowserInfo.IsIE && this._CheckIsAllContentsIncluded( oRange, this.Window.document.body ) )
	{
		this._FixIESelectAllBug( oRange ) ;
		return true ;
	}
	return false ;
}

FCKEnterKey.prototype._ExecuteBackspace = function( range, previous, currentBlock )
{
	var bCustom = false ;

	// We could be in a nested LI.
	if ( !previous && currentBlock && currentBlock.nodeName.IEquals( 'LI' ) && currentBlock.parentNode.parentNode.nodeName.IEquals( 'LI' ) )
	{
		this._OutdentWithSelection( currentBlock, range ) ;
		return true ;
	}

	if ( previous && previous.nodeName.IEquals( 'LI' ) )
	{
		var oNestedList = FCKDomTools.GetLastChild( previous, ['UL','OL'] ) ;

		while ( oNestedList )
		{
			previous = FCKDomTools.GetLastChild( oNestedList, 'LI' ) ;
			oNestedList = FCKDomTools.GetLastChild( previous, ['UL','OL'] ) ;
		}
	}

	if ( previous && currentBlock )
	{
		// If we are in a LI, and the previous block is not an LI, we must outdent it.
		if ( currentBlock.nodeName.IEquals( 'LI' ) && !previous.nodeName.IEquals( 'LI' ) )
		{
			this._OutdentWithSelection( currentBlock, range ) ;
			return true ;
		}

		// Take a reference to the parent for post processing cleanup.
		var oCurrentParent = currentBlock.parentNode ;

		var sPreviousName = previous.nodeName.toLowerCase() ;
		if ( FCKListsLib.EmptyElements[ sPreviousName ] != null || sPreviousName == 'table' )
		{
			FCKDomTools.RemoveNode( previous ) ;
			bCustom = true ;
		}
		else
		{
			// Remove the current block.
			FCKDomTools.RemoveNode( currentBlock ) ;

			// Remove any empty tag left by the block removal.
			while ( oCurrentParent.innerHTML.Trim().length == 0 )
			{
				var oParent = oCurrentParent.parentNode ;
				oParent.removeChild( oCurrentParent ) ;
				oCurrentParent = oParent ;
			}

			// Cleanup the previous and the current elements.
			FCKDomTools.LTrimNode( currentBlock ) ;
			FCKDomTools.RTrimNode( previous ) ;

			// Append a space to the previous.
			// Maybe it is not always desirable...
			// previous.appendChild( this.Window.document.createTextNode( ' ' ) ) ;

			// Set the range to the end of the previous element and bookmark it.
			range.SetStart( previous, 2, true ) ;
			range.Collapse( true ) ;
			var oBookmark = range.CreateBookmark() ;

			// Move the contents of the block to the previous element and delete it.
			// But for some block types (e.g. table), moving the children to the previous block makes no sense.
			// So a check is needed. (See #1081)
			if ( ! currentBlock.tagName.IEquals( [ 'TABLE' ] ) )
				FCKDomTools.MoveChildren( currentBlock, previous ) ;

			// Place the selection at the bookmark.
			range.MoveToBookmark( oBookmark ) ;
			range.Select() ;

			bCustom = true ;
		}
	}

	return bCustom ;
}

/*
 * Executes the <Delete> key behavior.
 */
FCKEnterKey.prototype.DoDelete = function()
{
	// Save an undo snapshot before doing anything
	// This is to conform with the behavior seen in MS Word
	FCKUndo.SaveUndoStep() ;

	// The <Delete> has the same effect as the <Backspace>, so we have the same
	// results if we just move to the next block and apply the same <Backspace> logic.

	var bCustom = false ;

	// Get the current selection.
	var oRange = new FCKDomRange( this.Window ) ;
	oRange.MoveToSelection() ;

	// Kludge for #247
	if ( FCKBrowserInfo.IsIE && this._CheckIsAllContentsIncluded( oRange, this.Window.document.body ) )
	{
		this._FixIESelectAllBug( oRange ) ;
		return true ;
	}

	// There is just one special case for collapsed selections at the end of a block.
	if ( oRange.CheckIsCollapsed() && oRange.CheckEndOfBlock( FCKBrowserInfo.IsGeckoLike ) )
	{
		var oCurrentBlock = oRange.StartBlock ;
		var eCurrentCell = FCKTools.GetElementAscensor( oCurrentBlock, 'td' );

		var eNext = FCKDomTools.GetNextSourceElement( oCurrentBlock, true, [ oRange.StartBlockLimit.nodeName ], 
				['UL','OL','TR'] ) ;

		// Bug #1323 : if we're in a table cell, and the next node belongs to a different cell, then don't
		// delete anything.
		if ( eCurrentCell )
		{
			var eNextCell = FCKTools.GetElementAscensor( eNext, 'td' );
			if ( eNextCell != eCurrentCell )
				return true ;
		}

		bCustom = this._ExecuteBackspace( oRange, oCurrentBlock, eNext ) ;
	}

	oRange.Release() ;
	return bCustom ;
}

/*
 * Executes the <Tab> key behavior.
 */
FCKEnterKey.prototype.DoTab = function()
{
	var oRange = new FCKDomRange( this.Window );
	oRange.MoveToSelection() ;

	// If the user pressed <tab> inside a table, we should give him the default behavior ( moving between cells )
	// instead of giving him more non-breaking spaces. (Bug #973)
	var node = oRange._Range.startContainer ;
	while ( node )
	{
		if ( node.nodeType == 1 )
		{
			var tagName = node.tagName.toLowerCase() ;
			if ( tagName == "tr" || tagName == "td" || tagName == "th" || tagName == "tbody" || tagName == "table" )
				return false ;
			else
				break ;
		}
		node = node.parentNode ;
	}

	if ( this.TabText )
	{
		oRange.DeleteContents() ;
		oRange.InsertNode( this.Window.document.createTextNode( this.TabText ) ) ;
		oRange.Collapse( false ) ;
		oRange.Select() ;
	}
	return true ;
}

FCKEnterKey.prototype._ExecuteEnterBlock = function( blockTag, range )
{
	// Get the current selection.
	var oRange = range || new FCKDomRange( this.Window ) ;

	var oSplitInfo = oRange.SplitBlock() ;
	
	if ( oSplitInfo )
	{
		// Get the current blocks.
		var ePreviousBlock	= oSplitInfo.PreviousBlock ;
		var eNextBlock		= oSplitInfo.NextBlock ;

		var bIsStartOfBlock	= oSplitInfo.WasStartOfBlock ;
		var bIsEndOfBlock	= oSplitInfo.WasEndOfBlock ;

		// If we have both the previous and next blocks, it means that the
		// boundaries were on separated blocks, or none of them where on the
		// block limits (start/end).
		if ( !oSplitInfo.WasStartOfBlock && !oSplitInfo.WasEndOfBlock )
		{
			// Move the selection to the end block.
			if ( eNextBlock )
				oRange.MoveToElementEditStart( eNextBlock ) ;
		}
		else
		{
			if ( bIsStartOfBlock && bIsEndOfBlock && ePreviousBlock.tagName.toUpperCase() == 'LI' )
			{
				oRange.MoveToElementStart( ePreviousBlock ) ;
				this._OutdentWithSelection( ePreviousBlock, oRange ) ;
				oRange.Release() ;
				return true ;
			}

			var eNewBlock ;

			if ( ePreviousBlock )
			{
				var sPreviousBlockTag = ePreviousBlock.tagName.toUpperCase() ;

				// If is a header tag, or we are in a Shift+Enter (#77),
				// create a new block element.
				if ( this._HasShift || (/^H[1-6]$/).test( sPreviousBlockTag ) )
					eNewBlock = this.Window.document.createElement( blockTag ) ;
				else
				{
					// Otherwise, duplicate the previous block.
					eNewBlock = FCKDomTools.CloneElement( ePreviousBlock ) ;

					this._RecreateEndingTree( ePreviousBlock, eNewBlock ) ;
				}
			}
			else if ( eNextBlock )
			{
				eNewBlock = FCKDomTools.CloneElement( eNextBlock ) ;
			}
			else
				eNewBlock = this.Window.document.createElement( blockTag ) ;

			if ( FCKBrowserInfo.IsGeckoLike )
				FCKTools.AppendBogusBr( eNewBlock ) ;

			oRange.InsertNode( eNewBlock ) ;

			// This is tricky, but to make the new block visible correctly
			// we must select it.
			if ( FCKBrowserInfo.IsIE )
			{
				// Move the selection to the new block.
				oRange.MoveToNodeContents( eNewBlock ) ;
				oRange.Select() ;
			}

			oRange.MoveToElementEditStart( bIsStartOfBlock && !bIsEndOfBlock ? eNextBlock : eNewBlock ) ;

			if ( FCKBrowserInfo.IsGeckoLike )
				eNewBlock.scrollIntoView( false ) ;
		}

		oRange.Select() ;
	}

	// Release the resources used by the range.
	oRange.Release() ;

	return true ;
}

FCKEnterKey.prototype._ExecuteEnterBr = function( blockTag )
{
	// Get the current selection.
	var oRange = new FCKDomRange( this.Window ) ;
	oRange.MoveToSelection() ;

	// The selection boundaries must be in the same "block limit" element.
	if ( oRange.StartBlockLimit == oRange.EndBlockLimit )
	{
		oRange.DeleteContents() ;

		// Get the new selection (it is collapsed at this point).
		oRange.MoveToSelection() ;

		var bIsStartOfBlock	= oRange.CheckStartOfBlock() ;
		var bIsEndOfBlock	= oRange.CheckEndOfBlock() ;

		var sStartBlockTag = oRange.StartBlock ? oRange.StartBlock.tagName.toUpperCase() : '' ;

		var bHasShift = this._HasShift ;

		if ( !bHasShift && sStartBlockTag == 'LI' )
			return this._ExecuteEnterBlock( null, oRange ) ;

		// If we are at the end of a header block.
		if ( !bHasShift && bIsEndOfBlock && (/^H[1-6]$/).test( sStartBlockTag ) )
		{
			// Insert a BR after the current paragraph.
			FCKDomTools.InsertAfterNode( oRange.StartBlock, this.Window.document.createElement( 'br' ) ) ;

			// The space is required by Gecko only to make the cursor blink.
			if ( FCKBrowserInfo.IsGecko )
				FCKDomTools.InsertAfterNode( oRange.StartBlock, this.Window.document.createTextNode( '' ) ) ;

			// IE and Gecko have different behaviors regarding the position.
			oRange.SetStart( oRange.StartBlock.nextSibling, FCKBrowserInfo.IsIE ? 3 : 1 ) ;
		}
		else
		{
			var eLineBreak = null ;
			if ( sStartBlockTag.IEquals( 'pre' ) )
				eLineBreak = this.Window.document.createTextNode( FCKBrowserInfo.IsIE ? '\r' : '\n' ) ;
			else
				eLineBreak = this.Window.document.createElement( 'br' ) ;

			oRange.InsertNode( eLineBreak ) ;

			// The space is required by Gecko only to make the cursor blink.
			if ( FCKBrowserInfo.IsGecko )
				FCKDomTools.InsertAfterNode( eLineBreak, this.Window.document.createTextNode( '' ) ) ;

			// If we are at the end of a block, we must be sure the bogus node is available in that block.
			if ( bIsEndOfBlock && FCKBrowserInfo.IsGeckoLike )
				FCKTools.AppendBogusBr( eLineBreak.parentNode ) ;

			if ( FCKBrowserInfo.IsIE )
				oRange.SetStart( eLineBreak, 4 ) ;
			else
				oRange.SetStart( eLineBreak.nextSibling, 1 ) ;

			if ( ! FCKBrowserInfo.IsIE )
			{
				var dummy = null ;
				if ( FCKBrowserInfo.IsOpera )
					dummy = this.Window.document.createElement( 'span' ) ;
				else
					dummy = this.Window.document.createElement( 'br' ) ;
				eLineBreak.parentNode.insertBefore( dummy, eLineBreak.nextSibling ) ;
				dummy.scrollIntoView( false ) ;
				dummy.parentNode.removeChild( dummy ) ;
			}
		}

		// This collapse guarantees the cursor will be blinking.
		oRange.Collapse( true ) ;

		oRange.Select() ;
	}

	// Release the resources used by the range.
	oRange.Release() ;

	return true ;
}

// Recreate the elements tree at the end of the source block, at the beginning
// of the target block. Eg.:
//	If source = <p><u>Some</u> sample <b><i>text</i></b></p> then target = <p><b><i></i></b></p>
//	If source = <p><u>Some</u> sample text</p> then target = <p></p>
FCKEnterKey.prototype._RecreateEndingTree = function( source, target )
{
	while ( ( source = source.lastChild ) && source.nodeType == 1 && FCKListsLib.InlineChildReqElements[ source.nodeName.toLowerCase() ] != null )
		target = target.insertBefore( FCKDomTools.CloneElement( source ), target.firstChild ) ;
}

// Outdents a LI, maintaining the selection defined on a range.
FCKEnterKey.prototype._OutdentWithSelection = function( li, range )
{
	var oBookmark = range.CreateBookmark() ;

	FCKListHandler.OutdentListItem( li ) ;

	range.MoveToBookmark( oBookmark ) ;
	range.Select() ;
}

// Is all the contents under a node included by a range?
FCKEnterKey.prototype._CheckIsAllContentsIncluded = function( range, node )
{
	var startOk = false ;
	var endOk = false ;
	
	/*
	FCKDebug.Output( 'sc='+range.StartContainer.nodeName+
			',so='+range._Range.startOffset+
			',ec='+range.EndContainer.nodeName+
			',eo='+range._Range.endOffset ) ;
	*/
	if ( range.StartContainer == node || range.StartContainer == node.firstChild )
		startOk = ( range._Range.startOffset == 0 ) ;

	if ( range.EndContainer == node || range.EndContainer == node.lastChild )
	{
		var nodeLength = range.EndContainer.nodeType == 3 ? range.EndContainer.length : range.EndContainer.childNodes.length ;
		endOk = ( range._Range.endOffset == nodeLength ) ;
	}

	return startOk && endOk ;
}

// Kludge for #247
FCKEnterKey.prototype._FixIESelectAllBug = function( range )
{
	var doc = this.Window.document ;
	doc.body.innerHTML = '' ;
	var editBlock ;
	if ( FCKConfig.EnterMode.IEquals( ['div', 'p'] ) )
	{
		editBlock = doc.createElement( FCKConfig.EnterMode ) ;
		doc.body.appendChild( editBlock ) ;
	}
	else
		editBlock = doc.body ;

	range.MoveToNodeContents( editBlock ) ;
	range.Collapse( true ) ;
	range.Select() ;
	range.Release() ;
}
