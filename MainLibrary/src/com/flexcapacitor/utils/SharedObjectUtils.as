




package com.flexcapacitor.utils {
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	/**
	 * Helper class to save settings to a shared object
	 * */
	public class SharedObjectUtils extends EventDispatcher {
		
		
		private static var _self:SharedObjectUtils;
		
		public static function get self():SharedObjectUtils {
			
			if (_self == null) {
				_self = new SharedObjectUtils(new SINGLETON());
				_self.createFile(_self.name);
			}
			
			return _self;
		}
		
		/**
		 * Reference to the "file" aka shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of shared object. Also path to shared object. 
		 * */
		public var name:String = "ProjectSettings";
		
		/**
		 * Saves the property immediately
		 * */
		public var saveOnChange:Boolean = true;
		
		
		public function SharedObjectUtils(s:SINGLETON) {
			
		}
		
		/**
		 * If the size is 0 then the file is considered to not exist. 
		 * Otherwise it is considered to exist.
		 * Does not automatically create a file.
		 * */
		public function fileExists(name:String):Boolean {
			var so:SharedObject = SharedObject.getLocal(name);

			if (so.size==0) {
				return false;
			}
			
			return true;
		}
		
		/**
		 * Creates the file. 
		 * */
		public function createFile(name:String):void {
			sharedObject = SharedObject.getLocal(name);
			name = name;
		}
		
		/**
		 * Opens the file. 
		 * */
		public function openFile(name:String):void {
			createFile(name);
		}
		
		/**
		 * Sets the key to the file
		 * */
		public function setKeyValue(name:String, value:Object):void {
			sharedObject.setProperty(name, value);
			
			if (saveOnChange) {
				sharedObject.flush();
			}
		}
		
		/**
		 * Takes a target and a list of properties. Then saves the value of those properties in 
		 * the shared object using the same names as the keys
		 * For example, we have PersonVO, and it has properties name, address and phone
		 * Pass in the instance and the name of the properties and it will save the properties
		 * name, address and phone as keys and the values as values
		 * */
		public function setValuesOfKeysFromTarget(target:Object, propertyNames:Array):void {
			
			// we go through each one for error checking
			// if the property name doesn't exist an error will be thrown
			for (var i:int; i<propertyNames.length;i++) {
				//trace("setting " + propertyNames[i] + " to " + target[propertyNames[i]]);
				sharedObject.setProperty(propertyNames[i], target[propertyNames[i]]);
			}
			
			if (saveOnChange) {
				sharedObject.flush();
			}
		}
		
		/**
		 * Gets the value of the key
		 * */
		public function getKeyValue(name:String):Object {
			return sharedObject.data[name];
		}
		
		/**
		 * Get all keys
		 * */
		public function getAllKeys():Array {
			var keys:Array = [];
			
			for (var name:String in sharedObject.data) {
				keys.push(name);
			}
			
			return keys;
		}
		
		/**
		 * Erases the data in the shared object
		 * */
		public function clearSettings():void {
			sharedObject.clear();
		}
		
		/**
		 * 
		 * */
		public function getDiskUsage():int {
			return SharedObject.getDiskUsage(name);
		}
		
		/**
		 * Gets the shared object by name or returns an error 
		 * */
		public static function getSharedObject(name:String, localPath:String = null, secure:Boolean = false):Object {
			
			try {
				return SharedObject.getLocal(name, localPath, secure);
			}
			catch (event:*) { // was event:Error but sometimes null would be returned below?
				return event;
			}
			
			return null;
		}
	}
}

class SINGLETON{}