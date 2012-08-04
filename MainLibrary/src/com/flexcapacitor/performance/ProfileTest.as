

package com.flexcapacitor.performance {
	import flash.utils.getTimer;
	
	
	public class ProfileTest {
		
		
		/**
		 * Creates a class to hold our values.
		 * May not actually hold our values until we parse the data
		 * */
		public function ProfileTest(name:String=null) {
			if (name) {
				name = name;
			}
			
			startTime = getTimer(); // the time this test was created
		}
		
		private var index:int;
		private var maximumValue:int;
		private var minimumValue:int;
		private var length:int;
		protected var offset:int;
		protected var offsetStart:int;
		protected var offsetEnd:int;
		
		public var normalize:Boolean;
		
		/**
		 * Name used to identify this test
		 * We do not verify if another test has the same name
		 * */
		public var name:String;
		
		/**
		 * Description if you need it
		 * */
		public var description:String;
		
		/**
		 * Gets the minimum value 
		 * This call is calculated
		 * */
		public function get minimum():int {
			offsetStart = getTimer();
			
			index = 0;
			length = timestamps.length;
			
			throw new Error("Test not done");
			for (;index<length;index++) { 
				if (timestamps[index].duration<minimumValue) {
					minimumValue = timestamps[index].duration;
				}
			}
			
			offsetEnd = getTimer() - offsetStart;
			// add to offset
			
			
			return minimumValue;
		}
		
		
		/**
		 * The maximum value from all items sampled
		 * This value is calculated on each call
		 * */
		public function get maximum():int {
			throw new Error("Test not done");
			return maximumValue;
		}
		
		/**
		 * The duration of this test in milliseconds. 
		 * */
		public function get duration():int {
			//return getTimer() - startTime;
			return endTime - startTime;
		}
		
		/**
		 * Average duration from all items
		 * This value is calculated on each call
		 * */
		public function get average():Number {
			var value:int;
			index = 0;
			length = timestamps.length;
			
			for (;index<length;index++) {
				value = value + timestamps[index].duration;
			}
			
			return value/length;
		}
		
		private var _multitest:Boolean;
		public function get multitest():Boolean {
			return _multitest;
		}
		
		public function set multitest(value:Boolean):void {
			_multitest = value;
		}
		
		/**
		 * Contains all the timestamps. Used when calling this test multiple times
		 * */
		public var timestamps:Vector.<Timestamp>;
		
		public function get timestampsArray():Array {
			var array:Array = [];
			var length:uint = timestamps.length;
			
			for(var i:int = 0; i < length; i++){
				array[i] = timestamps[i];
			}
			return array;
		}
		
		/**
		 * Start time of test. Use duration to get the length since the start of the test
		 * */
		public var startTime:int;
		
		/**
		 * End time of test. Use duration to get the length since the start of the test
		 * */
		public var endTime:int;
		
		/**
		 * When start is called on this test but the last test has not been stopped. This counts the number of times that has happened. 
		 * */
		public var rogueStarts:int;
		
		/**
		 * When stop is called on this test but the last test has not been started. This counts the number of times that has happened. 
		 * */
		public var rogueStops:int;
		
		/**
		 * Called when the test has started. 
		 * */
		public var testStarted:Boolean;
		
		/**
		 * If a test has started and start is called again but stop has not been called then if this is true an error is thrown.
		 * @see rogueStarts
		 * @see rogueStops
		 * */
		public var testForErrors:Boolean;
		
		
		public function start():void {
			
			if (testStarted) {
				rogueStarts++;
				
				if (testForErrors) {
					throw new Error("Start was called on this test (called twice) but stop has not been called yet.");
				}
			}
			
			startTime = getTimer();
			testStarted = true;
			
		}
		
		public function stop():void {
			
			if (!testStarted) {
				rogueStops++;
				
				if (testForErrors) {
					throw new Error("Stop was called on this test (called twice) but start has not been called yet.");
				}
			}
			
			endTime = getTimer();
			testStarted = false;
			
		}
	}
}