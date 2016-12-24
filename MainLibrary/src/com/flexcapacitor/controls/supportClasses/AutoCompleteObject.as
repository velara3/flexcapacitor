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
		 * Unknown
		 * */
		public var className:String;
		
		public var matchMask:Object;
		public var exactMatch:Boolean;
		public var type:String;
		
	}
}