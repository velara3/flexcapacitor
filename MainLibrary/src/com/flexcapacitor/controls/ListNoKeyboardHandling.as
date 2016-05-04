package com.flexcapacitor.controls
{
	import flash.events.KeyboardEvent;
	
	import spark.components.List;
	
	public class ListNoKeyboardHandling extends List
	{
		public function ListNoKeyboardHandling()
		{
			super();
		}
		
		public var enableKeyboardHandling:Boolean;
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			if (enableKeyboardHandling) {
				super.keyDownHandler(event);
			}
		}
	}
}