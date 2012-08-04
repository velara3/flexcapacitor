

package com.flexcapacitor.performance {
	
	/**
	 * Used to hold a reference to an object and a property on that object.
	 * When we update the display we set the values in our performance test 
	 * into the property target objects
	 * */
	public class TargetIndicators {
		
		public var target:Object;
		public var property:String;
		
		/**
		 * Value to get from performance tests
		 * 
		 * Currently
		 *  - 0 is duration
		 *  - 1 is maximum value (if running test multiple times)
		 *  - 2 is minimum value (if running test multiple times)
		 *  - 3 is 
		 * */
		public var valueToGet:Vector.<int>;
		
		
		public function TargetIndicators() {
			
		}
	}
}