
package com.flexcapacitor.services {
	import flash.net.URLVariables;
	
	/**
	 * Interface for WPService
	 * */
	public interface IWPService {
		
		/**
		 * Save
		 * */
		function save(data:URLVariables = null):void;
		
	}
}