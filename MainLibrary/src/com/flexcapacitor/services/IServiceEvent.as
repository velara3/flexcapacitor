
package com.flexcapacitor.services {
	import flash.events.Event;
	
	/**
	 * Interface for Service Event. 
	 * */
	public interface IServiceEvent {
		
		/**
		 * String returned from server
		 * */
		function get text():String;
		function set text(value:String):void;
		
		/**
		 * Object returned from the server
		 * @see text
		 * */
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 * Object that contains the fault event
		 * */
		function get faultEvent():Event;
		function set faultEvent(value:Event):void;
		
		/**
		 * Object that contains the result event
		 * */
		function get resultEvent():Event;
		function set resultEvent(value:Event):void;
	}
}