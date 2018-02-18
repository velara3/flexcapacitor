package com.flexcapacitor.utils {

	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import mx.utils.Platform;

	/**
	 * Utility class to read and write values from encrypted local storage. 
	 * 
	 * Works in AIR only.
	 * 
	 * 
	 * Note: The user is prompted to enter password to save to encrypted local storage
	 * if user clicks Deny then error is thrown
	 * 
	 * Error: EncryptedLocalStore internal error
	 *  at flash.data::EncryptedLocalStore$/processErrorCode()
	 *  at flash.data::EncryptedLocalStore$/getItem()
	 *  at com.flexcapacitor.utils::PersistentStorage$/read()
	 * 
	 * filterWords = PersistentStorage.read(FILTER_WORDS);
	 * */
	public class PersistentStorage {
		
		public function PersistentStorage() {
			
		}
		
		/**
		 * Returns if EncryptedLocalStore is supported. 
		 * 
		 * Same as EncryptedLocalStore.isSupported.
		 * @copy #EncryptedLocalStore.isSupported
		 * */
		public static function get isSupported():Boolean {
			if (Platform.isBrowser) return false;
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
		 * Write domain specific logic
		 * */
		public static function writeToDomain(storageName:String, name:String, value:*, host:String):void {
			var out:String;
			var bytes:ByteArray;
			var input:Object = read(storageName);
			
			// object should be:
			// {domainName:{name:value, name2:value}, domainName2:{name:value}}
			if (input==null || !(input is Object)) {
				input = {};
			}
			
			// make a host entry
			if (!(host in input)) {
				input[host] = {};
			}
			
			// set our name value pair
			if (value==null || value==undefined) {
				delete input[host][name];
			}
			else {
				input[host][name] = value;
			}
			
			// turn our object into a string
			out = JSON.stringify(input);
			
			// convert to bytes
			bytes = new ByteArray();
			bytes.writeUTFBytes(out);
			
			// encrypt
			EncryptedLocalStore.setItem(storageName, bytes);
		}
		
		/**
		 * Read domain specific logic
		 * */
		public static function readFromDomain(storageName:String, host:String, name:String = null):Object {
			var out:String;
			var bytes:ByteArray;
			var input:Object = read(storageName);
			var hostObject:Object;
			
			// object should be:
			// {domainName:{name:value, name2:value}, domainName2:{name:value}}
			if (input==null || !(input is Object)) {
				return null;
			}
			
			// read a host entry
			if (host in input) {
				hostObject = input[host];
				
				if (hostObject && name) {
					return hostObject[name];
				}
				
				return hostObject;
			}
			
			return null;
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
		
		/**
		 * Removes an item with the given name from a domain.
		 * If name is not specified, it removes everything in the domain and domain entry itself.
		 * Returns false if nothing found or nothing removed or true if key or host was removed. 
		 * */
		public static function removeFromDomain(storageName:String, name:String, host:String):Boolean {
			var out:String;
			var bytes:ByteArray;
			var input:Object = read(storageName);
			var hostObject:Object;
			
			// object should be:
			// {domainName:{name:value, name2:value}, domainName2:{name:value}}
			if (input==null || !(input is Object)) {
				return false;
			}
			
			if (name==null) {
				return false;
			}
			
			// read a host entry
			if (host in input) {
				hostObject = input[host];
				
				if (name==null) {
					delete input[host];
				}
				else if (name in hostObject) {
					delete hostObject[name];
				}
				
				// turn our object into a string
				out = JSON.stringify(input);
				
				// convert to bytes
				bytes = new ByteArray();
				bytes.writeUTFBytes(out);
				
				// encrypt
				EncryptedLocalStore.setItem(storageName, bytes);
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes all items with the given storage name.
		 * */
		public static function removeAllFromStorage(storageName:String):void {
			
			EncryptedLocalStore.removeItem(storageName);
			
		}
		
		/**
		 * Resets all storage items for the application to nothing.
		 * */
		public static function resetStorage():void {
			
			EncryptedLocalStore.reset();
			
		}
	}
}