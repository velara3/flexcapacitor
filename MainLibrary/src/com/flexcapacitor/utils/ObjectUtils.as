package com.flexcapacitor.utils
{
	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		
		/**
		 * Merges multiple objects into a new object. 
		 * Objects that have the same property name overwrite the values of previous defined properties 
		 *
		 * @param objects objects to be merged 
		 * @return a new object containing the properties of the objects passed in
		 */
		public static function merge(...objects):Object {
			var newObject:Object = {};
			var property:String;
			var object:Object;
			
			for (var i:int = 0; i < objects.length; i++) {
				object = objects[i];
				
				for (property in object) {
					newObject[property] = object[property];
				}
			}
			
			return newObject;
		}
	}
}