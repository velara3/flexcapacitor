

package com.flexcapacitor.prompt.supportClasses {
	
	import flash.events.Event;
	
	
	public class PromptEvent extends Event {
		
		/**
		 * Name of event when a button is clicked or the 
		 * prompt dialog is closed
		 * */
		public static var PROMPT:String = "prompt";
		
		/**
		 * Dispatched when the prompt window is closed. 
		 * If effects are applied this may be dispatched before the
		 * effect ends.
		 * */
		public static var CLOSE:String = "close";
		
		/**
		 * The name of the button that was pressed
		 * */
		public static var OK:String = "ok";
		
		/**
		 * The name of the button that was pressed
		 * */
		public static var NO:String = "no";
		
		/**
		 * The name of the button that was pressed
		 * */
		public static var YES:String = "yes";
		
		/**
		 * The name of the button that was pressed
		 * */
		public static var CANCEL:String = "cancel";
		
		/**
		 * Contains the name of the button that was pressed. Use the constants 
		 * on this class.
		 * */
		public var buttonPressed:String;
		
		public function PromptEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		// override the inherited clone() method
		override public function clone():Event {
			return new PromptEvent(type, bubbles, cancelable);
		}
	}
}