

package com.flexcapacitor.performance {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 * Track the performance of your code by timing it. 
	 * You can track the time a block of code runs by calling start 
	 * and stop. When you call stop the time that has elapsed is 
	 * traced to the console. <br/><br/>
	 * 
	 * To increase the column width set the markNameMaxWidth. <br/><br/>
	 * 
	 Usage:
<pre>
 PerformanceMeter.start("test");
 // do something
 PerformanceMeter.stop("test"); // outputs to console 10ms
</pre>
	 * You can use the mark method to track the time that has elapsed since the 
	 * last call to mark. 
	 * Usage:
<pre>
 PerformanceMeter.mark("before bitmap resampling", true); // setting true resets the running timer
 // code that runs for 10 milliseconds
 PerformanceMeter.mark("after bitmap resampling"); // traces "before bitmap resampling: 10ms"
 // more code that takes 5 milliseconds
 PerformanceMeter.mark("after more code"); // traces "after bitmap resampling: 5ms"
 // more code 
 PerformanceMeter.mark("end of method"); // traces "after more code: 5ms"
</pre>
	 * 
	 Usage:
		 * <b>Simple example:</b>
<pre>
PerformanceMeter.start("test");
// do something
PerformanceMeter.stop("test"); // outputs to console 10ms
</pre>
		 * 
		 * <b>Advanced example (multiple tests):</b>
<pre>
PerformanceMeter.timestampPoolCount = 1000;
PerformanceMeter.traceMessages = false;
 * 
var testData:ProfileTest;
var count:int = 1000;

for (var i:int;i&lt;count;i++) {
  PerformanceMeter.start("test", true);
  // do something
  PerformanceMeter.stop("test");
}

testData = PerformanceMeter.getTest("test");

// test data summary
trace("Average duration: " + testData.average);
trace("Normalized duration: " + testData.normalize);
trace("Fastest time: " + testData.minimum);
trace("Slowest time: " + testData.maximum);
</pre>
	 * 
	 */
	public class PerformanceMeter {
		
		
		public function PerformanceMeter() {
			// this doesn't get called
		}
		
		/**
		 * Create Test instances before hand so we are not creating them during testing
		 * */
		private static var pool:Vector.<ProfileTest> = new Vector.<ProfileTest>(poolCount);
		
		/**
		 * Temporarily holds the value for the start time of a method
		 * */
		private static var timedValue:uint;
		private static var dictionary:Dictionary;
		private static var selectedTest:ProfileTest;
		private static var privateTest:ProfileTest;
		private static var _poolCount:int = 10;
		private static var _tests:Vector.<ProfileTest>;
		private static var lastTime:int;
		private static var lastMarkDifference:int;
		private static var lastMarkText:String;
		private static var supportMultitest:Boolean;
		private static var _poolTimestamps:Vector.<Timestamp>;
		private static var privateTimestamp:Timestamp;
		
		/**
		 * Show the time stamp next to mark output 
		 * 
<pre>
PerformanceMeter.mark("Before xml validation", true);
isValid = XMLUtils.isValidXML(code);
PerformanceMeter.mark("After xml validation");

// output when enabled

Performance Mark   Before xml validation     : 36058ms
Performance Mark   After xml validation      : 36059ms +0

// disabled
Performance Mark   Before xml validation     : 
Performance Mark   After xml validation      : +0
</pre>
		 * 
		 * */
		private static var showTimestamp:Boolean;
		/**
		 * Number of timestamps to create before hand for multiple test
		 * */
		public static var timestampPoolCount:int = 1000;
		
		/**
		 * Include time info. Default is false. If true the output resembles the following:<br/><br/>
		 * 
		 * Performance Test   setTargetTest             : 1172421:1172553 132ms<br/><br/>
		 * 
		 * Otherwise it looks similiar to this:<br/><br/>
		 * 
		 * Performance Test   setTargetTest             : 132ms
		 * */
		public static var includeTimeInfo:Boolean = false;
		
		private static var multicallInitialized:Boolean;
		

		public static function get bufferOutput():Boolean {
			return _bufferOutput;
		}

		/**
		 * When set to true then whatever was going to be traced to the console
		 * is instead added to the bufferedData array.
		 * If you set this to false the bufferedData array is erased.
		 * */
		public static function set bufferOutput(value:Boolean):void {
			_bufferOutput = value;
			if (!value) {
				bufferedData = [];
			}
		}
		
		private static var _bufferOutput:Boolean;

		
		/**
		 * The first test is usually 2 to 4 times longer than subsequent tests.
		 * If this is true then the first test is not recorded.
		 * */
		public static var removeFirstTest:Boolean;
		
		public static function get timestampPool():Vector.<Timestamp> {
			return _poolTimestamps;
		}

		public static function set timestampPool(value:Vector.<Timestamp>):void {
			_poolTimestamps = value;
		}

		/**
		 * Amount of items to pre create
		 * */
		public static function get poolCount():int {
			return _poolCount;
		}

		/**
		 * @private
		 */
		public static function set poolCount(value:int):void {
			if (value || pool==null || pool.length<value) {
				//precacheTests();
				// you need to call initialize to change the pool count
			}
			_poolCount = value;
		}

		public static function get tests():Vector.<ProfileTest> {
			return _tests;
		}
		
		public static function set tests(value:Vector.<ProfileTest>):void {
			_tests = value;
		}
		
		/**
		 * Indicates if the initialize method has been called
		 * */
		public static var initialized:Boolean;
		
		/**
		 * Trace to console. If set to false nothing will be traced to the console
		 * Check the timestamps property
		 * @see timestamps
		 * */
		public static var traceMessages:Boolean = true;
		
		/**
		 * The timestamp of the last time mark
		 * */
		public static var lastMark:int;
		
		/**
		 * Sets the minimum number of characters in for the test name in the trace console. Used for the alignment of values in the console window.  
		 * */
		public static var markNameMaxWidth:int = 26;
		
		/**
		 * Text to display in the console before a performance mark test result.
		 * */
		public static var performanceMarkText:String = "Performance Mark   ";
		
		public static var performanceTestText:String = "Performance Test   ";
		
		/**
		 * If buffer output is set to true then whatever was going to be traced to the console
		 * is instead added to this buffered array.
		 * If you set bufferOutput to false this array is erased.
		 * @see bufferOutput
		 * */
		public static var bufferedData:Array = [];
		
		
		/**
		 * Creates a pool of Test and Timestamps and initializes instance variables
		 * Automatically called the first time start is called if not initialized before
		 * then. 
		 * */
		public static function initialize(poolCount:int=NaN, multitest:Boolean=false):void {
			if (initialized) return;
			if (!isNaN(poolCount)) poolCount = poolCount;
			if (multitest) supportMultitest = true;
			
			createPool();
			createDictionary();
			initialized = true;
		}
		
		private static function createDictionary():void {
			dictionary = new Dictionary(true);
		}
		
		/**
		 * Creates instances ahead of time so we aren't creating them during a test
		 * even though the test doesn't get the time until after it's created an instance
		 * */
		private static function createPool():void {
			var items:Vector.<ProfileTest>;
			var index:int;
			
			pool = new Vector.<ProfileTest>(poolCount);
			
			for (;index<poolCount;index++) {
				pool[index] = new ProfileTest();
			}
			
			if (supportMultitest) {
				initializeMulticall();
			}
			
		}
		
		/**
		 * Creates a test with the name specified. If multicall is true then when
		 * the test is created it creates a timestamp in the test's timestamps array
		 * each time a call start is called on the test with the same name.<br/><br/>
		 * 
		 * <b>Simple example:</b>
<pre>
PerformanceMeter.start("test");
// do something
PerformanceMeter.stop("test"); // outputs to console 10ms
</pre>
		 * 
		 * <b>Advanced example (multiple tests):</b>
<pre>
PerformanceMeter.timestampPoolCount = 1000;
PerformanceMeter.traceMessages = false;
 * 
var testData:ProfileTest;
var count:int = 1000;

for (var i:int;i&lt;count;i++) {
  PerformanceMeter.start("test", true);
  // do something
  PerformanceMeter.stop("test");
}

testData = PerformanceMeter.getTest("test");

// test data summary
trace("Average duration: " + testData.average);
trace("Normalized duration: " + testData.normalize);
trace("Fastest time: " + testData.minimum);
trace("Slowest time: " + testData.maximum);
</pre>
		 * 
		 * @see #stop()
		 * @see #mark()
		 * */
		public static function start(name:String, multicall:Boolean=true, bufferOutput:Boolean = false):void {
			if (!initialized) initialize();
			if (multicall && !multicallInitialized) initializeMulticall();
			var test:ProfileTest = dictionary[name];
			
			// if test exists
			if (!test) {
				test = dictionary[name] = getAvailableTest(name, multicall, bufferOutput);
			}
			
			test.start();
		}
		
		/**
		 * Clears all data from a profile test
		 * */
		public static function clear(name:String):void {
			var test:ProfileTest = dictionary[name];
			
			// if test exists
			if (test) {
				test.clear();
			}
			else {
				throw new Error("Test cannot be cleared because it is not found.");
			}
			
		}
		
		private static function initializeMulticall():void {
			timestampPool = new Vector.<Timestamp>(timestampPoolCount);
			
			for (var i:int;i<timestampPoolCount;i++) {
				timestampPool[i] = new Timestamp();
			}
			
			multicallInitialized = true;
		}
		
		/**
		 * Returns the duration from the start call to the stop call.
		 * If trace messages is true and the test is not set to buffer 
		 * then traces a message to the console. The test can be set to
		 * buffer by setting a parameter when you called start().
		 * 
		 * Usage:
<pre>
PerformanceMeter.start("test");
// do something
PerformanceMeter.stop("test"); // outputs to console 10ms
</pre>
		 * 
		 * @see #start()
		 * @see #mark()
		 * */
		public static function stop(name:String, traceBufferedOut:Boolean = false):uint {
			var string:String;
			
			// check if item is in dictionary
			if (dictionary && name in dictionary) {
				selectedTest = dictionary[name];
			}
			else {
				trace("Performance Meter: No test named " + name);
				return 0;
			}
			
			selectedTest.endTime = getTimer();
			
			if (selectedTest.multitest) {
				selectedTest.timestamps.push(getAvailableTimestamp(selectedTest.startTime, selectedTest.endTime));
			}
			
			if (((traceMessages || bufferOutput) && !selectedTest.buffer)
				|| traceBufferedOut) {
				var timeInfo:String = includeTimeInfo ? selectedTest.startTime + ":"+ selectedTest.endTime + " " : "";
				string = performanceTestText + padString(name, markNameMaxWidth) + ": " + timeInfo + selectedTest.duration + "ms";
			}
			
			if (traceMessages && traceBufferedOut && !selectedTest.buffer) {
				trace(string);
			}
			
			if (bufferOutput && !selectedTest.buffer) {
				bufferedData.push(string);
			}
			
			return selectedTest.duration;
		}
		
		/**
		 * Get's a pre created Test instance
		 * */
		private static function getAvailableTest(name:String, multicall:Boolean, buffer:Boolean):ProfileTest {
			
			if (pool.length) {
				privateTest = pool.pop();
			}
			else {
				//trace("PerformanceMeter: There are not enough cached items. Creating new item");
				privateTest = new ProfileTest();
			}
			
			if (multicall) {
				privateTest.timestamps = new Vector.<Timestamp>();
			}
			
			privateTest.multitest = multicall;
			privateTest.buffer = buffer;
			privateTest.name = name;
			privateTest.startTime = getTimer();
			
			return privateTest;
		}
		
		/**
		 * Get's a pre created Test instance
		 * */
		private static function getAvailableTimestamp(startTime:uint, endTime:uint):Timestamp {
			
			if (timestampPool.length) {
				privateTimestamp = timestampPool.pop();
			}
			else {
				//trace("PerformanceMeter: There are not enough cached Timestamp items. Creating new Timestamp");
				privateTimestamp = new Timestamp();
			}
			
			privateTimestamp.startTime = startTime;
			privateTimestamp.endTime = endTime;
			privateTimestamp.duration = endTime - startTime;
			
			return privateTimestamp;
		}
		
		/**
		 * Get test by name
		 * */
		public static function getTest(name:String):ProfileTest {
			if (dictionary && name in dictionary) {
				return dictionary[name];
			}
			return null;
		}
		
		/**
		 * Marks a point in time with the current value of the getTimer count. 
		 * Also shows the difference since last mark.
		 * 
		 * 
		 * */
		public static function mark(name:String="", resetRunningTimer:Boolean = false):void {
			lastTime = getTimer();
			lastMarkDifference = lastMark==0 || resetRunningTimer ? 0 : lastTime - lastMark;
			
			if (traceMessages) {
				if (showTimestamp) {
					lastMarkText = performanceMarkText + padString(name, markNameMaxWidth) + ": " + lastTime + "ms";
				}
				else {
					lastMarkText = performanceMarkText + padString(name, markNameMaxWidth) + ":"; 
				}
				
				lastMarkText += lastMark==0 || resetRunningTimer ? "" : " " + "+" + lastMarkDifference;
				lastMark = getTimer();
				
				if (traceMessages) {
					trace(lastMarkText);
				}
				
				if (bufferOutput) {
					bufferedData.push(lastMarkText);
				}
			}
		}
		
		/**
		 * Traces out buffered output
		 * */
		public static function traceBufferedOutput():void {
			trace(bufferedData.join("\n"));
		}
		
		/**
		 * Trace multitest data
		 * */
		public static function traceMultitest(name:String):void {
			var test:ProfileTest = getTest(name);
			trace(test.toStringAll());
		}
		
		/**
		 * Adds spaces to a String. 
		 * */
		private static function padString(value:String, length:int):String {
			length = length - value.length;
			
			for (var i:int;i<length;i++) {
				value += " ";
			}
			
			if (length<0) {
				value = value.substr(0, length);
			}
			return value;
		}
	}
}