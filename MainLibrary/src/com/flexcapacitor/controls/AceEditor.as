/**
 
  Ace Editor ActionScript 3 class

  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

 **/

/**
    The Ace Editor JavaScript class
	
    The Ace source code is released under the BSD License. This license is very simple, 
    and is friendly to all kinds of projects, whether open source or not. Take charge 
    of your editor and add your favorite language highlighting and keybindings!
   
	Copyright (c) 2010, Ajax.org B.V.
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	    * Redistributions of source code must retain the above copyright
	      notice, this list of conditions and the following disclaimer.
	    * Redistributions in binary form must reproduce the above copyright
	      notice, this list of conditions and the following disclaimer in the
	      documentation and/or other materials provided with the distribution.
	    * Neither the name of Ajax.org B.V. nor the
	      names of its contributors may be used to endorse or promote products
	      derived from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 
  ***/
package com.flexcapacitor.controls {

	import com.flexcapacitor.controls.IAceEditor;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.utils.getTimer;
	
	import mx.controls.HTML;
	import mx.events.FlexEvent;
	
	import spark.core.IDisplayText;
	import spark.events.TextOperationEvent;
	
	import flashx.textLayout.operations.FlowOperation;
	
	/**
	 *  Dispached when the editor has been created
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="editorReady", type="flash.events.Event")]
	
	/**
	 *  Dispached when the user presses CTRL + S on Win and Linux or CMD + S on Mac
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="save", type="flash.events.Event")]
	
	/**
	 *  Dispached when the user presses CTRL + F on Win or Linux or CMD + F on Mac 
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="find", type="flash.events.Event")]
	
	/**
	 *  Dispached as the mouse moves over the editor.
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="mouseMoveOverEditor", type="flash.events.Event")]
	
	/**
	 *  Dispached after the cursor changes positions.
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="cursorChange", type="flash.events.Event")]
	
	/**
	 *  Dispached after the session has changed
	 *
	 *  @eventType flash.events.Event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="sessionChange", type="flash.events.Event")]
	
	/**
	 *  Dispached after the selection anchor position and/or
	 *  selection active or lead position properties have changed
	 *  for any reason.
	 *
	 *  @eventType flash.events.Event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="selectionChange", type="flash.events.Event")]
	
	/**
	 *  Dispatched after a user editing operation is complete.
	 *
	 *  @eventType spark.events.TextOperationEvent.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="change", type="spark.events.TextOperationEvent")]
	
	
	/**
	 * Ace editor for AIR apps. You must include the source files with this component. 
	 * You need to copy the ace source code (src-min-noconflict) and ace.html page into your project.  
	 * The ace.html page is included in this library and the ace source is available at 
	 * http://ace.c9.io/ or on github.<br/><br/>
	 * 
	 * The editor automatically loads unless you set loadOnCreationComplete to false.
	 * If it is false then call initializeEditor() when you want to load the editor. <br/><br/>
	 * 
	 * Only about 3/4ths of the API is supported at this time but you have references to the 
	 * objects so you can add access additional API and events through them.<br/><br/>
	 * 
	 * Use the editor.on() method to add listeners and editor.off() to remove them. <br/><br/>
	 * 
	 * Listening and dispatching events duration: Average:4ms with debug build.<br>
	 * Not listening or dispatching events duration: Average:1ms with debug build.<br/><br/>
	 * 
	 * A "editorReady" event is dispatched when the editor is ready to use and the isEditorReady property 
	 * is set to true. 
	 * 
	 * To use in MXML:<br/>
	<pre>
	&lt;local:AceEditor id="ace" height="100%" width="100%"
			top="60" left="0" right="0" bottom="30" 
			editorReady="aceEditorReadyHandler(event)"
			selectionChange="ace_selectionChangeHandler(event)"
			cursorChange="ace_cursorChangeHandler(event)"
			mouseMoveOverEditor="ace_mouseMoveOverChangeHandler(event)"
			pathToTemplate="app:/ace.html" editorReady="trace('can access ace.editor now')"/>
			
	&lt;s:TextInput id="searchInput" prompt="Search" 
			change="searchInput_clickHandler(event)"
			enter="searchInput_clickHandler(event)"/>
	
	
	public function selectionChangeHandler(event:Object, editor:Object):void {
		var type:String = event.type; // changeSelection
		anchor = editor.anchor;
		lead = editor.lead;
	}
	
	protected function ace_cursorChangeHandler(event:Event):void {
		var cursorPositionLabel:String = ace.row + ":" + ace.column;
		var token:Object = ace.getTokenAt(ace.row, ace.column);
		var tokenLabel:String = token ? token.type : "";
	}
	
	protected function ace_mouseMoveOverEditorHandler(event:Event):void {
		var position:Object = ace.mouseMoveEvent.getDocumentPosition();
		var mousePositionLabel:String = position.row + ":" + position.column;
		var token:Object = ace.getTokenAt(position.row, position.column);
		var tokenLabel:String = token ? token.type : "";
	}
	
	protected function aceEditorReadyHandler(event:Event):void {
		ace.isEditorReady; // true when editor is ready
		ace.setMode("ace/mode/html");
		ace.setValue(myHTMLContent);
	}

	private var lastSearchValue:String;
			
	protected function searchInput_clickHandler(event:Event):void {
		var searchText:String = searchInput.text;
		
		// enter key pressed
		if (lastSearchValue==searchText) {
			lastFocusedEditor.findNext(searchText);
		}
		// change event
		else {
			var selectionAnchor:Object = aceEditor.getSelectionAnchor();
			var options:Object = {start:{row:selectionAnchor.row,column:selectionAnchor.column}};
			var result:Object = aceEditor.find(searchInput.text, options);
		}
		
		lastSearchValue = searchText;
	}
	
	protected function searchInput_changeHandler(event:Event):void {
		var searchText:String = searchInput.text;
		
		// enter key pressed
		if (lastSearchValue==searchText) {
			
			if (searchText!="") {
				if (!shiftDown) {
					lastFocusedEditor.findNext(null);
				}
				else {
					lastFocusedEditor.findPrevious(null);
				}
			}
		}
		
		// change event
		else {
			var options:Object = {};
			options.skipCurrent = false;
			var result:Object = lastFocusedEditor.find(searchInput.text, options);
		}
		
		lastSearchValue = searchText;
	}
	</pre>
	 * 
	 * Ace Editor Website - http://ace.c9.io/<br>
	 * Ace Editor Source Code - https://github.com/ajaxorg/ace/blob/master/lib/ace/editor.js<br>
	 * 
	 * @see https://github.com/ajaxorg/ace/blob/master/lib/ace/editor.js
	 * @see http://ace.c9.io/#nav=howto
	 * */	
	public class AceEditor extends HTML implements IAceEditor, IDisplayText {
		
		public function AceEditor() {
			super();
			
			//htmlText = "<h1>loading</h1>";
			
			
			addEventListener(FlexEvent.INITIALIZE, initializedHandler);
			addEventListener(Event.COMPLETE, completeHandler);
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		protected function creationCompleteHandler(event:FlexEvent):void
		{
			//trace("creationComplete");
		}
		
		public function initializedHandler(event:Event):void {
			//trace("initialized");
			if (loadOnCreationComplete) {
				location = pathToTemplate;
			}
		}
		
		public var loadOnCreationComplete:Boolean = true;
		
		public static const INSERT_ACTION:String = "insert";
		public static const INSERT_TEXT_ACTION:String = "insertText";
		public static const INSERT_LINES_ACTION:String = "insertLines";
		public static const REMOVE_LINES_ACTION:String = "removeLines";
		
		public static const SESSION_CHANGE:String = "sessionChange";
		public static const SELECTION_CHANGE:String = "selectionChange";
		public static const CURSOR_CHANGE:String = "cursorChange";
		public static const MOUSE_MOVE_OVER_EDITOR:String = "mouseMoveOverEditor";
		public static const FIND:String = "find";
		
		public static const EDITOR_READY:String = "editorReady";
		public static const EDITOR_CHANGE:String = "change";
		public static const SAVE:String = "save";
		
		// ACE uses event names such as changeSession instead of sessionChange
		// this is different than ActionScript3 conventions which is sessionChange
		private static const SESSION_CHANGE_SESSION:String = "changeSession";
		private static const SESSION_CHANGE_SELECTION:String = "changeSelection";
		private static const SESSION_CHANGE_CURSOR:String = "changeCursor";
		private static const SESSION_MOUSE_MOVE:String = "mousemove";
		
		private var callBackAdded:Boolean;
		
		/**
		 * Path to HTML page that has the Ace editor in it 
		 * */
		public var pathToTemplate:String = "app:/ace.html";
		
		/**
		 * Reference to the HTML document
		 * */
		public var pageDocument:Object;
		
		/**
		 * Reference to the HTML document
		 * */
		public var pagePlugins:Object;
		
		/**
		 * Reference to the HTML document
		 * */
		public var pageScripts:Object;
		
		/**
		 * Reference to the ace editor instance
		 * */
		public var editor:Object;
		
		/**
		 * Reference to the ace editor container element instance
		 * */
		public var element:Object;
		
		/**
		 * Reference to the ace session instance. 
		 * Not sure if this changes throughout the life of the editor. 
		 * */
		public var session:Object;
		
		/**
		 * Reference to the ace selection instance
		 * Not sure if this changes throughout the life of the editor. 
		 * */
		public var selection:Object;
		
		/**
		 * Reference to the ace editor manager
		 * */
		public var aceManager:Object;
		
		/**
		 * Reference to the page stylesheets
		 * */
		public var pageStyleSheets:Object;
		
		/**
		 * Reference to the ace language tools
		 * */
		public var languageTools:Object;
		
		/**
		 * Reference to the ace beautify extension
		 * */
		public var beautify:Object;
		
		/**
		 * Identity of editor on the page. <br/><br/>
		 * 
		 * You should have a div on your page with an identity like this:
		 <pre>
		 &lt;div id='editor'>&lt;/div>
		 </pre>
		 * */
		public var editorIdentity:String = "editor";
		
		private var _theme:String = "ace/theme/crimson_editor";
		
		/**
		 * Theme of the editor as a path to the theme files.
		 * Default is "ace/theme/crimson_editor"
		 * */
		public function get theme():String {
			return _theme;
		}
		
		/**
		 * @private
		 */
		public function set theme(value:String):void {
			if (_theme!=value) themeChanged = true;
			_theme = value;
			invalidateProperties();
		}
		
		private var _showInvisibles:Boolean;
		
		public function get showInvisibles():Boolean {
			return _showInvisibles;
		}
		
		public function set showInvisibles(value:Boolean):void {
			if (_showInvisibles!=value) showInvisiblesChanged = true;
			_showInvisibles = value;
			invalidateProperties();
		}
		
		private var _enableBehaviors:Boolean;
		
		public function get enableBehaviors():Boolean {
			return _enableBehaviors;
		}
		
		/**
		 * Specifies whether to use behaviors or not. 
		 * "Behaviors" in this case is the auto-pairing of special characters, 
		 * like quotation marks, parenthesis, or brackets.
		 * */
		public function set enableBehaviors(value:Boolean):void {
			if (_enableBehaviors!=value) enableBehaviorsChanged = true;
			_enableBehaviors = value;
			invalidateProperties();
		}
		
		
		public var _mode:String = "ace/mode/html";
		
		/**
		 * Mode of the editor as a path to the mode files.
		 * Default is "ace/mode/html"
		 * */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:String):void {
			if (_mode!=value) modeChanged = true;
			_mode = value;
			invalidateProperties();
		}
		
		private var _scrollSpeed:Number = 2;
		
		/**
		 * Sets scroll speed. Default is 2.
		 * */
		public function get scrollSpeed():Number {
			return _scrollSpeed;
		}

		public function set scrollSpeed(value:Number):void {
			if (_scrollSpeed!=value) scrollSpeedChanged = true;
			_scrollSpeed = value;
			invalidateProperties();
		}

		
		private var _showFoldWidgets:Boolean = true;
		
		/**
		 * Shows fold widgeths if true.
		 * Default is true.
		 * */
		public function get showFoldWidgets():Boolean {
			return _showFoldWidgets;
		}
		
		/**
		 * @private
		 */
		public function set showFoldWidgets(value:Boolean):void {
			if (_showFoldWidgets!=value) showFoldWidgetsChanged = true;
			_showFoldWidgets = value;
			invalidateProperties();
		}
		
		private var _showPrintMargin:Boolean;
		
		/**
		 * Show.
		 * Default is true.
		 * */
		public function get showPrintMargin():Boolean {
			return _showPrintMargin;
		}
		
		/**
		 * @private
		 */
		public function set showPrintMargin(value:Boolean):void {
			if (_showPrintMargin!=value) showPrintMarginsChanged = true;
			_showPrintMargin = value;
			invalidateProperties();
		}
		
		/**
		 * Shows the gutter if true
		 * Default is true.
		 * */
		public function get showGutter():Boolean {
			return _showGutter;
		}
		
		/**
		 * @private
		 */
		public function set showGutter(value:Boolean):void {
			if (_showGutter!=value) showGutterChanged = true;
			_showGutter = value;
			invalidateProperties();
		}
		private var _showGutter:Boolean = true;
		
		/**
		 * Shows line numbers if true
		 * Default is true.
		 * */
		public function get showLineNumbers():Boolean {
			return _showLineNumbers;
		}
		
		/**
		 * @private
		 */
		public function set showLineNumbers(value:Boolean):void {
			if (_showLineNumbers!=value) showLineNumbersChanged = true;
			_showLineNumbers = value;
			invalidateProperties();
		}
		private var _showLineNumbers:Boolean = true;
		

		public function get showCursor():Boolean
		{
			return _showCursor;
		}

		public function set showCursor(value:Boolean):void {
			if (_showCursor!=value) showCursorChanged = true;
			_showCursor = value;
			invalidateProperties();
		}
		private var _showCursor:Boolean = true;

		
		private var _useWordWrap:Boolean;
		
		/**
		 * Uses word wrap if true
		 * Default is false.
		 * */
		public function get useWordWrap():Boolean {
			return _useWordWrap;
		}
		
		/**
		 * @private
		 */
		public function set useWordWrap(value:Boolean):void {
			if (_useWordWrap!=value) useWordWrapChanged = true;
			_useWordWrap = value;
			invalidateProperties();
		}
		
		private var _highlightActiveLine:Boolean;
		
		public function get highlightActiveLine():Boolean {
			return _highlightActiveLine;
		}
		
		public function set highlightActiveLine(value:Boolean):void {
			if (_highlightActiveLine!=value) {
				highlightActiveLineChanged = true;
				invalidateProperties();
			}
			_highlightActiveLine = value;
		}
		
		private var _highlightGutterLine:Boolean;
		
		public function get highlightGutterLine():Boolean {
			return _highlightGutterLine;
		}
		
		public function set highlightGutterLine(value:Boolean):void {
			if (_highlightGutterLine!=value) {
				highlightGutterLineChanged = true;
				invalidateProperties();
			}
			_highlightGutterLine = value;
		}
		
		private var _highlightSelectedWord:Boolean;
		
		public function get highlightSelectedWord():Boolean {
			return _highlightSelectedWord;
		}
		
		public function set highlightSelectedWord(value:Boolean):void {
			if (_highlightSelectedWord!=value) {
				highlightSelectedWordChanged = true;
				invalidateProperties();
			}
			_highlightSelectedWord = value;
		}
		
		private var _tabSize:int = 4;
		
		public function get tabSize():int {
			return _tabSize;
		}
		
		public function set tabSize(value:int):void {
			if (_tabSize!=value) {
				tabSizeChanged = true;
				invalidateProperties();
			}
			_tabSize = value;
		}
		
		private var _useSoftTabs:Boolean;
		
		public function get useSoftTabs():Boolean {
			return _useSoftTabs;
		}
		
		public function set useSoftTabs(value:Boolean):void {
			if (_useSoftTabs!=value) {
				useSoftTabsChanged = true;
				invalidateProperties();
			}
			_useSoftTabs = value;
		}
		
		private var _useWorker:Boolean;
		
		public function get useWorker():Boolean {
			return _useWorker;
		}
		
		public function set useWorker(value:Boolean):void {
			if (_useWorker!=value) {
				useWorkerChanged = true;
				invalidateProperties();
			}
			_useWorker = value;
		}
		
		private var _enableWrapBehaviors:Boolean;
		
		public function get enableWrapBehaviors():Boolean {
			return _enableWrapBehaviors;
		}
		
		/**
		 * Specifies whether to automatically wrap the selection with 
		 * characters like brackets when the character is typed in.
		 * For example, select a word and then press the open curly brace key. 
		 * The selection would be enclosed with open and close curly braces
		 * with this option enabled. 
		 * 
		 * Before: "text". After: "{test}".
		 * */
		public function set enableWrapBehaviors(value:Boolean):void {
			if (_enableWrapBehaviors!=value) {
				enableWrapBehaviorsChanged = true;
				invalidateProperties();
			}
			_enableWrapBehaviors = value;
		}
		
		private var _enableBasicAutoCompletion:Boolean = true;
		
		public function get enableBasicAutoCompletion():Boolean {
			return _enableBasicAutoCompletion;
		}
		
		public function set enableBasicAutoCompletion(value:Boolean):void {
			if (_enableBasicAutoCompletion!=value) {
				enableBasicAutoCompletionChanged = true;
				invalidateProperties();
			}
			_enableBasicAutoCompletion = value;
		}
		
		private var _enableSnippets:Boolean;
		
		public function get enableSnippets():Boolean {
			return _enableSnippets;
		}
		
		public function set enableSnippets(value:Boolean):void {
			if (_enableSnippets!=value) {
				enableSnippetsChanged = true;
				invalidateProperties();
			}
			_enableSnippets = value;
		}
		
		private var _enableLiveAutoCompletion:Boolean;
		
		public function get enableLiveAutoCompletion():Boolean {
			return _enableLiveAutoCompletion;
		}
		
		public function set enableLiveAutoCompletion(value:Boolean):void {
			if (_enableLiveAutoCompletion!=value) {
				enableLiveAutoCompletionChanged = true;
				invalidateProperties();
			}
			_enableLiveAutoCompletion = value;
		}
		
		private var _keyBinding:String;
		
		public function get keyBinding():String {
			return _keyBinding;
		}
		
		public function set keyBinding(value:String):void {
			if (_keyBinding!=value) {
				keyBindingChanged = true;
				invalidateProperties();
			}
			_keyBinding = value;
		}
		
		/**
		 * Get first visible row
		 * */
		public function getFirstVisibleRow():int {
			return editor.getFirstVisibleRow();
		}
		
		/**
		 * Get last visible row
		 * */
		public function getLastVisibleRow():int {
			return editor.getLastVisibleRow();
		}
		
		/**
		 * Gets editor options
		 * */
		public function getOptions():Object {
			return editor.getOptions();
		}
		
		/**
		 * Get selection 
		 * */
		public function getSelection():Object { 
			return editor.getSelection();
		}
		
		/**
		 * Get selected text
		 * */
		public function getTextRange():String {
			var text:String = session.getTextRange(getSelectionRange());
			
			return text;
		}
		
		/**
		 * Get selection range
		 * */
		public function getSelectionRange():Object {
			return editor.getSelectionRange();
		}
		
		/**
		 * Go to line 
		 * */
		public function gotoLine(line:int, column:int = 0, animate:Boolean = true):void {
			editor.gotoLine(line, column, animate);
		}
		
		/**
		 * Shifts the document to wherever "page down" is, as well as moving the cursor position.
		 * */
		public function gotoPageDown():void {
			editor.gotoPageDown();
		}
		
		/**
		 * Shifts the document to wherever "page up" is, as well as moving the cursor position.
		 * */
		public function gotoPageUp():void {
			editor.gotoPageUp();
		}
		
		/**
		 * Indents the current line
		 * */
		public function indent():void {
			editor.indent();
		}
		
		/**
		 * Returns true if the text input is currently focused.
		 * Not sure if this is working.
		 * */
		public function isFocused():Boolean {
			return editor.isFocused();
		}
		
		/**
		 * Indicates if the entire row is fully visible
		 * */
		public function isRowFullyVisible(row:uint):Boolean {
			return editor.isRowFullyVisible(row);
		}
		
		/**
		 * Is row visible
		 * */
		public function isRowVisible(row:uint):Boolean {
			return editor.isRowVisible(row);
		}
		
		/**
		 * Jumps to the matching brace or tag. 
		 * */
		public function jumpToMatching(select:Boolean = true, expand:Boolean = true):void {
			editor.jumpToMatching(select, expand);
		}
		
		/**
		 * If the character before the cursor is a number, this functions changes its value by `amount`.
		 * */
		public function modifyNumber(amount:int):void {
			editor.modifyNumber(amount);
		}
		
		/**
		 * Shifts all the selected lines down one row.
		 * */
		public function moveLinesDown():void { 
			editor.moveLinesDown();
		}
		
		/**
		 * Shifts all the selected lines up one row.
		 * */
		public function moveLinesUp():void { 
			editor.moveLinesUp();
		}
		
		/**
		 * Moves a range of text from the specified range to the specified position. 
		 * */
		public function moveText(range:Object, toPosition:Object, copy:Boolean = false):void { 
			editor.moveText(range, toPosition, copy);
		}
		
		/**
		 * Moves the cursor down a specified number of times.
		 * */
		public function navigateDown(count:int):void {
			editor.navigateDown(count);
		}
		
		/**
		 * Moves the cursor to the end of the current file. 
		 * This deselects the current selection.
		 * */
		public function navigateFileEnd():void {
			editor.navigateFileEnd();
		}
		
		/**
		 * Moves the cursor to the start of the current file. 
		 * This deselects the current selection.
		 * */
		public function navigateFileStart():void {
			editor.navigateFileStart();
		}
		
		/**
		 * Moves the cursor left a specified number of times. 
		 * */
		public function navigateLeft(count:int):void {
			editor.navigateLeft(count);
		}
		
		/**
		 * 
		 * */
		public function navigateLineEnd():void {
			editor.navigateLineEnd();
		}
		
		/**
		 * 
		 * */
		public function navigateLineStart():void {
			editor.navigateLineStart();
		}
		
		/**
		 * Moves the cursor right a specified number of times. 
		 * */
		public function navigateRight(count:int):void {
			editor.navigateRight(count);
		}
		
		/**
		 * Moves the cursor to the specified row and column.
		 * */
		public function navigateTo(row:int, column:int):void {
			editor.navigateTo(row, column);
		}
		
		/**
		 * Moves the cursor up a specified number of times. 
		 * */
		public function navigateUp(count:int):void {
			editor.navigateUp(count);
		}
		
		/**
		 * 
		 * */
		public function navigateWordLeft():void {
			editor.navigateWordLeft();
		}
		
		/**
		 * 
		 * */
		public function navigateWordRight():void {
			editor.navigateWordRight();
		}
		
		/**
		 * Scrolls the document to wherever "page down" is, without changing the cursor position.
		 * */
		public function scrollPageDown():void {
			editor.scrollPageDown();
		}
		
		/**
		 * Scrolls the document to wherever "page up" is, without changing the cursor position.
		 * */
		public function scrollPageUp():void {
			editor.scrollPageUp();
		}
		
		/**
		 * Scrolls to a line. If center is true, it puts the line in middle of screen (or attempts to).
		 * */
		public function scrollToLine(line:int, center:Boolean = false, animate:Boolean = true, callBack:Function = null):void {
			editor.scrollToLine(line, center, animate, callBack);
		}
		
		/**
		 * Scrolls to a specific row
		 * */
		public function scrollToRow(row:Object = null):void {
			editor.scrollToRow(row);
		}
		
		/**
		 * Scrolls to the last row
		 * */
		public function scrollToEnd():void {
			var lastRow:int = editor.session.getLength();
			editor.scrollToRow(lastRow);
		}
		
		/**
		 * Removes event listener to the editor
		 * */
		public function off(name:String, handler:Function):void {
			editor.off(name, handler);
		}
		
		/**
		 * Adds an event listener to the editor
		 * */
		public function on(name:String, handler:Function):void {
			editor.on(name, handler);
		}
		
		/**
		 * Adds an event listener to the editor for one occurance of an event
		 * */
		public function once(name:String, handler:Function):void {
			editor.once(name, handler);
		}
		
		/**
		 * Redos the last operation 
		 * */
		public function redo():void {
			session.redo();
		}
		
		/**
		 * Undo the last operation
		 * */
		public function undo():void {
			session.undo();
		}
		
		/**
		 * Removes the range from the document
		 * */
		public function remove(range:Object):void {
			session.remove(range);
		}
		
		/**
		 * Performs a replace on a previous call to find(). <br/><br/>
		 * 
		 * To perform a replace: 
		 <pre>
		 ace.find("needle");
		 ace.replace("bar");
		 </pre>
		 *
		 * @see #find()
		 * @see #replaceAll()
		 * */
		public function replace(value:String = ""):void {
			editor.replace(value);
		}
		
		/**
		 * Performs a replace all occurances on a previous call to find(). <br/><br/>
		 * 
		 * To perform a replace: 
		 <pre>
		 ace.find("needle");
		 ace.replaceAll("bar");
		 </pre>
		 *
		 * @see #replace()
		 * @see #find()
		 * */
		public function replaceAll(value:String = ""):void {
			editor.replaceAll(value);
		}
		
		/**
		 * Ace resizes itself on window events. If you resize the editor 
		 * div in another manner use may need to call resize().
		 * */
		public function resize():void{
			editor.resize();
		}
		
		public function revealRange():void{};
		
		/**
		 * Selects all the text in the document
		 * */
		public function selectAll():void{
			editor.selectAll();
		}
		
		public function selectMore():void{};
		public function selectMoreLines():void{};
		public function selectPageDown():void{};
		public function selectPageUp():void{};
		
		/**
		 * Set the highlight of the active line
		 * */
		public function setHighlightActiveLine(value:Boolean):void{
			editor.setHighlightActiveLine(value);
		}
		
		/**
		 * Set the highlight of the gutter line
		 * */
		public function setHighlightGutterLine(value:Boolean):void{
			editor.setHighlightGutterLine(value);
		}
		
		/**
		 * Set the highlight of the selected word
		 * */
		public function setHighlightSelectedWord(value:Boolean):void{
			editor.setHighlightSelectedWord(value);
		}
		
		/**
		 * Set the mode of the editor
		 * @see #mode
		 * */
		public function setMode(value:String):void{
			editor.getSession().setMode(value);
			_mode = value;
		}
		
		/**
		 * Set theme of the editor
		 * @see #theme
		 * */
		public function setTheme(value:String):void{
			editor.setTheme(value);
			_theme = value;
		}
		
		private var _isReadOnly:Boolean;
		
		/**
		 * Uses word wrap if true
		 * Default is true.
		 * */
		public function get isReadOnly():Boolean {
			return _isReadOnly;
		}
		
		/**
		 * @private
		 */
		public function set isReadOnly(value:Boolean):void {
			if (_isReadOnly!=value) isReadOnlyChanged = true;
			_isReadOnly = value;
			invalidateProperties();
		}
		
		
		private var _enableFind:Boolean = true;
		
		/**
		 * Enable find
		 * Default is true.
		 * */
		public function get enableFind():Boolean {
			return _enableFind;
		}
		
		/**
		 * @private
		 */
		public function set enableFind(value:Boolean):void {
			if (_enableFind!=value) enableFindChanged = true;
			_enableFind = value;
			invalidateProperties();
		}
		
		
		private var _enableReplace:Boolean = true;
		
		/**
		 * Enable replace
		 * Default is true.
		 * */
		public function get enableReplace():Boolean {
			return _enableReplace;
		}
		
		/**
		 * @private
		 */
		public function set enableReplace(value:Boolean):void {
			if (_enableFind!=value) enableFindChanged = true;
			_enableReplace = value;
			invalidateProperties();
		}
		
		
		/**
		 * Listen for change events. The editor may be faster if we 
		 * aren't listening for change events and transporting values back and forth. 
		 * Setting this to false is good for situations like read only mode.
		 * Default is true.
		 * */
		public function get listenForChanges():Boolean {
			return _listenForChanges;
		}
		
		/**
		 * @private
		 */
		public function set listenForChanges(value:Boolean):void {
			if (_listenForChanges!=value) listenForChangesChanged = true;
			_listenForChanges = value;
			
			invalidateProperties();
		}
		
		private var _listenForChanges:Boolean = true;
		private var listenForChangesChanged:Boolean;
		
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (!editor) return; // come back later?
			
			const FIND:String = "find";
			const REPLACE:String = "replace";
			
			// this is good to turn off listeners for read only mode as it will save CPU cycles
			if (listenForChangesChanged) {
				// should we use session here instead of getSession() - not unless handler is always added
				if (listenForChanges && !callBackAdded) {
					editor.on(Event.COPY, copyHandler);
					editor.on(Event.PASTE, pasteHandler);
					editor.on(SESSION_MOUSE_MOVE, mouseMoveHandler);
					session.on(EDITOR_CHANGE, changeHandler);
					session.on(SESSION_CHANGE_SESSION, sessionChangeHandler);
					session.selection.on(SESSION_CHANGE_SELECTION, selectionChangeHandler);
					session.selection.on(SESSION_CHANGE_CURSOR, cursorChangeHandler);
					session.on("blur", blurHandler);
					session.on("focus", focusHandler);
					
					/* ...too busy
					session.on("changeSelectionStyle", changeHandler);
					*/
					callBackAdded = true;
				}
				else if (!listenForChanges) {
					editor.off(Event.COPY, copyHandler);
					editor.off(Event.PASTE, pasteHandler);
					editor.off(SESSION_MOUSE_MOVE, mouseMoveHandler);
					session.off(EDITOR_CHANGE, changeHandler);
					session.off(SESSION_CHANGE_SESSION, sessionChangeHandler);
					session.off("blur", blurHandler);
					session.off("focus", focusHandler);
					session.selection.off(SESSION_CHANGE_SELECTION, selectionChangeHandler);
					session.selection.off(SESSION_CHANGE_CURSOR, cursorChangeHandler);
					callBackAdded = false;
				}
				listenForChangesChanged = false;
			}
			
			if (marginChanged) {
				element.style.margin = margin;
				marginChanged = false;
			}
			
			if (themeChanged) {
				editor.setTheme(theme);
				themeChanged = false;
			}
			
			// there might be a bug where the snippets are not for the correct language if we enable
			// snippets at a later time than at startup so we mark mode as changed
			if (enableSnippetsChanged) {
				editor.setOption("enableSnippets", enableSnippets);
				//options = aceEditor.getOptions();
				enableSnippetsChanged = false;
			}
			
			if (modeChanged) {
				editor.getSession().setMode(_mode);
				modeChanged = false;
			}
			
			if (keyBindingChanged) {
				editor.setKeyboardHandler(keyBinding);
				keyBindingChanged = false;
			}
			
			if (showFoldWidgetsChanged) {
				editor.setShowFoldWidgets(showFoldWidgets);
				showFoldWidgetsChanged = false;
			}
			
			if (showPrintMarginsChanged) {
				editor.setShowPrintMargin(showPrintMargin);
				showPrintMarginsChanged = false;
			}
			
			if (showGutterChanged) {
				editor.renderer.setShowGutter(showGutter);
				showGutterChanged = false;
			}
			
			if (showLineNumbersChanged) {
				editor.renderer.setOption("showLineNumbers", showLineNumbers);
				showLineNumbersChanged = false;
			}
			
			if (showCursorChanged) {
				var cursorDisplay:String = showCursor ? "visible" : "none";
				editor.renderer.$cursorLayer.element.style.display = cursorDisplay;
				showCursorChanged = false;
			}
			
			if (useWordWrapChanged) {
				editor.getSession().setUseWrapMode(useWordWrap);
				useWordWrapChanged = false;
			}
			
			if (isReadOnlyChanged) {
				editor.setReadOnly(isReadOnly);
				isReadOnlyChanged = false;
			}
			
			if (showInvisiblesChanged) {
				editor.setShowInvisibles(showInvisibles);
				showInvisiblesChanged = false;
			}
			
			if (fontSizeChanged) {
				var fontSize:Number = getStyle("fontSize");
				editor.setFontSize(fontSize);
				fontSizeChanged = false;
			}
			
			if (showIndentGuidesChanged) {
				editor.setDisplayIndentGuides(showIndentGuides);
				showIndentGuidesChanged = false;
			}
			
			if (enableFindChanged) {
				
				if (enableFind) {
					editor.commands.removeCommand(FIND);
				}
				else {
					editor.commands.addCommand(FIND);
				}
				enableFindChanged = false;
			}
			
			if (enableReplaceChanged) {
				
				if (enableReplace) {
					editor.commands.removeCommand(REPLACE);
				}
				else {
					editor.commands.addCommand(REPLACE);
				}
				
				enableReplaceChanged = false;
			}
			
			var options:Object;
			if (enableBasicAutoCompletionChanged) {
				editor.setOption("enableBasicAutocompletion", enableBasicAutoCompletion);
				enableBasicAutoCompletionChanged = false;
			}
			
			if (enableLiveAutoCompletionChanged) {
				editor.setOption("enableLiveAutocompletion", enableLiveAutoCompletion);
				enableLiveAutoCompletionChanged = false;
			}
			
			if (highlightActiveLineChanged) {
				editor.setHighlightActiveLine(highlightActiveLine);
				highlightActiveLineChanged = false;
			}
			
			if (highlightGutterLineChanged) {
				editor.setHighlightGutterLine(highlightGutterLine);
				highlightGutterLineChanged = false;
			}
			
			if (highlightSelectedWordChanged) {
				editor.setHighlightSelectedWord(highlightSelectedWord);
				highlightSelectedWordChanged = false;
			}
			
			if (tabSizeChanged || useSoftTabsChanged) {
				session.setUseSoftTabs(useSoftTabs);
				session.setTabSize(tabSize);
				tabSizeChanged = false;
				useSoftTabsChanged = false;
			}
			
			if (useWorkerChanged) {
				editor.getSession().setUseWorker(useWorker);
				useWorkerChanged = false;
			}
			
			if (enableBehaviorsChanged) {
				editor.setBehavioursEnabled(enableBehaviors);
				enableBehaviorsChanged = false;
			}
			
			if (enableWrapBehaviorsChanged) {
				editor.setWrapBehavioursEnabled(enableWrapBehaviors);
				enableWrapBehaviorsChanged = false;
			}
			
			if (scrollSpeedChanged) {
				editor.setScrollSpeed(scrollSpeed);
				scrollSpeedChanged = false;
			}
			
			if (textChanged) {
				setValue(_text); // use _text not text // causes selectionChange changeSelection events
				textChanged = false;
			}
			
		}
		
		/**
		 * Set focus to the editor. Not really working now. Problem with AIR?
		 * */
		override public function setFocus():void {
			super.setFocus();
			
			if (editor) {
				var textInput:Object = editor.textInput;
				var container:Object = editor.container;
				var textAreas:Object = container.getElementsByTagName("textarea");
				var textArea:Object = textAreas[0];
				textInput.focus(); // doesn't seem to work
				textArea.focus();
				
			}
		}
		
		/**
		 *  @private
		 */
		override public function styleChanged(styleProp:String):void {
			var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
			
			super.styleChanged(styleProp);
			
			if (allStyles || styleProp == "fontSize") {
				fontSizeChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * Maps to the session reset cache method
		 * */
		public function resetCaches():void {
			session.resetCaches();
		}
		
		/**
		 * Resets the cache 
		 * */
		public function resetCache():void {
			session.bgTokenizer.lines.length = session.bgTokenizer.states.length = 0;
		}
		
		/**
		 * Maps to the session beautify method. Doesn't work well. 
		 * */
		public function beautifyMarkup():void {
			if (beautify) {
				beautify.beautify(session);
			}
			else {
				throw new Error("Beautify extension is not installed. Add an include on the page template");
			}
		}
		
		/**
		 * Inserts a block of text and the indicated position.
		 * */
		public function insert(position:Object, text:String):Object {
			return editor.insert(position, text);
		}
		
		/**
		 * Inserts a block of text and the indicated position.
		 * */
		public function appendText(text:String):void {
			session.insert({row: session.getLength(), column: 0}, "\n" + text);
		}
		
		/**
		 * Set annotation
		 * @param row row for annotation
		 * @param column column of annotation
		 * @param text text to display for annotation
		 * @param type - type can be error, warning and information
		 * */
		public function setAnnotation(row:int, column:int = 0, text:String = null, type:String = null):void {
			if (editor==null) return;
			editor.getSession().setAnnotations([{
				row: row,
				column: column,
				text: text,
				type: type
			}]);
		}
		
		/**
		 * Sets one or more annotations. See setAnnotation for object name value pairs.
		 * @see setAnnotation
		 * @param row row for annotation
		 * @param column column of annotation
		 * @param text text to display for annotation
		 * @param type - type can be error, warning and information
		 * */
		public function setAnnotations(annotations:Array):void {
			editor.getSession().setAnnotations(annotations);
		}
		
		/**
		 * Clears all annotations
		 * */
		public function clearAnnotations():void {
			if (editor) {
				editor.getSession().setAnnotations([]);
			}
		}
		
		/**
		 * Set the selection range
		 * */
		public function setSelectionRange(range:Object, reverse:Boolean = false):void {
			editor.setSelectionRange(range, reverse);
		}
		
		/**
		 * Moves the selection cursor to the indicated row and column.
		 * */
		public function selectTo(row:Number, column:Number):void {
			editor.setSelectionTo(row, column);
		}
		
		/**
		 * Moves the selection cursor to the row and column indicated
		 * */
		public function selectToPosition(position:Object):void {
			editor.selectToPosition(position);
		}
		
		/**
		 * Adds a range to a selection by entering multiselect mode, if necessary.
		 * */
		public function addRange(range:Object, blockChangeEvents:Boolean):void {
			editor.addRange(range, blockChangeEvents);
		}
		
		/**
		 * Gets the selection anchor
		 * */
		public function getSelectionAnchor():Object {
			return editor.selection.getSelectionAnchor();
		}
		
		/**
		 * Gets the selection lead
		 * */
		public function getSelectionLead():Object {
			return editor.selection.getSelectionLead();
		}
		
		/**
		 * Gets the cursor
		 * */
		public function getCursor():Object {
			return editor.selection.getCursor();
		}
		
		/**
		 * Gets the range
		 * */
		public function getRange():Object {
			return editor.getRange();
		}
		
		/**
		 * Gets the total lines
		 * */
		public function getTotalLines():int {
			return editor.session.getLength();
		}
		
		/**
		 * Gets the token at the row and column specified
		 * */
		public function getTokenAt(row:uint, column:uint):Object {
			return editor.session.getTokenAt(row, column);
		}
		
		/**
		 * Moves the cursor to the position provided.
		 * */
		public function moveCursorToPosition(position:Object):void {
			editor.moveCursorToPosition(position);
		}
		
		/**
		 * Moves the cursor to the row and column provided. If preventUpdateDesiredColumn 
		 * is true, then the cursor stays in the same column position as its original point.
		 * */
		public function moveCursorTo(row:Number, column:Number, keepDesiredColumn:Boolean = false):void {
			editor.moveCursorTo(row, column, keepDesiredColumn);
		}
		
		/**
		 * Moves the cursor to the row and column provided. If preventUpdateDesiredColumn 
		 * is true, then the cursor stays in the same column position as its original point.
		 * */
		public function moveCursorToScreen(row:Number, column:Number, keepDesiredColumn:Boolean = false):void {
			editor.moveCursorToScreen(row, column, keepDesiredColumn);
		}
		
		/**
		 * Reference to the range
		 * */
		public var range:Object;
		
		public function get showIndentGuides():Boolean {
			return _showIndentGuides;
		}
		
		/**
		 * Shows indent guides
		 * */
		public function set showIndentGuides(value:Boolean):void {
			if (_showIndentGuides!=value) showIndentGuidesChanged = true;
			_showIndentGuides = value;
			invalidateProperties();
		}
		private var _showIndentGuides:Boolean;
		
		
		/**
		 * Text to show or is shown in the editor.
		 * Use _text to get the value that was set programmatically. 
		 * */
		public function get text():String {
			
			if (editor) {
				return editor.getValue();
			}
			return _text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void {
			if (text!=value) textChanged = true; // have to compare to text not _text
			_text = value;
			invalidateProperties();
		}
		public var _text:String = "";
		
		/**
		 * Method to satisfy IDisplayText. Returns false.
		 * */
		public function get isTruncated():Boolean {
			return false;
		}
		
		private var _margin:String;
		
		public function get margin():String {
			return _margin;
		}
		
		/**
		 * Sets the margin around the editor. This is useful for scrolling
		 * beyond the boundries of the editor. Also works around some mouse issues
		 * Set to values such as "20px 0". This will add 20px of space around the 
		 * top and bottom of the editor. Default is 0.  
		 * */
		public function set margin(value:String):void {
			if (_margin!=value) marginChanged = true;
			_margin = value;
			invalidateProperties();
		}
		
		
		public var errorMessage:String;
		
		/**
		 * Returns an editor that has an id. This will error out here if the div
		 * cannot be found on the page template. 
		 * 
		 * You should have a div on your page with an identity like this:
		 <pre>
		 &lt;div id='editor'>&lt;/div>
		 </pre>
		 * @see #editorIdentity
		 * */
		public function getEditor(id:String):Object {
			return domWindow.ace.edit(id);
		}
		
		/**
		 * Handles when editor is loaded. Happens earlier if it's a Friday night. 
		 * */
		protected function completeHandler(event:Event):void {
			//var isPrimaryApplication:Boolean = SystemManagerGlobals.topLevelSystemManagers[0] == systemManager;
			
			// somehow the editor is getting reloaded on exit of application
			// this throws errors
			if (aceFound && ignoreCloseErrors) {
				return;
			}
			
			if (validateSources) {
				aceFound = domWindow.ace ? true : false;
				
				try {
					if (aceFound) {
						
						// can't seem to catch this error!
						// the folling line always throws an error if div is not found:
						// domWindow.ace.edit(id);
						// would have hoped it returned null
						// using old fashioned method
						var element:Object = domWindow.document.getElementById(editorIdentity);
						var localName:String = element ? element.nodeName : null;
						
						aceEditorFound = (element && localName && localName.toLowerCase()=="div");
					}
				}
				catch (e:Error) {
					aceEditorFound = false;
				}
				
				// THIS ERROR APPEARS TO HAPPEN ON APPLICATION CLOSE
				// Error: The ace JavaScript variable was not found. Make sure to copy the directory, 'src-min-noconflict' to your project src directory and include a reference to it in the template page.
				// Not sure what is going on here. Maybe an unload event
				// or an application deactivate event. TODO Add listener for deactivate 
				
				if (!aceFound) {
					errorMessage = "The ace JavaScript variable was not found. Make sure to copy the directory, ";
					errorMessage += "'src-min-noconflict' to your project src directory and include a reference ";
					errorMessage += "to it in the template page.";
					throw new Error(errorMessage);
				}
				else if (!aceEditorFound) {
					errorMessage = "The ace editor div was not found. Make sure the template page ";
					errorMessage += "has a div with an id of '" + editorIdentity + "'.";
					throw new Error(errorMessage);
				}
			}
			
			createHTMLReferences();
			setEditorProperties();
			commitProperties();
			setValue(text);
			clearSelection();
			
			dispatchEvent(new Event(EDITOR_READY));
		}
		
		/**
		 * Creates references we will use to reference the ace editor
		 * */
		private function createHTMLReferences():void {
			pageDocument = domWindow.document;
			pagePlugins = pageDocument.plugins;
			pageScripts = pageDocument.scripts;
			pageStyleSheets = pageDocument.styleSheets;
			aceManager = domWindow.ace;
			editor = aceManager.edit(editorIdentity);
			element = editor.container;
			languageTools = aceManager.require("ace/ext/language_tools");
			beautify = aceManager.require("ace/ext/beautify");
			session = editor.getSession();
			selection = session.selection;
			
			// this is a hack because somewhere in ace javascript someone is calling console.log
			// and there is no console in the AIR HTML component dom window
			// however you can create your own and assign it to the console property
			if (console==null) {
				console = {};
				console.log = trace;
				console.error = trace;
			}
			
			if (domWindow.console==null) {
				domWindow.console = console;
				//domWindow.console.log("hello");
				//domWindow.console.error("hello error");
			}
			
			editor.commands.addCommand({
				name: 'save',
				bindKey: {win: "Ctrl-S", "mac": "Cmd-S"},
				exec: saveKeyboardHandler});
			editor.commands.addCommand({
				name: 'blockComment',
				bindKey: {win: "Ctrl-Shift-c", "mac": "Cmd-Shift-C"},
				exec: blockCommentHandler});
			editor.commands.addCommand({
				name: 'find',
				bindKey: {win: "Ctrl-F", "mac": "Cmd-F"},
				exec: findKeyboardHandler});
			
			isEditorReady = true;
		}
		
		/**
		 * Use to add commands to the editor<br ><br >
		 * 
		 * Example: 
<pre>
editor.addCommand({
	name: 'find',
	bindKey: {win: "Ctrl-F", "mac": "Cmd-F"},
	exec: findKeyboardHandler});
</pre>
		 * */
		public function addCommand(object:Object):void {
			editor.commands.addCommand(object);
		}
		
		/**
		 * Used to remove commands from the editor<br ><br >
		 * 
		 * Example (not tested): 
<pre>
editor.removeCommand({name: 'find'});
</pre>
		 * */
		public function removeCommand(object:Object):void {
			editor.commands.removeCommand(object);
		}
		
		/**
		 * Handler for block comment keyboard shortcut
		 * */
		public function blockCommentHandler(editor:Object, event:Object):void {
			editor.toggleBlockComment();
		}
		
		/**
		 * Handler for save keyboard shortcut
		 * */
		public function saveKeyboardHandler(editor:Object, event:Object):void {
			//console.log("saving", editor.session.getValue())
			if (hasEventListener(SAVE)) {
				dispatchEvent(new Event(SAVE));
			}
		}
		
		/**
		 * Handler for find keyboard shortcut
		 * */
		public function findKeyboardHandler(editor:Object, event:Object):void {
			if (hasEventListener(FIND)) {
				dispatchEvent(new Event(FIND));
			}
		}
		
		/**
		 * Sets the ace editor properties. We might want to use
		 * Flex commit properties to handle changes
		 * */
		public function setEditorProperties():void {
			invalidateProperties();
			// set values from editor
			//var options:Object = editor.getOptions();
			
			enableBehaviorsChanged = true;
			enableFindChanged = true;
			enableReplaceChanged = true;
			enableSnippetsChanged = true;
			showInvisiblesChanged = true;
			showIndentGuidesChanged = true;
			fontSizeChanged = true;
			enableBasicAutoCompletionChanged = true;
			enableLiveAutoCompletionChanged = true;
			highlightActiveLineChanged = true;
			highlightGutterLineChanged = true;
			highlightSelectedWordChanged = true;
			isReadOnlyChanged = true;
			keyBindingChanged = true;
			listenForChangesChanged = true;
			modeChanged = true;
			showFoldWidgetsChanged = true;
			showPrintMarginsChanged = true;
			showGutterChanged = true;
			tabSizeChanged = true;
			textChanged = true;
			themeChanged = true;
			useSoftTabsChanged = true;
			useWordWrapChanged = true;
			useWorkerChanged = true;
			enableWrapBehaviorsChanged = true;
			marginChanged = true;
		}
		
		/**
		 * Sets the text of the editor. You can also set the text property.
		 * Required. If position is 0 then all text is selected and cursor is at the end of the document, 
		 * if -1 then the cursor is placed at the start of the document and 
		 * if 1 then the cursor is placed at the end. 
		 * Default is -1. 
		 * */
		public function setValue(value:String="", position:int = -1):void {
			isValueCommit = true;
			if (value==null) value = "";
			editor.setValue(value, position);
			isValueCommit = false;
		}
		
		/**
		 * Indicates that the changes being dispatched from the ace editor
		 * are not changes from the user typing but from us setting the 
		 * contents programmatically.
		 * */
		public var isValueCommit:Boolean;
		private var themeChanged:Boolean;
		private var scrollSpeedChanged:Boolean;
		private var modeChanged:Boolean;
		private var showFoldWidgetsChanged:Boolean;
		private var showPrintMarginsChanged:Boolean;
		private var showGutterChanged:Boolean;
		private var showLineNumbersChanged:Boolean;
		private var showCursorChanged:Boolean;
		private var useWordWrapChanged:Boolean;
		private var isReadOnlyChanged:Boolean;
		private var enableFindChanged:Boolean;
		private var enableReplaceChanged:Boolean;
		private var showInvisiblesChanged:Boolean;
		private var fontSizeChanged:Boolean;
		private var textChanged:Boolean;
		private var showIndentGuidesChanged:Boolean;
		private var enableBasicAutoCompletionChanged:Boolean;
		private var enableLiveAutoCompletionChanged:Boolean;
		private var highlightActiveLineChanged:Boolean;
		private var highlightGutterLineChanged:Boolean;
		private var highlightSelectedWordChanged:Boolean;
		private var tabSizeChanged:Boolean;
		private var useSoftTabsChanged:Boolean;
		private var useWorkerChanged:Boolean;
		private var enableWrapBehaviorsChanged:Boolean;
		private var enableSnippetsChanged:Boolean;
		private var marginChanged:Boolean;
		
		/**
		 * Reference to the anchor of the last changeSelection event
		 * */
		public var anchor:Object;
		
		/**
		 * Reference to the lead of the last changeSelection event
		 * */
		public var lead:Object;
		
		/**
		 * Reference to current row. Must have listenForChanges enabled
		 * */
		public var row:int;
		
		/**
		 * Reference to current column.
		 * */
		public var column:int;
		private var enableBehaviorsChanged:Boolean;
		private var keyBindingChanged:Boolean;
		public var mouseMoveEvent:Object;
		
		/**
		 * Text copied on copy. Only available through a copy event dispatch. 
		 * */
		public var copiedText:String;
		
		/**
		 * Text pasted into the editor. Only available through a paste event dispatch. 
		 * */
		public var pastedText:String;
		
		/**
		 * Console object. 
		 * This is a workaround because somewhere in the ace javascript someone is calling console.log
		 * and there is no console in the AIR HTML component dom window
		 * however you can create your own and assign it to the console property. 
		 * Add at least log and error methods.
		 * 
<pre>
editor.console = {log:trace, error:trace};
</pre>
		 */
		public var console:Object;
		
		/**
		 * Set this to true to report errors to the console
		 * such as missing template file and missing JavaScript ace global variable
		 */
		public var validateSources:Boolean = true;
		
		/**
		 * Indicates if the window.ace instance is found. If it's false and the complete event
		 * has been dispatched check that you have a script on the page template and that
		 * it is pointing to the location of the ace editor src files. 
		 * 
		 * It should look like this:
		 <pre>
		 &lt;script src="src-min-noconflict/ace.js" type="text/javascript" charset="utf-8">&lt;/script>
		 </pre>
		 * */
		public var aceFound:Boolean;
		
		/**
		 * This is set to true when the editor is found and ready to use
		 * */
		[Bindable]
		public var isEditorReady:Boolean;
		
		/**
		 * Errors occur on exit possibly because of an on unload event. 
		 * This is set to true to ignore errors which are causing the application to crash
		 * because of runtime errors. 
		 * */
		public var ignoreCloseErrors:Boolean = true;
		
		/**
		 * Indicates if the window.ace editor instance is found. If it's false, the complete event
		 * has been dispatched and the property aceFound is true then check that you have a div 
		 * on the page template that has an id that matches the value in editorIdentity 
		 * (default is "editor").  
		 * 
		 * It should look like this:
		 <pre>
		 &lt;div id='editor'>&lt;/div>
		 </pre>
		 * */
		public var aceEditorFound:Boolean;
		
		/**
		 * Handles session change events from the editor. Not tested.
		 * */
		public function sessionChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeSelection
			session = editor.getSession();
			
			if (hasEventListener(SESSION_CHANGE)) {
				
				dispatchEvent(new Event(SESSION_CHANGE));
			}
		}
		
		/**
		 * Handles selection change events from the editor
		 * */
		public function selectionChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeSelection
			anchor = editor.anchor;
			lead = editor.lead;
			
			
			if (hasEventListener(SELECTION_CHANGE)) {
				
				dispatchEvent(new Event(SELECTION_CHANGE));
			}
		}
		
		/**
		 * Handles cursor change events from the editor
		 * */
		public function cursorChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeCursor
			anchor = editor.anchor;
			lead = editor.lead;
			//var leadPosition:Object = lead.getPosition();
			row = lead.row;
			column = lead.column;
			
			if (hasEventListener(CURSOR_CHANGE)) {
				dispatchEvent(new Event(CURSOR_CHANGE));
			}
		}
		
		/**
		 * Handles mouse move events from the editor. Named as it is because UIComponent already 
		 * has a mouseMove event.
		 * 
		 * You can use this event to get token info:
		 <pre>
		 var position = ace.mouseMoveEvent.getDocumentPosition();
		 var token:Object = session.getTokenAt(position.row, position.column);
		 trace(token);
		 
		 token = {
		 type: "paren.paren",
		 value: "}",
		 index: 0,
		 start: 0
		 } 
		 </pre>
		 * */
		public function mouseMoveHandler(event:Object, editor:Object):void {
			//var token:Object = session.getTokenAt(position.row, position.column);
			
			if (hasEventListener(MOUSE_MOVE_OVER_EDITOR)) {
				mouseMoveEvent = event;
				dispatchEvent(new Event(MOUSE_MOVE_OVER_EDITOR));
			}
		}
		
		/**
		 * Handles change events from the editor
		 * */
		public function changeHandler(event:Object, editor:Object):void {
			var action:String = event.action;
			var operation:FlowOperation;
			
			//trace("action:" + action);
			
			if (hasEventListener(Event.CHANGE)) {
				operation = new FlowOperation(null); // thought I could use this but doesn't look like I can set certain properties
				operation.userData = event;
				
				// POSSIBLE SOLUTION TO MULTIPLE EVENTS BEING DISPATCHED IS TO 
				// CHECK OUT METHOD TLF DOES IT IN RICH EDITABLE TEXT 
				if (action==INSERT_ACTION) {
					
				}
				else if (action==INSERT_TEXT_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				else if (action==INSERT_LINES_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				else if (action==REMOVE_LINES_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				
				dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
			}
			
		}
		
		/**
		 * Handles paste events from the editor
		 * Pasted value is copied to the pastedText property 
		 * and then removed after paste event has been dispatched
		 * */
		public function pasteHandler(event:Object, editor:Object):void {
			pastedText = text;
			
			if (hasEventListener(Event.PASTE)) {
				dispatchEvent(new Event(Event.PASTE));
			}
			
			pastedText = text;
		}
		
		/**
		 * Handles copy events from the editor. 
		 * Copied value is copied to the copiedText property 
		 * and then removed after copy event has been dispatched.
		 * */
		public function copyHandler(text:String, editor:Object):void {
			copiedText = text;
			
			if (hasEventListener(Event.COPY)) {
				dispatchEvent(new Event(Event.COPY));
			}
			
			copiedText = ""; // removed after event is dispatched
		}
		
		/**
		 * Handles blur events from the editor
		 * */
		public function blurHandler(event:Object, editor:Object):void {
			var action:String = event.action;
			
			//trace("action:" + action);
			
			if (hasEventListener(FocusEvent.FOCUS_OUT)) {
				
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			}
			
		}
		
		/**
		 * Handles focus in events from the editor
		 * */
		public function focusHandler(event:Object, editor:Object):void {
			var action:String = event.action;
			
			if (hasEventListener(FocusEvent.FOCUS_IN)) {
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
			}
			
		}
		
		/**
		 * Forces a blur
		 * */
		public function blur():void {
			editor.blur();
		}
		
		/**
		 * Performs another search for the word previously specified.
		 * */
		public function findPrevious(options:Object = null, animate:Boolean = false):void {
			editor.findPrevious(options, animate);
		}
		
		/**
		 * Performs another search for the word previously specified.
		 * */
		public function findNext(options:Object = null, animate:Boolean = false):void {
			editor.findNext(options, animate);
		}
		
		/**
		 * Performs a search for the word specified.<br/><br/>
		 * 
		 * To perform a find: 
 <pre>
	 ace.find("needle",{
	 backwards: false,
	 wrap: false,
	 caseSensitive: false,
	 wholeWord: false,
	 regExp: false,
	 start: {row:"0",column:"0"}
	 });
	 ace.findNext();
	 ace.findPrevious();
 </pre>
 To perform a replace: 
 <pre>
	 ace.find("needle");
	 ace.replace('bar');
 </pre>
 To perform a search from the current selection: 
 <pre>
	 var position:Object = ace.getSelectionAnchor();
	 ace.find("needle", {row:position.row,column:position.column});
	 // or
	 var options:Object = {skipCurrent:false};
	 ace.find("needle", options);
 </pre>
		 * @param needle: The string or regular expression you're looking for
		 * @param backwards: Whether to search backwards from where cursor currently is. Defaults to false.
		 * @param wrap: Whether to wrap the search back to the beginning when it hits the end. Defaults to false.
		 * @param caseSensitive: Whether the search ought to be case-sensitive. Defaults to false.
		 * @param wholeWord: Whether the search matches only on whole words. Defaults to false.
		 * @param range: The Range to search within. Set this to null for the whole document
		 * @param regExp: Whether the search is a regular expression or not. Defaults to false.
		 * @param start: The starting Range or cursor position to begin the search
		 * @param skipCurrent: Whether or not to include the current line in the search. Default to false
		 * @param animate: Whether or not to animate. Default to false
		 * */
		public function find(value:String, options:Object = null, animate:Boolean = false):Object {
			return editor.find(value, options, animate);
		}
		
		/**
		 * Performs a search for the word specified.
		 * */
		public function findAll(value:String, options:Object = null, keeps:Boolean = false):Object {
			return editor.findAll(value, options, keeps);
		}
		
		/**
		 * Clears the selection highlight
		 * */
		public function clearSelection():void {
			editor.clearSelection();
		}
		
		/**
		 * Attempts to center the selection on the screen
		 * */
		public function centerSelection():void {
			editor.centerSelection();
		}
		
		/**
		 * Measures the performance of the editor.
		 * Returns how fast a mode can tokenize the whole document. 
		 * */
		public function measureTokenizePerformance():int {
			// reset cache
			var linesCount:uint = session.getLength();
			var time:uint = getTimer();
			
			for (var i:int; i < linesCount; i++) {
				session.getTokens(i);
			}
			
			/*
			if (editor.$highlightTagPending == true) {
				editor.$highlightTagPending = false;
				editor.$highlightPending = false;
			}
			else {
				session.removeMarker(session.$tagHighlight);
				session.$tagHighlight = null;
				session.removeMarker(session.$bracketHighlight);
				session.$bracketHighlight = null;
				editor.$highlightTagPending = true;
				editor.$highlightPending = true;
			}*/
			
			
			
			return getTimer() - time;
		}
		
		/**
		 * Sets the location to the html page that has ace editor in it. 
		 * You should include this file in your application
		 * @see loadOnCreationComplete
		 * @see pathToTemplate
		 * */
		public function initializeEditor():void {
			location = pathToTemplate;
		}
	}
}
