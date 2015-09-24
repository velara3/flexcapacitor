

package com.flexcapacitor.performance {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Used to populate UI components with values from the performance testing going on
	 * */
	public class PerformanceManager {
		
		public function PerformanceManager() {
			
		}
		
		/**
		 * How often to fetch the values from the performance test. Default 1 second.
		 * */
		public static var updateInterval:int = 1000;
		public static var interval:int;
		public static var timer:Timer;
		
		/**
		 * Used in for each loop
		 * */
		private static var item:Object;
		private static var itemIndex:int;
		private static var itemsLength:int;
		
		
		public static function start():void {
			if (timer==null) {
				timer = new Timer(updateInterval);
				timer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
			}
			
			if (timer.delay!=updateInterval) {
				timer.delay = updateInterval;
			}
			
			timer.start();
		}
		
		protected static function handleTimerEvent(event:TimerEvent):void {
			updateDisplay();
		}
		
		public static function stop():void {
			if (timer) {
				timer.stop();
			}
		}
		
		/**
		 * Updates any property on any object.
		 * Shows the tests duration, average and normalized values
		 * */
		public static function updateDisplay():void {
			itemIndex = 0;
			itemsLength = items.length;
			var out:Array = [];
			
			for (;itemIndex<itemsLength;itemIndex++) {
				var target:ProfileTarget = items[itemIndex];
				var test:ProfileTest = PerformanceMeter.getTest(target.name);
				if (test) {
					if (target.hasDuration) {
						out.push(test.duration);
					}
					if (target.hasAverage) {
						out.push(test.average);
					}
					if (target.hasNormal) {
						out.push(test.normalized);
					}
					
					target.setValue(out.join(","));
				}
			}
		}
		
		private static var _items:Vector.<ProfileTarget> = new Vector.<ProfileTarget>();
		public static function get items():Vector.<ProfileTarget> {
			return _items;
		}
		
		public static function set items(value:Vector.<ProfileTarget>):void {
			_items = value;
		}
		
		/**
		 * Add an object to set it's property on at regular intervals
		 * */
		public static function addItem(name:String, object:Object, property:String, duration:int = 500, tests:Array = null):void {
			var target:ProfileTarget = new ProfileTarget();
			target.name = name;
			target.target = object;
			target.property = property;
			target.tests = tests==null ? [ProfileTest.DURATION] : tests;
			target.duration = duration;
			
			items.push(target);
			
		}
		
	}
}