
package com.flexcapacitor.model {
	
	
	/**
	 * Contains information on metadata
	 * */
	public class MetaData {
		
		
		public function MetaData(item:XML = null, target:* = null)
		{
			if (item) unmarshall(item, target);
			
		}
		
		/**
		 * Name of property, style or event
		 * */
		public var name:String;
		
		/**
		 * Type of data. For example, String, int, etc
		 * */
		public var type:String;
		
		/**
		 * Value at the time of access
		 * */
		public var value:*;
		
		/**
		 * Format of data. For example, Color, Number, etc
		 * */
		public var format:String;
		
		/**
		 * Minimum value of property
		 * */
		public var minValue:Number;
		
		/**
		 * Maximum value of property
		 * */
		public var maxValue:Number;
		
		/**
		 * Inspectable data category. For example, general, etc
		 * */
		public var category:String;
		
		/**
		 * Default value for inspectable panel
		 * */
		public var defaultValue:String;
		
		/**
		 * 
		 * */
		public var environment:String;
		
		/**
		 * Accepted values
		 * */
		public var enumeration:Array;
		
		/**
		 * Theme 
		 * */
		public var theme:String;
		
		/**
		 * Type of element in the array
		 * */
		public var arrayElementType:String;
		
		/**
		 * 
		 * */
		public var arrayType:String;
		
		public var helpPositions:Array;
		
		public var bindable:Array;
		
		public var percentProxy:Array;
		
		public var skinPart:Array;
		
		public var verbose:Boolean;
		
		/**
		 * A string representation of the value. 
		 * Empty string is empty string, null or undefined. 
		 * */
		public var textValue:String = "";
		
		/**
		 * Raw XML formatted string from describe type
		 * */
		public var raw:String;
		
		/**
		 * Class that defined this style
		 * */
		public var declaredBy:String;
		
		/**
		 * Import metadata XML node into this instance
		 * */
		public function unmarshall(item:XML, target:* = null, getValue:Boolean = true):void {
			var args:XMLList = item.arg;
			var keyName:String;
			var keyValue:String;
			var propertyValue:*;
			
			name = item.@name;
			type = item.@type;
			declaredBy = item.@declaredBy;
			
			for each (var arg:XML in args) {
				keyName = arg.@key;
				keyValue = String(arg.@value);
			
						
				if (keyName=="arrayType") {
					arrayType = keyValue;
					continue;
				}
				
				else if (keyName=="category") {
					category = keyValue;
					continue;
				}
				
				else if (keyName=="defaultValue") {
					defaultValue = keyValue;
					continue;
				}
				
				if (keyName=="enumeration") {
					enumeration = keyValue.split(",");
					continue;
				}
				
				else if (keyName=="environment") {
					environment = keyValue;
					continue;
				}
		
				else if (keyName=="format") {
					format = keyValue;
					continue;
				}
				
				else if (keyName=="minValue") {
					minValue = Number(keyValue);
					continue;
				}
				
				else if (keyName=="maxValue") {
					maxValue = Number(keyValue);
					continue;
				}
				
				else if (keyName=="name") {
					name = keyValue;
					continue;
				}
			
				else if (keyName=="theme") {
					theme = keyValue;
					continue;
				}
			
				else if (keyName=="type") {
					type = keyValue;
					continue;
				}
				
				else if (keyName=="verbose") {
					verbose = keyValue=="1";
					continue;
				}
			}
			
			// ReferenceError: Error #1077: Illegal read of write-only property layoutMatrix3D on spark.components.Label.
			try {
				value = target && name in target ? target[name] : undefined;
			}
			catch (e:Error) {
				
			}
			
			textValue = value===undefined ? "": "" + value;
			
			if (!getValue) value = undefined;
			
			raw = item.toXMLString();
			
		}
	}
}