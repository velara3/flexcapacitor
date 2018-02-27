package com.flexcapacitor.controls
{
	import flash.events.KeyboardEvent;
	
	import spark.components.List;
	
	/**
	 * A list that has an option to turn keyboard events on or off
	 **/
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
		
		override protected function keyUpHandler(event:KeyboardEvent):void {
			if (enableKeyboardHandling) {
				super.keyUpHandler(event);
			}
		}
	}
}