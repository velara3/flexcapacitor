
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
		 * Set to true if format is "Color"
		 * @see #format
		 * */
		public var isColor:Boolean;
		
		/**
		 * Format of data. For example, Color, Number, etc
		 * @see #isColor
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
		 * 
		 * Example Accessor data:
		 * 
<pre>
&lt;accessor name="color" access="readwrite" type="uint" declaredBy="com.flexcapacitor.controls::HorizontalLine">
  &lt;metadata name="Bindable">
     &lt;arg key="event" value="propertyChange"/>
  &lt;/metadata>
  &lt;metadata name="Inspectable">
     &lt;arg key="name" value="color"/>
     &lt;arg key="type" value="uint"/>
     &lt;arg key="format" value="Color"/>
     &lt;arg key="inherit" value="no"/>
  &lt;/metadata>
  &lt;metadata name="__go_to_definition_help">
     &lt;arg key="pos" value="0"/>
  &lt;/metadata>
  &lt;metadata name="__go_to_definition_help">
     &lt;arg key="pos" value="0"/>
  &lt;/metadata>
&lt;/accessor>
</pre>
         * 
		 * */
		public function unmarshall(item:XML, target:* = null, getValue:Boolean = true):void {
			var args:XMLList = item..arg;
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
				
				else if (keyName=="enumeration") {
					enumeration = keyValue.split(",");
					continue;
				}
				
				else if (keyName=="environment") {
					environment = keyValue;
					continue;
				}
		
				else if (keyName=="format") {
					format = keyValue;
					if (keyValue is String && keyValue.toLowerCase()=="color") {
						isColor = true;
					}
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
			
			updateValues(target, getValue);
			
			raw = item.toXMLString();
			
		}
		
		/**
		 * We cache the metadata but each target has different values
		 * so we use this method to update them
		 * */
		public function updateValues(target:Object, getValue:Boolean = true):void {
			
			if (getValue)  {
				// ReferenceError: Error #1077: Illegal read of write-only property layoutMatrix3D on spark.components.Label.
				try {
					value = target && name in target ? target[name] : undefined;
				}
				catch (e:Error) {
					
				}
				
				textValue = value===undefined ? "": "" + value;
			}
			else {
				value = undefined;
				textValue = "";
			}
		}
	}
}