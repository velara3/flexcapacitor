

package com.flexcapacitor.performance {
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Used to populate UI components with values from the performance testing going on
	 * */
	public class PerformanceManager {
		
		/**
		 * How often to fetch the values from the performance test
		 * */
		public var updateInterval:int = 1000;
		public var interval:int;
		
		public function PerformanceManager() {
			
		}
		
		public function start():void {
			interval = setInterval(updateDisplay, updateInterval);
		}
		
		public function stop():void {
			clearInterval(interval);
		}
		
		/**
		 * Used in for each loop
		 * */
		private var item:Object;
		private var itemIndex:int;
		private var itemsLength:int;
		
		/**
		 * Updates any property on any object
		 * */
		public function updateDisplay():void {
			itemIndex = 0;
			itemsLength = items.length;
			
			for (;itemIndex<itemsLength;itemIndex++) {
				
			}
		}
		
		private var _items:Vector.<Object>;
		public function get items():Vector.<Object> {
			return _items;
		}
		
		public function set items(value:Vector.<Object>):void {
			_items = value;
		}
	}
}