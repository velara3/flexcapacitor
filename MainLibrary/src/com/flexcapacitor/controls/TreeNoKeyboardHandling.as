package com.flexcapacitor.controls
{
	import flash.events.KeyboardEvent;
	
	import mx.controls.Tree;
	
	public class TreeNoKeyboardHandling extends Tree
	{
		public function TreeNoKeyboardHandling()
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