package com.flexcapacitor.events
{
	import com.flexcapacitor.model.HTMLClipboardData;
	
	import flash.events.Event;
	
	public class HTMLClipboardEvent extends Event
	{
		public function HTMLClipboardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Event data
		 * */
		public var data:HTMLClipboardData;
	}
}

