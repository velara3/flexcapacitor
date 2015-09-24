
package com.flexcapacitor.performance {

	/**
	 * Model to store UI component or target object to update on regular intervals
	 * */
	public class ProfileTarget {
		
		public function ProfileTarget() {
			
		}
		
		/**
		 * Target that contains a property to update
		 * */
		public var target:Object;
		
		/**
		 * Name of property on target
		 * */
		public var property:String;
		
		/**
		 * Name of ProfileTest
		 * */
		public var name:String;
		
		private var _tests:Array;

		/**
		 * Tests to include in the output. ProfileTest.DURATION, ProfileTest.AVERAGE, ProfileTest.NORMAL
		 * */
		public function get tests():Array {
			return _tests;
		}

		/**
		 * Set to an array of test values. To get all tests,
		 * set to an array [ProfileTest.DURATION, ProfileTest.AVERAGE, ProfileTest.NORMAL]
		 * @private
		 */
		public function set tests(value:Array):void {
			if (value.indexOf(ProfileTest.DURATION)!=-1) {
				hasDuration = true;
			}
			if (value.indexOf(ProfileTest.AVERAGE)!=-1) {
				hasAverage = true;
			}
			if (value.indexOf(ProfileTest.NORMAL)!=-1) {
				hasNormal = true;
			}
			_tests = value;
		}

		
		/**
		 * Duration to wait between updating target
		 * */
		public var duration:int;
		
		public var hasDuration:Boolean;
		public var hasAverage:Boolean;
		public var hasNormal:Boolean;
		
		/**
		 * Sets the target to the values in the profile test
		 * If you get errors here check that the target is created by the time you add it.
		 * Shows the tests duration, average and normalized values. Set the tests property 
		 * to the values you want to see.
		 * */
		public function setValue(value:String):void {
			target[property] = value;
		}
	}
}