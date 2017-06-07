package com.flexcapacitor.events
{
	import com.flexcapacitor.model.HTMLDragData;
	
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
		public var data:HTMLDragData;
		public var altKey:Boolean;
		public var commandKey:Boolean;
		public var shiftKey:Boolean;
		public var controlKey:Boolean;
	}
}

