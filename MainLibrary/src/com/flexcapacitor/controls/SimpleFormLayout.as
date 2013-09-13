
package com.flexcapacitor.controls {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Helps layout a form item label component.  
	 * Basically it makes sure the width is the same across all of the 
	 * form items. 
	 * */
	public class SimpleFormLayout extends EventDispatcher {
		
		public var items:Array = [];
		public var widestLabelWidth:int;
		
		public function SimpleFormLayout(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updateAllFormItems(formItem:FormItemComponent):void {
			
			if (items.indexOf(formItem)==-1) {
				items.push(formItem);
			}
			
			for (var i:int;i<items.length;i++) {
				var item:FormItemComponent = items[i];
				var width:int = item.textDisplay.width;
				
				if (width > widestLabelWidth) {
					widestLabelWidth = width;
				}
			}
			
			for (i=0;i<items.length;i++) {
				item = items[i];
				
				item.labelWidth = widestLabelWidth;
			}
		}
		
	}
}