package com.flexcapacitor.events
{
	import flash.events.Event;
	
	public class HTMLDragEvent extends Event
	{
		public function HTMLDragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Event data
		 * */
		public var data:Object;
	}
}

