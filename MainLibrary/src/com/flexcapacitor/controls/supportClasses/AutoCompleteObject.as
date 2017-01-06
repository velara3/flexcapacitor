package com.flexcapacitor.controls.supportClasses{
	
	/**
	 * Value object used for each item in auto completion in Ace Editor auto complete.
	 * Autocomplete allows an array of strings or an array of objects. 
	 * 
	 * Unknown but possibly related properties
	 * completion-highlight
	 * matchMask
	 * className
	 * exactMatch
	 * 
	 * ReferenceError: Error #1056: 
	 * Cannot create property exactMatch on com.flexcapacitor.controls.supportClasses.AutoCompleteObject.
	 * Making class dynamic so it doesn't break on future updates.
	 * */
	public dynamic class AutoCompleteObject {
		
		public function AutoCompleteObject(name:String = null, metadata:String = null) {
			this.value = name;
			meta = metadata;
		}
		
		public static var SNIPPET:String = "snippet";
		public static var ATTRIBUTE_SNIPPET:String = "attributeSnippet";
		
		/**
		 * Value written upon auto completion
		 * 
		 * @see #caption
		 * */
		public var value:String;
		
		/**
		 * The caption is what is shown in the auto completion list as you type the value
		 * 
		 * @see #value
		 * */
		public var caption:String;
		
		/**
		 * The score is a reason unknown 
		 * */
		public var score:String;
		
		/**
		 * What is shown to the right of the value or caption if set in the auto complete list
		 * 
		 * Option: "rightAlignedText"
		 * */
		public var meta:String;
		
		/**
		 * NA
		 * */
		public var className:String;
		
		/**
		 * Set to true when match is close when comparing same text?
		 * */
		public var matchMask:Object;
		
		/**
		 * Set to true when match is exact when comparing?
		 * */
		public var exactMatch:Boolean;
		
		/**
		 * Type of autocomplete type. One type is snippet. I don't know about others. 
		 * */
		public var type:String;
		
		/**
		 * Documentation to show in things like autocomplete tool tip 
		 * */
		public var docHTML:String;
		
		/**
		 * Snippet support. When you autocomplete you can run a snippet.<br/><br/>
		 * 
		 * It lets you insert any text and move the cursor to locations 
		 * or phrases as you tab. When you've tabbed through all of the 
		 * tokens or move the cursor outside of the snippet
		 *  you are returned to normal editing mode.<br/><br/>
		 * 
		 * Format: <br/>
		 *
		 * ${1:first text to insert and select on tab}
		 * ${2:second text to insert and tab to}
		 * ${3} - in this case the cursor is placed here but no text is selected
		 * 
		 * "Hello. My name is ${1}. I write code in ${2:ActionScript3}";
		 *
<pre>
var autoCompleteObject = new AutoCompleteObject();
autoCompleteObject.value = "Greetings";
autoCompleteObject.type = "snippet";
autoCompleteObject.snippet = "Hello. My name is ${1}. I write code in ${2:ActionScript3}";; // autocompletes an XML attribute=""
</pre> 
		 * 
		 * */
		public var snippet:String;
		
	}
}