

package com.flexcapacitor.performance {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 
	 Usage: 
	 PerformanceMeter.start("test");
	 // do something
	 PerformanceMeter.stop("test"); // outputs to console
	 
	 Usage:
	 PerformanceMeter.mark("before bitmap resampling", true);
	 // code
	 PerformanceMeter.mark("after bitmap resampling");
	 // more code
	 PerformanceMeter.mark("after another block of code");
	 // more code 
	 PerformanceMeter.mark("end of method");
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
		private static var lastMarkDifference:int;
		private static var lastMarkText:String;
		private static var supportMultitest:Boolean;
		private static var _poolTimestamps:Vector.<Timestamp>;
		private static var privateTimestamp:Timestamp;
		private static var timestampPoolCount:int = 100;
		private static var multicallInitialized:Boolean;
		
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
		 * Trace to console
		 * */
		public static var traceMessages:Boolean = true;
		
		/**
		 * The timestamp of the last time mark
		 * */
		public static var lastMark:int;
		
		/**
		 * Sets the minimum number of characters in for the test name in the trace console. Used for the alignment of values in the console window.  
		 * */
		public static var markNameMaxWidth:int = 16;
		
		/**
		 * Text to display in the console before a performance mark test result.
		 * */
		public static var performanceMarkText:String = "Performance Mark   ";
		
		public static var performanceTestText:String = "Performance Test   ";
		
		
		/**
		 * Creates a pool of Test and Timestamps and initializes instance variables
		 * Automatically called the first time start is called if not initialized before
		 * then. 
		 * */
		public static function initialize(poolCount:int=NaN, supportMulttest:Boolean=false):void {
			if (initialized) return;
			if (!isNaN(poolCount)) poolCount = poolCount;
			if (supportMulttest) supportMulttest = true;
			
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
		 * each time a call start is called on the test with the same name
		 * */
		public static function start(name:String, multicall:Boolean=true):void {
			if (!initialized) initialize();
			if (!multicallInitialized) initializeMulticall();
			var test:ProfileTest = dictionary[name];
			
			// if test exists
			if (!test) {
				test = dictionary[name] = getAvailableTest(name, multicall);
			}
			
			test.start();
		}
		
		private static function initializeMulticall():void {
			timestampPool = new Vector.<Timestamp>(timestampPoolCount);
			
			for (var i:int;i<timestampPoolCount;i++) {
				timestampPool[i] = new Timestamp();
			}
			
			multicallInitialized = true;
		}
		
		/**
		 * Returns the duration from the start call to the stop call
		 * */
		public static function stop(name:String):uint {
			
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
			
			if (traceMessages) {
				trace(performanceTestText + padString(name, markNameMaxWidth) + ": " + selectedTest.startTime + ":"+ selectedTest.endTime + " "  + selectedTest.duration + "ms");
			}
			
			return selectedTest.duration;
		}
		
		/**
		 * Get's a pre created Test instance
		 * */
		private static function getAvailableTest(name:String, multicall:Boolean):ProfileTest {
			
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
		 * Marks a point in time with the current value of the getTimer count. Also shows the difference since last mark.
		 * */
		public static function mark(name:String="", resetRunningTimer:Boolean = false):void {
			lastMarkDifference = lastMark==0 || resetRunningTimer ? 0 : getTimer() - lastMark;
			
			if (traceMessages) {
				lastMarkText = performanceMarkText + padString(name, markNameMaxWidth) + ": " + getTimer() + "ms"; 
				lastMarkText += lastMark==0 || resetRunningTimer ? "" : " " + "+" + lastMarkDifference;
				lastMark = getTimer();
				trace(lastMarkText);
			}
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