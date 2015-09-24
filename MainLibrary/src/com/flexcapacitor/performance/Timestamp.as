

package com.flexcapacitor.performance {
	
	
	/**
	 * Used to hold the start time and duration of a single test
	 * @see ProfileTest
	 * */
	public class Timestamp {
		
		public function Timestamp() {
			
		}
		
		/**
		 * Stores the start time
		 * */
		public var startTime:uint;
		
		/**
		 * Stores the end time
		 * */
		public var endTime:uint;
		
		/**
		 * Stores the duration
		 * */
		public var duration:uint;
		
	}
}