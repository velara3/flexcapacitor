package com.flexcapacitor.utils
{
	import com.flexcapacitor.controls.AceEditor;
	import com.flexcapacitor.controls.supportClasses.AutoCompleteObject;
	import com.flexcapacitor.controls.supportClasses.TokenInformation;
	import com.flexcapacitor.model.MetaData;
	import com.flexcapacitor.performance.PerformanceMeter;
	import com.flexcapacitor.utils.supportClasses.ObjectDefinition;
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	
	import avmplus.getQualifiedClassName;
	

	public class AceEditorUtils {
		
		public var editor:AceEditor;
		
		public function AceEditorUtils()
		{
			
		}
		
		public static var XML_TEXT:String 				= "text.xml";
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
		 * Profile Mark   After getXMLTagQNameFromCursorPo: +457
		 * Profile Mark   After aceEditor.getTagName      : +3
		 * */
		public static function getTagName(editor:AceEditor, row:int, column:int):QName {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var qname:QName;
			var session:Object;
			
			if (AceEditor.isBrowser && editor.useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					var session = editor!=null ? editor.session : null;
					var token;
					var line;
					var type;
					var value;
					var found;
					
					const XML_TAG_NAME = "meta.tag.tag-name.xml";
					
					for (; row > -1; row--) {
						line = session.getLine(row);
						column = line.length;
						
						for (; column>-1; column--) {
							token = session.getTokenAt(row, column);
							type = token ? token.type : "";
							
							if (type==XML_TAG_NAME) {
								value = token.value;
								found = true;
								break;
							}
						}
						
						if (found) break;
					}
					
					return token;
				}
				]]></xml>;
				
				var results:Object = ExternalInterface.call(string, editor.editorIdentity, row, column);
				
				if (results) {
					qname = new QName("", results.value);
				}
				
				return qname;
			}
			else {
				session = editor.session;
				
				for (; row > -1; row--) {
					line = session.getLine(row);
					column = line.length;
					
					for (; column>-1; column--) {
						token = session.getTokenAt(row, column);
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
			
		}
		
		/**
		 * Get attribute from current cursor position
		 * */
		public static function getAttributeName(editor:AceEditor, row:int, column:int):QName {
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
		
		public static function getObjectsFromArray(values:Array, metadataType:String = "attribute", className:String = null, useAttributeSnippet:Boolean = false, classNameSnippet:Boolean = false):Array {
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
					else if (classNameSnippet) {
						autoCompleteObject.type = AutoCompleteObject.SNIPPET;
						autoCompleteObject.snippet = "<" + name + "${1}";
					}
					else {
						autoCompleteObject.type = metadataType;
					}
					
					newValues.push(autoCompleteObject);
				}
			}
			
			return newValues;
		}
		
		public static var cachedClassValues:Dictionary = new Dictionary(true);
		
		public static var tokenInformation:TokenInformation;
		
		public static function getAutoCompleteList(aceEditor:AceEditor):Array {
			var cursor:Object = aceEditor.getCursor();
			var token:Object = aceEditor.getTokenAt(cursor.row, cursor.column);
			var type:String = token ? token.type : null;
			var entity:String = "";
			var classFound:Boolean;
			var updatedQName:QName;
			var classObject:Object;
			var tagQName:QName;
			var attributeQName:QName;
			var qualifiedClassName:String;
			var classRegistry:ClassRegistry;
			var suggestions:Array;
			
			if (tokenInformation==null) {
				tokenInformation = new TokenInformation;
			}
			
			classRegistry = ClassRegistry.getInstance();
			
			tagQName = getTagName(aceEditor, cursor.row, cursor.column);
			//PerformanceMeter.mark("After AceUtils.getTagName");
			
			tagQName = aceEditor.getTagName(cursor.row, cursor.column) as QName;
			
			//PerformanceMeter.mark("After aceEditor.getTagName");
			
			tokenInformation.cursor = cursor;
			tokenInformation.token = token;
			tokenInformation.tagName = tagQName;
			tokenInformation.type = type;
			
			if (tagQName!=null) {
				updatedQName = classRegistry.getQNameForPrefixedName(tagQName.localName);
				entity = tagQName.localName;
				classObject = classRegistry.getClass(updatedQName);
				
				tokenInformation.prefixedTagName = updatedQName;
				tokenInformation.entity = entity;
				tokenInformation.classFound = classObject!=null;
				//PerformanceMeter.mark("After getQNameForPrefixedName");
				
				
				if (type==XML_ATTRIBUTE_VALUE || type==XML_ATTRIBUTE_EQUALS) {
					attributeQName = getAttributeName(aceEditor, cursor.row, cursor.column);
					//PerformanceMeter.mark("After getXMLAttributeQNameFromCursorPosition");
					
					tokenInformation.attributeName = attributeQName;
					tokenInformation.qualifiedClassName = null;
				}
				else if (type==XML_TEXT) {
					qualifiedClassName = getQualifiedClassName(FlexGlobals.topLevelApplication);
					
					if (cachedClassValues[qualifiedClassName]==null) {
						suggestions = classRegistry.getPrefixedClassNames();
						suggestions = getObjectsFromArray(suggestions, "Classes", null, false, true);
						//PerformanceMeter.mark("After getObjectsFromArray");
						cachedClassValues[qualifiedClassName] = suggestions;
						aceEditor.setCompleterValues(qualifiedClassName, suggestions);
					}
					else {
						suggestions = cachedClassValues[qualifiedClassName];
						aceEditor.setCompleterValues(qualifiedClassName, null);
					}
					
					tokenInformation.attributeName = null;
					tokenInformation.qualifiedClassName = qualifiedClassName;
					
					return suggestions;
				}
				
				if (classObject!=null) {
					classFound = true;
					qualifiedClassName = getQualifiedClassName(classObject);
					tokenInformation.qualifiedClassName = qualifiedClassName;
					
					
					if (attributeQName) {
						suggestions = getAttributeValueSuggestionListFromObject(classObject, attributeQName);
						//PerformanceMeter.mark("After getAttributeValueSuggestionListFromObject");
						//lastSelectedAttributeQName = attributeName;
						aceEditor.setCompleterValues(qualifiedClassName, suggestions, attributeQName.localName);
						//PerformanceMeter.mark("After setCompleterValues 3");
						
					}
					else {
						
						if (cachedClassValues[qualifiedClassName]==null) {
							//trace("Creating suggestion list for " + qualifiedClassName);
							suggestions = getMemberSuggestionListFromObject(classObject);
							//PerformanceMeter.mark("After getMemberSuggestionListFromObject");
							//suggestions.length = 20;
							aceEditor.setCompleterValues(qualifiedClassName, suggestions);
							//PerformanceMeter.mark("After setCompleterValues 1");
							cachedClassValues[qualifiedClassName] = suggestions;
						}
						else {
							//trace("Submitting cached suggestion list for " + qualifiedClassName);
							suggestions = cachedClassValues[qualifiedClassName];
							aceEditor.setCompleterValues(qualifiedClassName, null);
							//PerformanceMeter.mark("After setCompleterValues 2");
						}
					}
				}
				
				if (tagQName==null) {
					if (suggestions.length) {
						suggestions = [];
					}
					
					tokenInformation.classFound = classObject!=null;
					//lastSelectedTagQName = null;
					//return;
				}
			}
			
			return suggestions;
		}
	}
}