
package com.flexcapacitor.services {
	import flash.events.Event;
	
	/**
	 * Interface for Service Event. 
	 * */
	public interface IWPServiceEvent extends IServiceEvent {
		
		/**
		 * Call made to service
		 * */
		function get call():String;
		function set call(value:String):void;
		
		/**
		 * Message giving status of call
		 * */
		function get message():String;
		function set message(value:String):void;
		
	}
}