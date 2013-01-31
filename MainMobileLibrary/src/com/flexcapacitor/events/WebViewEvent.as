

package com.flexcapacitor.events {
	
	import flash.events.Event;
	
	/**
	 * Event from JavaScript result
	 * */
	public class WebViewEvent extends Event {
		
		public static const RESULT:String = "result";
		
		/**
		 * Value returned from location change event
		 * */
		public var result:String;
		
		/**
		 * Name of event specified in the result
		 * */
		public var event:String;
		
		/**
		 * Name of method that returned the result
		 * */
		public var method:String;
		
		/**
		 * If result is JSON string then this is the JSON object 
		 * */
		public var data:Object;
		
		
		public function WebViewEvent(eventType:String, bubbles:Boolean=false, cancelable:Boolean=false, event:String = null, method:String=null, result:String = null, data:Object = null) {
			this.event = event;
			this.method = method;
			this.result = result;
			this.data = data;
			
			super(eventType, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new WebViewEvent(type, bubbles, cancelable, event, method, result, data);
		}
		
		
	}
}