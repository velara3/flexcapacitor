

/**
 * This class allows you to add events handlers to components using inline MXML tags
 * 
 * For example, 
 * 		<handlers:EventHandler eventName="click" target="{helloButton}">
 <handlers:actions>
 <actions:Alert message="Hello World"/>
 </handlers:actions>
 </handlers:EventHandler>
 * */
package com.flexcapacitor.handlers {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class EventHandlerBase extends EventDispatcher {
		
		/** 
		 * When enabled is true this handler is active
		 * when not enabled this handler is ignored
		 * */
		[Bindable]
		public var enabled:Boolean = true;
		
		/** 
		 * object used to store your custom data specific to current handler sequence
		 * */
		[Bindable]
		public var data:Object;
		
		/** 
		 * Name of handler used for readability. Non functional.
		 * */
		public var name:String;
		
		/** 
		 * Description of handler used for readability. Non functional.
		 * */
		public var description:String;
		
		
		public function EventHandlerBase(target:IEventDispatcher=null) {
			super(target);
		}
		
		
		
	}
}