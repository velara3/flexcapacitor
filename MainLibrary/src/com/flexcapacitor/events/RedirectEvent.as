package com.flexcapacitor.events
{
	import flash.events.Event;
	
	public class RedirectEvent extends Event
	{
		public function RedirectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const REDIRECTING:String = "redirecting";
		public static const REDIRECTION_RECOMMENDATION:String = "redirectionRecommendation";
		
		public var redirectRecommended:Boolean;
		public var protocol:String;
	}
}