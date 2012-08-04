

package com.flexcapacitor.status.supportClasses {
	
	import flash.events.Event;
	
	/**
	 * Event for the Status Manager class
	 * */
	public class StatusEvent extends Event {
		
		/**
		 * Dispatched when the status message window is clicked. 
		 * If effects are applied this may be dispatched before the
		 * effect ends.
		 * */
		public static var CLICK:String = "click";
		
		/**
		 * Dispatched when the alert window is closed. 
		 * If effects are applied this may be dispatched before the
		 * effect ends.
		 * */
		public static var CLOSE:String = "close";

		
		public function StatusEvent(type:String="close", bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}