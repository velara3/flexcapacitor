package com.flexcapacitor.utils {

	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;

	/**
	 * Utility class to read and write values from encrypted local storage
	 * Works in AIR only.
	 * */
	public class PersistentStorage {
		
		public function PersistentStorage() {
			
		}
		
		/**
		 * Returns if EncryptedLocalStore is supported. 
		 * Same as EncryptedLocalStore.isSupported.
		 * */
		public static function get isSupported():Boolean {
			return EncryptedLocalStore.isSupported;
		}
		
		/**
		 * Stores a value under the given name.
		 * If an object is passed in then it is converted to JSON and stored as a string.
		 * It is then returned as an object when retrieved. If a string is passed in then
		 * a string is returned.  
		 * If value of null is passed in then the value is removed. 
		 * Check #isSupported before calling this method.
		 * */
		public static function write(name:String, value:*):void {
			var out:String;
			var bytes:ByteArray;
			
			if (value!=null && !(value is String) && value is Object) {
				out = JSON.stringify(value);
			}
			else {
				out = value;
			}
			
			if (value==null) {
				EncryptedLocalStore.removeItem(name);
				return;
			}
			
			bytes = new ByteArray();
			bytes.writeUTFBytes(out);
			
			EncryptedLocalStore.setItem(name, bytes);
		}
		
		/**
		 * Returns the value stored in the given name. 
		 * If the stored value was an object than an object is returned.
		 * If the stored value was a string then the string is returned. 
		 * Check #isSupported before calling this method.
		 * */
		public static function read(name:String):* {
			var input:String;
			var bytes:ByteArray;
			var result:String;
			var json:Object;
			
			bytes = EncryptedLocalStore.getItem(name);
			
			if (bytes && bytes.length) {
				input = bytes.readUTFBytes(bytes.length);
			}
			
			if (input && input.charAt(0)=="{" && input.charAt(input.length-1)=="}") {
				try {
					json = JSON.parse(input);
					return json;
				}
				catch (error:Error) {
					// was not json or could not parse json
				}
			}
			
			return input;
			
		}
		
		/**
		 * Removes an item with the given name
		 * */
		public static function remove(name:String):* {
			EncryptedLocalStore.removeItem(name);
		}
	}
}