




package com.flexcapacitor.utils {
	
	/**
	 * Vector utilities. 
	 * */
	public class VectorUtils {
		
		public function VectorUtils() {
			
		}
		
		/**
		 * Convert vector to array.
		 * 
		 * This should cast to the vector type
		 * */
		public static function vectorToArray(vector:*, type:Class=null):Array {
			var array:Array = [];
			var length:uint = vector.length;
			for(var i:int = 0; i < length; i++){
				array[i] = vector[i] as type;
			}
			return vector ? array : null;
		}
		
		/**
		 * Convert array to vector.<br/>
		 * 
		 * This casts the array item to the type
		 * 
		 * You can also do this:<br/><pre>
		 * var vector:Vector.<String> = Vector.<String>(myArray);</pre>
		 * */
		public static function arrayToVector(array:Array, vector:*, type:Class=null):Array {
			var length:uint = array.length;
			
			for(var i:int = 0; i < length; i++){
				vector[i] = type(array[i]);
			}
			
			return array ? vector : null;
		}
	}
}