package com.flexcapacitor.events
{
	import flash.events.Event;
	
	public class AceEvent extends Event
	{
		public function AceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Event dispatched when command is executed. 
		 * Only dispatches if listeners are added for it
		 * */
		public static const COMMAND:String = "command";
		
		/**
		 * Event data
		 * */
		public var data:Object;
	}
}