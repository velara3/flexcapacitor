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
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
		}
	}
}