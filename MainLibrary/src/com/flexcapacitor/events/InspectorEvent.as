




package com.flexcapacitor.events {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class InspectorEvent extends Event {
		
		public static const CHANGE:String = "change";
		public static const HIGHLIGHT:String = "highlight";
		public static const SELECT:String = "select";
		
		public var targetItem:Object;
		
		public function InspectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, target:Object = null) {
			super(type, bubbles, cancelable);
			
			targetItem = target;
		}
		
		
		// override the inherited clone() method
		override public function clone():Event {
			return new InspectorEvent(type, bubbles, cancelable, targetItem);
		}
	}
}
