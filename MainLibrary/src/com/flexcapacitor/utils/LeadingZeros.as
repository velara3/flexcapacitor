

package com.flexcapacitor.utils {
	
	/**
	 * Class to set the leading zeros to a string or number.
	 * 
	 * Can also pad with a value other than zero such as a space character.
	 * 
	 * Usage:
	 * LeadingZeros.padNumber(9, 2); // "09"
	 * LeadingZeros.padString("9", 6); // "000009"
	 * LeadingZeros.padString("9", 2, " "); // " 9"
	 * 
	 * */
	public class LeadingZeros {
		
		public function LeadingZeros() {
			
		}
		
		/**
		 * Pads the number passed and returns a string with the number of zeros
		 * */
		public static function padNumber(number:Number, places:Number = 2, paddingCharacter:String = "0"):String {
			var string:String = String(number);
			var length:int = string.length;
			
			for (var i:int = length; i < places; i++) {
				string = paddingCharacter + string;
			}
			
			return string;
		}
		
		/**
		 * Useful if you need something to be 6 places. 
		 * For example, LeadingZeros.padString("fff", 6); returns "000fff"
		 * */
		public static function padString(number:String, places:Number = 2, paddingCharacter:String = "0"):String {
			var string:String = String(number);
			var length:int = string.length;
			
			for (var i:int = length; i < places; i++) {
				string = paddingCharacter + string;
			}
			
			return string;
		}
	}
}