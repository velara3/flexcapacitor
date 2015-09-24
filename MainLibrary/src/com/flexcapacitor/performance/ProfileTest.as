

package com.flexcapacitor.performance {
	import flash.utils.getTimer;
	
	
	/**
	 * A class to hold our values profile data.
	 * Properties may not actually hold our values until we parse the data<br/><br/>
	 * 
	 * Usage:
<pre>
var length:int = 1000;
for (var i:int;i<length;i++) {
	PerformanceMeter.traceMessages = false;
	PerformanceMeter.start("test", true);
	// do something
	PerformanceMeter.stop("test");
}
var testData:ProfileTest = PerformanceMeter.getTest("test");
trace("Average duration: " + testData.average);
trace("Fastest time: " + testData.minimum);
trace("Slowest time: " + testData.maximum);
</pre>
	 * */
	public class ProfileTest {
		
		
		/**
		 * Creates a class to hold our values.
		 * Properties may not actually hold our values until we parse the data.
		 * */
		public function ProfileTest(name:String=null) {
			if (name) {
				name = name;
			}
			
			startTime = getTimer(); // the time this test was created
		}
		
		private var maximumValue:int;
		private var minimumValue:int;

		protected var offset:int;
		protected var offsetStart:int;
		protected var offsetEnd:int;
		
		private var _normalize:int;
		
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
		 * Normalized duration of test for multiple test calls. 
		 * We loop through and remove one instance of the max value and 
		 * one instance of the min value from the timestamps array and then 
		 * average the rest. You must run more than 2 tests to get 
		 * a normalized value.
		 * */
		public function get normalized():int {
			var min:int = minimum;
			var max:int = maximum;
			var minRemoved:Boolean;
			var maxRemoved:Boolean;
			var ave:int;
			var timestampLength:int = timestamps.length;
			var index:int;
			
			// You must have more than 2 tests to something better than the average
			if (timestampLength<3) {
				maxRemoved = true;
				minRemoved = true;
			}
			
			// loop through and remove one instance of max value and min value
			for (;index<timestampLength;index++) { 
				if (timestamps[index].duration==min && !minRemoved) {
					minRemoved = true;
					continue;
				}
				
				if (timestamps[index].duration==max && !maxRemoved) {
					minRemoved = true;
					continue;
				}
				
				ave = ave + timestamps[index].duration;
			}
			
			return ave/timestampLength;
		}
		
		/**
		 * Gets the minimum value 
		 * This call is calculated
		 * */
		public function get minimum():int {
			offsetStart = getTimer();
			
			var index:int;
			var timestampLength:int = timestamps.length;
			minimumValue = length ? uint.MAX_VALUE : 0;
			
			for (;index<timestampLength;index++) { 
				if (timestamps[index].duration<minimumValue) {
					minimumValue = timestamps[index].duration;
				}
			}
			
			// add to offset
			offsetEnd = getTimer() - offsetStart;
			
			
			return minimumValue;
		}
		
		
		/**
		 * The maximum value from all items sampled
		 * This value is calculated on each call
		 * */
		public function get maximum():int {
			offsetStart = getTimer();
			
			var index:int;
			var timestampLength:int = timestamps.length;
			maximumValue = length ? uint.MIN_VALUE : 0;
			
			for (;index<timestampLength;index++) { 
				if (timestamps[index].duration>maximumValue) {
					maximumValue = timestamps[index].duration;
				}
			}
			
			offsetEnd = getTimer() - offsetStart;
			// add to offset
			
			
			return maximumValue;
		}
		
		/**
		 * The duration of this test in milliseconds. 
		 * If you are tracking multiple calls then this is the 
		 * duration of your last call. 
		 * */
		public function get duration():int {
			//return getTimer() - startTime;
			return endTime - startTime;
		}
		
		/**
		 * Average duration from all items
		 * This value is calculated on each call
		 * */
		public function get average():int {
			var value:int;
			var index:int;
			
			var timestampsLength:int = timestamps.length;
			
			for (;index<timestampsLength;index++) {
				value = value + timestamps[index].duration;
			}
			
			return value/timestampsLength;
		}
		
		public function get multitest():Boolean {
			return _multitest;
		}
		
		/**
		 * If set to true then multiple tests scores are recorded
		 * */		
		public function set multitest(value:Boolean):void {
			_multitest = value;
		}
		private var _multitest:Boolean;
		
		/**
		 * Contains a vector all the timestamps of type Timestamp. 
		 * Used when calling this test multiple times.
		 * @see timestampsArray
		 * */
		public var timestamps:Vector.<Timestamp>;
		
		/**
		 * Returns an array of Timestamps as opposed to a vector of Timestamps
		 * @see timestamps
		 * */
		public function get timestampsArray():Array {
			var array:Array = [];
			var timestampLength:uint = timestamps.length;
			
			for(var i:int = 0; i < timestampLength; i++){
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
		
		/**
		 * If true then does not trace out data when calling to string
		 * */
		public var buffer:Boolean;
		public static var DURATION:uint = 0;
		public static var AVERAGE:uint = 1;
		public static var NORMAL:uint = 2;
		
		/**
		 * Starts the test
		 * */
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
		
		/**
		 * Stops the test
		 * */
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
		
		/**
		 * Clears all data from the test
		 * */
		public function clear():void {
			stop();
			
			rogueStarts = 0;
			rogueStops = 0;
			startTime = 0;
			endTime = 0;
			testStarted = false;
			timestamps = new Vector.<Timestamp>;
			
		}

		/**
		 * Number of timestamps
		 * */
		public function get length():int {
			if (timestamps) {
				return timestamps.length;
			}
			return 0;
		}
		
		/**
		 * Returns the data in the format of "name:duration in milliseconds"
		 * */
		public function toString():String {
			if (multitest) {
				return name + ":" + normalized;
			}
			return name + ":" + duration;
		}
		
		/**
		 * Returns the data in the format of "Test Name:100ms" or
		 * "Test Name: Last:100ms, Average:90ms, Normalized:90ms";
		 * */
		public function toStringAll():String {
			if (multitest) {
				return name + ": " + "Tests:" + length + " Last duration:" + duration + "ms Average:" + average + "ms Normalized:" + normalized + "ms";
			}
			return name + ":" + duration;
		}
	}
}