package com.flexcapacitor.events
{
	import com.flexcapacitor.model.SourceData;
	
	import flash.events.Event;
	
	public class ImportEvent extends Event
	{
		public function ImportEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public var sourceData:SourceData;
		public var errorMessage:String;
		public var error:Error;
	}
}