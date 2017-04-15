




package com.flexcapacitor.utils {
	
	
	/**
	 * Number utilities. 
	 * */
	public class NumberUtils {
		
		/**
		 * Constructor
		 * */
		public function NumberUtils() {
			
		}
		
		/**
		 * Returns the number with the number of digits to the right of the decimal point
		 * */
		public static function toDecimalPoint(value:Number, digits:int = 2):Number {
			return Number(Number(value).toFixed(digits-1));
		}
		
	}
}