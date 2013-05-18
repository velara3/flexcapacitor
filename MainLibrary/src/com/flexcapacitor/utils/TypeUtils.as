




package com.flexcapacitor.utils {
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.utils.getDefinitionByName;
	
	import mx.core.IFlexModule;
	import mx.core.IFlexModuleFactory;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.styles.StyleManager;

	/**
	 * Utility for getting and setting values and getting value types
	 * */
	public class TypeUtils {

		public function TypeUtils() {

		}


		/**
		 * Sets property or style on target visual element
		 * Property can contain metadata. For example, "propertyName:propertyType" or
		 * "property:style" where the inclusion of ":style" indicates a style.
		 * */
		public static function applyProperty(target:Object, property:String, value:*, type:String = "String", isPropertyStyle:Object=null):void {
			var propertyType:String = property.indexOf(":") != -1 ? property.split(":")[1] : type;
			var valueString:String = value is String ? value : null;
			
			// why is the non null value for property indicate isStyle?
			var isStyle:Boolean = property.toLowerCase().indexOf(":style") != -1 || isPropertyStyle ? true : false;
			var isPercent:Boolean = value is String && value != null && value.charAt(value.length - 1) == "%";
			property = property.indexOf(":") != -1 ? property.split(":")[0] : property;
			value = isPercent ? value.slice(0, value.length - 1) : value;
			value = getTypedValue(value, propertyType);


			try {
				if (target) {
					if (property == "width") {
						setWidth(DisplayObject(target), value, isPercent);
					}
					else if (property == "height") {
						setHeight(DisplayObject(target), value, isPercent);
					}
					else if (isStyle) {
						if (target is UIComponent) {
							// we should use the set constraint methods here???
							UIComponent(target).setStyle(property, value);
						}
						else {
							throw new Error("Target does not have property " + property);
						}
					}
					else {
						
						if (Object(target).hasOwnProperty(property)) {
							// this throws an error when the property is not on the target
							target[property] = value;
						}
						else {
							// property is not found on object
							// or property is a style
							// need support for styles
							trace("isStyle is set to false and target doesn't contain " + property);
						}
					}

				}
			}
			catch (error:ErrorEvent) {
				trace("Could not apply " + String(value) + " to " + String(target) + "." + property + "\n" + error.text);
			}

		}

		/**
		 * Sets the height
		 * */
		public static function setHeight(target:DisplayObject, value:*, isPercent:Object=null):void {
			var element:IVisualElement = target as IVisualElement;
			var removePercent:Boolean;
			
			if (isPercent==null) {
				isPercent = value != null && value is String && value.charAt(value.length - 1) == "%";
				removePercent = isPercent;
			}
			else if (isPercent) {
				removePercent = value != null && value is String && value.charAt(value.length - 1) == "%";
			}
			
			value = removePercent ? value.slice(0, value.length - 1) : value;

			if (element) {
				if (isPercent) {
					element.percentHeight = Number(value);
				}
				else {
					element.percentHeight = undefined;

					// no value was entered into the text field
					// let the value reset
					if (value != undefined) {
						target.height = Number(value);
					}
				}
			}
			else {
				// no value was entered into the text field
				// let the value reset
				if (value != undefined) {
					target.height = Number(value);
				}
			}
		}

		/**
		 * Sets the width
		 * */
		public static function setWidth(target:DisplayObject, value:*, isPercent:Object=null):void {
			var element:IVisualElement = target as IVisualElement;
			var removePercent:Boolean;
			
			if (isPercent==null) {
				isPercent = value != null && value is String && value.charAt(value.length - 1) == "%";
				removePercent = isPercent;
			}
			else if (isPercent) {
				removePercent = value != null && value is String && value.charAt(value.length - 1) == "%";
			}

			value = removePercent ? value.slice(0, value.length - 1) : value;

			if (element) {
				if (isPercent) {
					element.percentWidth = Number(value);
				}
				else {
					element.percentWidth = undefined;

					// no value was entered into the text field
					// let the value reset
					if (value != undefined) {
						target.width = Number(value);
					}
				}
			}
			else {
				// no value was entered into the text field
				// let the value reset
				if (value != undefined) {
					target.width = Number(value);
				}
			}
		}

		/**
		 * Casts the value to the correct type
		 * If the type is not set then attempts to discover the type
		 * 
		 * Function is from Flex 4.5 Framework
		 * 
		 * NOTE: May not work for colors
		 * 
		 * Note: Not sure why but has support for creating a new instance of 
		 * a class specified in the value
		 * 
		 * Set type to "ClassDefinition" and value to "com.something.MyClass" to 
		 * get an new instance. returns instance of flash.utils.getDefinitionByName(className)
		 * */
		public static function getTypedValue(value:Object, type:String=null):* {
			
			// if type is not set then guess
			if (!type) {
				type = getValueType(value);
			}
			
			if (type == "Boolean") {
				
				if (value is String) {
					if (value.toLowerCase() == "true") {
						return true;
					}
					else if (value.toLowerCase() == "false") {
						return false;
					}
				}
				
				return Boolean(value);
			}
			else if (type == "Number") {
				if (value == null || value == "") {
					return undefined
				};
				return Number(value);
			}
			else if (type == "int") {
				if (value == null || value == "") {
					return undefined
				};
				return int(value);
			}
			else if (type == "String") {
				return String(value);
			}
			// TODO: Return color type
			else if (type == "Color") {
				// return convertIntToHex(value); // need to test, need use case
				return String(value);
			}
			else if (type == "ClassDefinition") {
				// Note: is this condition supposed to be in this method???
				// returns an new instance of the type of class the value is
				if (value) {
					var ClassDefinition:Class = flash.utils.getDefinitionByName(String(value)) as Class;
					return new ClassDefinition();
				}
				return new Object();
			}
			else {
				return value;
			}
		}
		
		/**
		 * Get the type of the value passed in
		 * */
		public static function getValueType(value:*):String {
			var type:String = getQualifiedClassName(value);
			
			if (type=="int") {
				if (typeof value=="number") {
					type = "Number";
				}
			}
			
			return type;
		}
		
		/**
		 * Get qualified class name of the target object
		 * */
		public static function getQualifiedClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			return name;
		}
		
		/**
		 * Converts an integer to hexidecimal. 
		 * For example, 16117809 returns "#EEEEEE" or something
		 * @return
		 */
		public static function convertIntToHex(item:Object):String {
			var hex:String = Number(item).toString(16);
			return ("00000" + hex.toUpperCase()).substr(-6);
		}
		
		/**
		 * Sets <code>property</code> to the value specified by 
		 * <code>value</code>. This is done by setting the property
		 * on the target if it is a property or the style on the target
		 * if it is a style.  There are some special cases handled
		 * for specific property types such as percent-based width/height
		 * and string-based color values.
		 * 
		 * NOTE: This code was copied from another area in the Flex framework
		 * There are a few areas that set values on objects
		 * SetAction
		 */
		public static function setValue(target:Object, property:String, value:Object, complexData:Boolean = false):void {
			var isStyle:Boolean = false;
			var propName:String = property;
			var val:Object = value;
			var currentValue:Object;
			
			// Handle special case of width/height values being set in terms
			// of percentages. These are handled through the percentWidth/Height
			// properties instead                
			if (property == "width" || property == "height") {
				if (value is String && value.indexOf("%") >= 0) {
					propName = property == "width" ? "percentWidth" : "percentHeight";
					val = val.slice(0, val.indexOf("%"));
				}
			}
			else {
				currentValue = getValue(target, propName);
				
				// Handle situation of turning strings into Boolean values
				if (currentValue is Boolean) {
					if (val is String)
						val = (value.toLowerCase() == "true");
				}
					// Handle turning standard string representations of colors
					// into numberic values
				else if (currentValue is Number &&
					propName.toLowerCase().indexOf("color") != -1)
				{
					var moduleFactory:IFlexModuleFactory = null;
					if (target is IFlexModule)
						moduleFactory = target.moduleFactory;
					
					val = StyleManager.getStyleManager(moduleFactory).getColorName(value);
				}
			}
			
			if (target is XML) {
				if (complexData) 
					setItemCDATA(XML(target), propName, val);
				else
					XML(target)[propName] = val;
			}
			else if (propName in target)
				target[propName] = val;
			else if ("setStyle" in target)
				target.setStyle(propName, val);
			else
				target[propName] = val;
		}
		
		/**
		 * Gets the current value of propName, whether it is a 
		 * property or a style on the target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static function getValue(target:Object, propName:String):* {
			var value:*;
			if (target is XML) {
				if (propName.indexOf("@")==0) {
					value = XML(target).attribute(propName.slice(1))[0];
					return value ? String(value) : "";
				}
				else {
					return XML(target)[propName];
				}
			}
			else if (propName in target) 
				return target[propName];
			else if (target.hasOwnProperty("getStyle"))
				return target.getStyle(propName);
			else 
				return null;
		}
		
		/**
		 * Set the item contents inside CDATA tags
		 * */
		public static function setItemCDATA(item:XML, property:String, value:Object=""):void {
			if (item) {
				if (value is String) {
					item.child(property).replace(0, wrapInCDATA(String(value)));
				}
				else if (value is XML) {
					// right now we are not doing anything special if the value is already XML
					item.child(property).replace(0, wrapInCDATA(String(value)));
				}
			}
		}
		
		
		/**
		 * Wrap text inside of CDATA tags
		 * */
		public static function wrapInCDATA(value:String):XML {
			return new XML("<![C"+"DATA[" + value + "]]>");
		}
	}
}