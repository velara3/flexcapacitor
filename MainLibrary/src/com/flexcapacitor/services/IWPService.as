
package com.flexcapacitor.services {
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	/**
	 * Interface for WPService
	 * */
	public interface IWPService extends IEventDispatcher {
		
		/**
		 * Save
		 * */
		function save(data:URLVariables = null):void;
		
		function get host():String;
		function set host(url:String):void
	}
}