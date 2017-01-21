package com.flexcapacitor.utils
{
	import com.flexcapacitor.controls.AceEditor;
	import com.flexcapacitor.controls.supportClasses.AutoCompleteObject;
	import com.flexcapacitor.model.MetaData;
	import com.flexcapacitor.utils.supportClasses.ObjectDefinition;
	

	public class AceEditorUtils {
		
		public var editor:AceEditor;
		
		public function AceEditorUtils()
		{
			
		}
		
		public static var XML_TAG_NAME:String 			= "meta.tag.tag-name.xml";
		public static var XML_TAG_OPEN:String 			= "meta.tag.punctuation.tag-open.xml";
		public static var XML_TAG_CLOSE:String 			= "meta.tag.punctuation.tag-close.xml";
		public static var XML_END_TAG_OPEN:String 		= "meta.tag.punctuation.end-tag-open.xml";
		public static var XML_ATTRIBUTE_NAME:String 	= "entity.other.attribute-name.xml";
		public static var XML_ATTRIBUTE_VALUE:String 	= "string.attribute-value.xml";
		public static var XML_ATTRIBUTE_EQUALS:String 	= "keyword.operator.attribute-equals.xml";
		
		public static var STYLE:String = "style";
		public static var EVENT:String = "event";
		public static var PROPERTY:String = "property";
		
		/**
		 * Get tag name from current cursor position
		 * */
		public static function getXMLTagQNameFromCursorPosition(editor:AceEditor, row:int, column:int):QName {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var qname:QName;
			
			for (; row > -1; row--) {
				line = editor.getLine(row);
				column = line.length;
				
				for (; column>-1; column--) {
					token = editor.getTokenAt(row, column);
					type = token ? token.type : "";
					
					if (type==XML_TAG_NAME) {
						value = token.value;
						found = true;
						break;
					}
				}
				
				if (found) break;
			}
			
			if (found) {
				qname = new QName("", value);
			}
			
			return qname;
		}
		
		/**
		 * Get attribute from current cursor position
		 * */
		public static function getXMLAttributeQNameFromCursorPosition(editor:AceEditor, row:int, column:int):QName {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var qname:QName;
			var firstValue:Boolean;
			
			for (; row > -1; row--) {
				line = editor.getLine(row);
				
				if (firstValue) {
					column = line.length;
				}
				else {
					firstValue = true;
				}
				
				for (; column>-1; column--) {
					token = editor.getTokenAt(row, column);
					type = token ? token.type : "";
					
					if (type==XML_ATTRIBUTE_NAME) {
						value = token.value;
						found = true;
						break;
					}
				}
				
				if (found) break;
			}
			
			if (found) {
				qname = new QName("", value);
			}
			
			return qname;
		}
		
		/**
		 * Get auto complete object from an object 
		 * */
		public static function getMemberSuggestionListFromObject(object:Object, includeMethods:Boolean = false):Array {
			var definition:ObjectDefinition = ClassUtils.getObjectInformation(object, includeMethods);
			var definitionName:String = definition.name;
			var styleObjects:Array = getObjectsFromArray(definition.styles, STYLE, definitionName, true);
			var eventsObjects:Array = getObjectsFromArray(definition.properties, PROPERTY, definitionName, true);
			var propertiesObjects:Array = getObjectsFromArray(definition.events, EVENT, definitionName, true);
			
			var members:Array = styleObjects.concat(eventsObjects).concat(propertiesObjects);
			
			members.sortOn("value", [Array.CASEINSENSITIVE]);
			
			return members;
		}
		
		/**
		 * Get an array of auto complete objects for an attribute
		 * */
		public static function getAttributeValueSuggestionListFromObject(object:Object, attributeName:QName):Array {
			var memberMetaData:MetaData = ClassUtils.getMetaDataOfMember(object, attributeName.localName);
			var enumeration:Array = memberMetaData ? memberMetaData.enumeration : [];
			var choicesObjects:Array = [];
			var type:String = memberMetaData ? memberMetaData.type: null;
			
			if (memberMetaData==null) {
				return [];
			}
			
			if (enumeration) {
				choicesObjects = getObjectsFromArray(enumeration, "Enumeration", memberMetaData.declaredBy);
			}
			else if (type=="Boolean") {
				choicesObjects = getObjectsFromArray(["true","false"], "Boolean", memberMetaData.declaredBy);
			}
			
			choicesObjects.sortOn("value", [Array.CASEINSENSITIVE]);
			
			return choicesObjects;
		}
		
		public static function getObjectsFromArray(values:Array, metadataType:String = "attribute", className:String = null, useAttributeSnippet:Boolean = false):Array {
			var newValues:Array = [];
			var numberOfItems:int = values ? values.length :0;
			var autoCompleteObject:AutoCompleteObject;
			var testing:Boolean;
			var object:Object;
			var name:String;
			var score:int;
			
			for (var i:int = 0; i < numberOfItems; i++) {
				name = values[i];
				
				if (testing) {
					//object = {"value":name, score:i, meta:metadataType};
					object = {value:name, score:i, meta:metadataType};
					newValues.push(object);
				}
				else {
					//score = Math.random()*100;
					autoCompleteObject = new AutoCompleteObject(name, metadataType);
					//autoCompleteObject.caption = "Name: " + name + " Score: " + score + " ClassName: " + className;
					//autoCompleteObject.className = className;
					//autoCompleteObject.type = "attribute";
					//autoCompleteObject.docHTML = null;
					
					if (useAttributeSnippet) {
						autoCompleteObject.type = AutoCompleteObject.SNIPPET;
						autoCompleteObject.snippet = name+"=\"${1}\"";
					}
					else {
						autoCompleteObject.type = metadataType;
					}
					
					newValues.push(autoCompleteObject);
				}
			}
			
			return newValues;
		}
	}
}