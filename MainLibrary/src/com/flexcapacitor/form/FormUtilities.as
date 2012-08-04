

package com.flexcapacitor.form {
	import com.flexcapacitor.form.vo.FormElement;
	
	import mx.core.IFlexModule;
	import mx.core.IFlexModuleFactory;
	import mx.styles.StyleManager;
	
	/**
	 * Helper class for Form Manager
	 * */
	public class FormUtilities {
		
		public function FormUtilities() {
			
		}
		
		/**
		 * Sets components equal to the values in the source object.
		 * The elements must be of type Form Element.
		 * It uses the form element data property to find the name of the property that 
		 * contains the value on the form data object. 
		 * It uses the target component and target property as the target for the value. 
		 * */
		public static function setComponentsValues(source:Object, elements:Vector.<FormElement>, suppressErrors:Boolean = true, useDefaultValues:Boolean = true):void {
			var length:int = elements.length;
			var complexData:Boolean;
			var item:FormElement;
			var value:*;
			var i:int;
			
			// set values of form elements
			for (i=0;i<length;i++) {
				item = elements[i];
				
				// check if target component is null
				// we may be trying to set the form components before they are created
				// you can work around this by adding the same handler actions 
				// on the target component's parent creation complete event 
				// and suppressing the errors until the components are created
				// which happens when listening to a data change event which 
				// is set before components are created
				if (item.targetComponent==null) {
					
					if (suppressErrors) {
						item.pendingSetting = true;
						item.pendingValue = source[item.dataProperty];
						continue;
					}
					else { 
						throw new Error("The target component is null. It may not be created yet. Enable suppress errors for components that are not created yet.");
					}
				}
				
				if (source) {
					value = source[item.dataProperty];
					
					//if (item.targetComponent is CheckBox) {
					//	trace("checkbox", value);
					//	value = (value is String && (value=="1" || value=="true")) || value===true ? true : false;
					//}
					
					setValue(item.targetComponent, item.targetComponentProperty, value, item.wrapValueInCDATATags);
				}
				
			}
		}
		
		/**
		 * Sets <code>property</code> to the value specified by 
		 * <code>value</code>. This is done by setting the property
		 * on the target if it is a property or the style on the target
		 * if it is a style.  There are some special cases handled
		 * for specific property types such as percent-based width/height
		 * and string-based color values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static function setValueAsString(target:Object, property:String, source:Object, sourceProperty:String, complexData:Boolean = false):void {
			var value:String = String(getValue(source, sourceProperty));
			setValue(target, property, value, complexData);
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
		 * InspectorUtils
		 * FormUtilities
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
				currentValue = getValue(target, propName); // if value is undefined we can't determine type
				
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
					setItemContents(XML(target), propName, val);
				else {
					setXMLProperty(XML(target), propName, val);
				}
			}
			else if (propName in target)
				target[propName] = val;
			else if ("setStyle" in target)
				target.setStyle(propName, val);
			else
				target[propName] = val;
		}
		
		/**
		 * Sets <code>property</code> to the value specified by 
		 * <code>value</code>. This is done by setting the property
		 * on the target if it is a property or the style on the target
		 * if it is a style.  There are some special cases handled
		 * for specific property types such as percent-based width/height
		 * and string-based color values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static function setValue2(target:Object, property:String, source:Object, sourceProperty:String, complexData:Boolean = false):void {
			var propName:String = property;
			var isStyle:Boolean;
			var isTargetXML:Boolean = target is XML;
			var originalValue:Object = getValue(source, sourceProperty);
			var newValue:Object = !isTargetXML ? originalValue as String : originalValue;
			var currentValue:Object;
			
			// Handle special case of width/height values being set in terms
			// of percentages. These are handled through the percentWidth/Height
			// properties instead
			if (property == "width" || property == "height") {
				if (originalValue is String && originalValue.indexOf("%") >= 0) {
					propName = property == "width" ? "percentWidth" : "percentHeight";
					newValue = newValue.slice(0, newValue.indexOf("%"));
				}
			}
			else {
				currentValue = getValue(target, propName);
				
				// Handle situation of turning strings into Boolean values
				if (currentValue is Boolean) {
					
					if (newValue is String) {
						newValue = (originalValue.toLowerCase() == "true");
					}
				}
				else if (currentValue is Number && propName.toLowerCase().indexOf("color") != -1) {
					// Handle turning standard string representations of colors
					// into numberic values
					var moduleFactory:IFlexModuleFactory = null;
					
					if (target is IFlexModule) {
						moduleFactory = target.moduleFactory;
					}
					
					newValue = StyleManager.getStyleManager(moduleFactory).getColorName(originalValue);
				}
			}
			
			if (target is XML) {
				if (complexData) 
					setItemContents(XML(target), propName, newValue);
				else {
					XML(target)[propName] = newValue;
				}
			}
			else if (propName in target)
				target[propName] = newValue;
			else if (target.hasOwnProperty("setStyle"))
				target.setStyle(propName, newValue);
			else
				target[propName] = newValue;
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
		 * Wrap text inside of CDATA tags
		 * */
		public static function wrapInCDATA(value:String):XML {
			return new XML("<![C"+"DATA[" + value + "]]>");
		}
		
		/**
		 * Set the item contents inside CDATA tags
		 * */
		public static function setItemContents(item:XML, property:String, value:Object=""):void {
			if (item) {
				if (!(property in item)) {
					item[property] = <{property}/>;
				}
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
		 * Set the xml to to the value. 
		 * Allows dot operator to drill into nodes
		 * */
		public static function setXMLProperty(item:XML, property:String, value:Object=""):void {
			
			if (item) {
				
				var properties:Array = [];
				var name:String = property;
				var object:Object = item;
				var length:int;
				
				properties = property ? property.split(".") : properties;
				length = properties.length;
				
				
				for (var i:int=0;i<length;i++) {
					name = properties[i];
					
					if (i<length-1) {
						if (!(name in object)) {
							object[name] = <{name}/>;
						}
					
						object = object[name];
					}
				}
				
				// replaces contents
				if (object[name] is XMLList) {
					object[name] = value;
				}
				else {
					object[name] = value;
				}
				
			}
		}
		
		/**
		 * Returns an vector of all the request names defined in the form adapter
		 * */
		public static function getRequestNames(form:FormAdapter):Vector.<String> {
			var length:int = form.items.length;
			var elements:Vector.<FormElement> = form.items;
			var complexData:Boolean;
			var item:FormElement;
			var i:int;
			var names:Vector.<String> = new Vector.<String>;
			
			// set values of form elements
			for (i=0;i<length;i++) {
				item = elements[i];
				if (item.requestName) {
					names.push(item.requestName);
				}
			}
			
			return names;
		}
	}
}