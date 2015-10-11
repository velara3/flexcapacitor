package com.flexcapacitor.controls
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.events.FlexEvent;
	
	import spark.events.TextOperationEvent;

	/**
	 * A search text input with a search icon and a clear button on the 
	 * right side of the text display that works with AceEditor.
	 * If you hold down the shift key the search is performed in reverse.
	 * You can set options with the options object. 
	 * 
	 * See com.flexcapacitor.controls.AceEditor.find() for a list of options.
	 * 
<pre>
&lt;controls:AceSearchTextInput id="searchInput" 
				   prompt="Search" 
				   width="100%"
				   height="24"
				   options="{{skipCurrent: true, caseSensitive: false}}"
				   aceEditor="{aceEditor}"/>
</pre>
	 *
	 * @see com.flexcapacitor.controls.AceEditor.find()
	 * */
	public class AceSearchTextInput extends SearchTextInput {
		
		/**
		 * Constructor
		 * */
		public function AceSearchTextInput():void {
			addEventListener(TextOperationEvent.CHANGE, searchInput_changeHandler, false, 0, true);
			addEventListener(FlexEvent.ENTER, searchInput_changeHandler, false, 0, true);
			addEventListener(KeyboardEvent.KEY_UP, searchInput_keyUpHandler, false, 0, true);
			addEventListener(KeyboardEvent.KEY_DOWN, searchInput_keyDownHandler, false, 0, true);
			prompt = "Search";
		}
		
		private var lastSearchValue:String;
		private var aceEditorChanged:Boolean;
		private var _aceEditor:Object;
		
		/**
		 * Indicates if the user has the shift key held down
		 * */
		protected var shiftDown:Boolean;
		
		/**
		 * Options for searching. Update this value to change how searching is performed.
		 * See com.flexcapacitor.controls.AceEditor.find() for options you can use. 
		 * 
		 * @see com.flexcapacitor.controls.AceEditor.find()
		 * */
		public var options:Object = {skipCurrent:false};
		
		/**
		 * Results from the search
		 * */
		public var result:Object;
		
		/**
		 * Ace editor
		 * */
		public function get aceEditor():Object {
			return _aceEditor;
		}

		/**
		 * Set this value to the current ace editor
		 * @private
		 */
		public function set aceEditor(value:Object):void {
			if (_aceEditor!=value) {
				aceEditorChanged = true;
			}
			
			_aceEditor = value;
			invalidateProperties();
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (aceEditorChanged) {
				aceEditorChanged = false;
			}
		}
		
		protected function searchInput_changeHandler(event:Event):void {
			var searchText:String = text;

			// enter key pressed
			if (lastSearchValue==searchText) {
				
				if (searchText!="") {
					if (!shiftDown) {
						aceEditor.findNext(null);
					}
					else {
						aceEditor.findPrevious(null);
					}
				}
			}
			// change event
			else {
				result = aceEditor.find(text, options);
			}
			
			lastSearchValue = searchText;
		}
		
		protected function searchInput_keyDownHandler(event:KeyboardEvent):void {
			shiftDown = event.shiftKey;
		}
		
		protected function searchInput_keyUpHandler(event:KeyboardEvent):void {
			shiftDown = event.shiftKey;
		}
	}
}