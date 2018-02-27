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
		
		override protected function createChildren():void {
			super.createChildren();
			/*
			var eventListenerNeeded:Boolean;
			
			if (textInput==null) {
				eventListenerNeeded = true;
			}
			
			super.createChildren();
			
			var swatch:SwatchPanel = getDropdown();
			if (!swatch.textInput.hasEventListener(FlexEvent.CHANGING)) {
				swatch.textInput.addEventListener(FlexEvent.CHANGING, changingEventHandler);
			}
			
			if (eventListenerNeeded && swatch.textInput) {
				swatch.textInput.addEventListener(ClearButtonTextInput.CLEAR_TEXT, clearTextHandler, false, 0, true);
			}
			*/
		}
		
		override mx_internal function getDropdown():SwatchPanel {
			var swatch:SwatchPanel = super.getDropdown();
			
			if (textInput) {
				
				if (!swatch.textInput.hasEventListener(FlexEvent.CHANGING)) {
					swatch.textInput.addEventListener(FlexEvent.CHANGING, changingEventHandler);
				}
				
				if (swatch.textInput) {
					swatch.textInput.addEventListener(ClearButtonTextInput.CLEAR_TEXT, clearTextHandler, false, 0, true);
				}
			}
			
			return swatch;
		}
		
		/**
		 * Clear button pressed. Restore original selected color.
		 * */
		public function clearTextHandler(event:Event):void {
			
			dropdown.selectedIndex = selectedIndex;
			dropdown.selectedColor = selectedColor;
			dropdown.textInput.text = rgbToHex(selectedColor);
		}
		
		/**
		 *  @private
		 *  Convert RGB offset to Hex.
		 */    
		public function rgbToHex(color:uint):String {
			// Find hex number in the RGB offset
			var colorInHex:String = color.toString(16);
			var c:String = "00000" + colorInHex;
			var e:int = c.length;
			c = c.substring(e - 6, e);
			return c.toUpperCase();
		}
		
		protected function changingEventHandler(event:Event):void {
			// set it to max characters of 8
			// allow room for "123456", "#234567", "0x345678" before paste truncates it
			// change event handler in SwatchPanel will set it back to 8, 7 or 6 max chars
			if (event is TextOperationEvent) {
				dropdown.textInput.maxChars = 8;
			}
		}
	}
}