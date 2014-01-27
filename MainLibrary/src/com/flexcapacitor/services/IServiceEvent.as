
package com.flexcapacitor.services {
	import flash.events.Event;
	
	/**
	 * Interface for Service Event. 
	 * */
	public interface IServiceEvent {
		
		/**
		 * Call made to service
		 * */
		function get call():String;
		function set call(value:String):void;
		
		/**
		 * JSON string returned from server
		 * */
		function get text():String;
		function set text(value:String):void;
		
		/**
		 * Message giving status of call
		 * */
		function get message():String;
		function set message(value:String):void;
		
		/**
		 * Object converted from JSON string
		 * @see text
		 * */
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 * Object that contains the fault event
		 * */
		function get faultEvent():Event;
		function set faultEvent(value:Event):void;
	}
}