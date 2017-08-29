package com.flexcapacitor.events {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BitmapDataEvent extends Event {
		
		public function BitmapDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public static const BITMAP_DATA_CHANGED:String = "bitmapDataChanged";
		
		public var bitmapData:BitmapData;
	}
}