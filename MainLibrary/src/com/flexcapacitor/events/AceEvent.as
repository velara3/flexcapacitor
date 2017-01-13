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
		 * Event data
		 * */
		public var data:Object;
	}
}