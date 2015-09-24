package com.flexcapacitor.controls
{
	import flash.events.Event;
	
	import mx.controls.ColorPicker;
	import mx.controls.colorPickerClasses.SwatchPanel;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.events.TextOperationEvent;
	
	use namespace mx_internal;
	
	/**
	 * Fixes an issue where pasting color values was truncated. Does not seem to work 
	 * when not using FTE in MX components compiler argument.
	 * */
	public class ColorPicker extends mx.controls.ColorPicker
	{
		public function ColorPicker()
		{
			super();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var swatch:SwatchPanel = getDropdown();
			if (!swatch.textInput.hasEventListener(FlexEvent.CHANGING)) {
				swatch.textInput.addEventListener(FlexEvent.CHANGING, changingEventHandler);
			}
		}
		
		protected function changingEventHandler(event:Event):void
		{
			// set it to max characters of 8
			// allow room for "123456", "#234567", "0x345678" before paste truncates it
			// change event handler in SwatchPanel will set it back to 8, 7 or 6 max chars
			if (event is TextOperationEvent) {
				dropdown.textInput.maxChars = 8;
				//text = TextOperationEvent(event).operation.textFlow.getText();
				//trace("changing to: " + text);
			}
		}
	}
}