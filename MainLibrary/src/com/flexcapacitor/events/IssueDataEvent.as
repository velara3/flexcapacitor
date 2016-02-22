package com.flexcapacitor.events
{
	import com.flexcapacitor.model.IssueData;
	
	import flash.events.Event;
	
	public class IssueDataEvent extends Event
	{
		public function IssueDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public var label:String;
		public var description:String;
		public var issueData:IssueData;
	}
}