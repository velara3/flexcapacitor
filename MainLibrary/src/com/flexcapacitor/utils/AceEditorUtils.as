package com.flexcapacitor.utils
{
	import com.flexcapacitor.controls.AceEditor;
	import com.flexcapacitor.controls.supportClasses.AutoCompleteObject;
	import com.flexcapacitor.controls.supportClasses.TokenInformation;
	import com.flexcapacitor.model.MetaData;
	import com.flexcapacitor.utils.supportClasses.ObjectDefinition;
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.core.FlexGlobals;
	
	import avmplus.getQualifiedClassName;
	

	public class AceEditorUtils {
		
		public var editor:AceEditor;
		
		public function AceEditorUtils()
		{
			
		}
		
		public static var XML_TEXT:String 				= "text.xml";
		
		/**
		 * Whitespace inside of a tag. Where you type attribute names
		 * <Tag     attribute=""   |  />
		 */
		public static var XML_TAG_WHITESPACE:String				= "text.tag-whitespace.xml";
		
		/**
		 * Not sure
		 * */
		public static var XML_TAG_OPEN:String 					= "text.tag-open.xml";
		
		/**
		 * The node name
		 * <s:Button />
		 * The value would be "s:Button"
		 * */
		public static var XML_TAG_NAME:String 					= "meta.tag.tag-name.xml";
		
		/**
		 * First character in a node
		 * <Button
		 * The value would be "<".  
		 * */
		public static var XML_TAG_PUNCTUATION_TAG_OPEN:String 	= "meta.tag.punctuation.tag-open.xml";
		
		/**
		 * Last character in a node's open tag
		 * <div>hello world</div>
		 * The value would be the ">" after the "<div". 
		 * */
		public static var XML_TAG_PUNCTUATION_TAG_CLOSE:String 	= "meta.tag.punctuation.tag-close.xml";
		
		/**
		 * First less than sign in closing tag
		 * </s:Button>
		 * */
		public static var XML_END_TAG_OPEN:String 				= "meta.tag.punctuation.end-tag-open.xml";
		public static var XML_ATTRIBUTE_NAME:String 			= "entity.other.attribute-name.xml";
		
		/**
		 * Attribute value including any surrounding quotes
		 * <Tag width="50" />
		 * Value string contains "50".  
		 * */
		public static var XML_ATTRIBUTE_VALUE:String 			= "string.attribute-value.xml";
		public static var XML_ATTRIBUTE_EQUALS:String 			= "keyword.operator.attribute-equals.xml";
		
		public static var STYLE:String = "style";
		public static var EVENT:String = "event";
		public static var PROPERTY:String = "property";
		
		/**
		 * Get tag name from current cursor position
		 * Profile Mark   After getXMLTagQNameFromCursorPo: +457 (call as3 to js to as3 in for loop)
		 * Profile Mark   After aceEditor.getTagName      : +3 (call javascript method and return via EI)
		 * */
		public static function getTagName(editor:AceEditor, row:int, column:int):TokenInformation {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var qname:QName;
			var session:Object;
			var tokenInfo:TokenInformation;
			var first:Boolean = true;
			
			
			if (AceEditor.isBrowser && editor.useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					var session;
					var token;
					var line;
					var type;
					var value;
					var found = false;
					var first = true;
					
					const XML_TAG_NAME = "meta.tag.tag-name.xml";
					
					session = editor!=null ? editor.session : null;
					
					if (session==null) {
						return false;
					}
					
					for (; row > -1; row--) {
						line = session.getLine(row);
						if (!first) column = line.length;
						
						for (; column>-1; column--) {
							token = session.getTokenAt(row, column);
							type = token ? token.type : "";
							
							if (type==XML_TAG_NAME) {
								value = token.value;
								column = token.start+1;
								found = true;
								break;
							}
						}
						
						first = false;
						
						if (found) break;
					}
					

					if (found) {
						token.row = row;
						token.column = column;
						return token;
					}

					return false;
				}
				]]></xml>;
				
				token = ExternalInterface.call(string, editor.editorIdentity, row, column);
				
				
				if (token) {
					found = true;
					value = token.value;
					row = token.row;
					column = token.column;
				}
			}
			else {
				session = editor.session;
				
				
				for (; row > -1; row--) {
					line = session.getLine(row);
					if (!first) column = line.length;
					
					for (; column>-1; column--) {
						token = session.getTokenAt(row, column);
						type = token ? token.type : "";
						
						if (type==XML_TAG_NAME) {
							value = token.value;
							column = token.start+1;
							found = true;
							break;
						}
					}
					
					first = false;
					
					if (found) break;
				}
			}
			
			tokenInfo = new TokenInformation();
			
			if (found) {
				qname = new QName("", value);
				tokenInfo.found = true;
				tokenInfo.row = row;
				tokenInfo.column = column;
				tokenInfo.tagName = qname;
				tokenInfo.token = token;
				tokenInfo.value = token ? token.value : null;
			}
			
			return tokenInfo;
		}
		
		/**
		 * Get attribute from current cursor position
		 * */
		public static function getAttributeName(editor:AceEditor, row:int, column:int):TokenInformation {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var qname:QName;
			var firstValue:Boolean;
			var tokenInfo:TokenInformation;
			var session:Object;
			
			if (AceEditor.isBrowser && editor.useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					var session;
					var token;
					var line;
					var type;
					var value;
					var found = false;
					var first = false;
					
					const XML_ATTRIBUTE_NAME = "entity.other.attribute-name.xml";
					
					session = editor!=null ? editor.session : null;
					
					if (session==null) {
						return false;
					}

					for (; row > -1; row--) {
						line = session.getLine(row);
						
						if (first) {
							column = line.length;
						}
						else {
							first = true;
						}
						
						for (; column>-1; column--) {
							token = session.getTokenAt(row, column);
							type = token ? token.type : "";
						
							if (type==XML_ATTRIBUTE_NAME) {
								value = token.value;
								column = token.start+1;
								found = true;
								break;
							}
						}
						
						if (found) break;
					}

					if (found) {
						token.row = row;
						token.column = column;
						return token;
					}

					return false;
				}
				]]></xml>;
				
				token = ExternalInterface.call(string, editor.editorIdentity, row, column);
				
				
				if (token) {
					found = true;
					value = token.value;
					row = token.row;
					column = token.column;
				}
			}
			else {
				session = editor.session;
				
				for (; row > -1; row--) {
					line = session.getLine(row);
					
					if (firstValue) {
						column = line.length;
					}
					else {
						firstValue = true;
					}
					
					for (; column>-1; column--) {
						token = session.getTokenAt(row, column);
						type = token ? token.type : "";
						
						if (type==XML_ATTRIBUTE_NAME) {
							value = token.value;
							found = true;
							break;
						}
					}
					
					if (found) break;
				}
			}
			
			
			tokenInfo = new TokenInformation();
			
			if (found) {
				qname = new QName("", value);
				tokenInfo.found = true;
				tokenInfo.row = row;
				tokenInfo.column = column;
				tokenInfo.tagName = qname;
				tokenInfo.token = token;
				tokenInfo.value = token ? token.value : null;
			}
			
			return tokenInfo;
		}
		
		/**
		 * Get id of tag from current cursor position
		 * */
		public static function getAttributeValue(editor:AceEditor, attribute:String, row:int, column:int):TokenInformation {
			var token:Object;
			var line:String;
			var type:String;
			var value:String;
			var found:Boolean;
			var notFound:Boolean;
			var attributeFound:Boolean;
			var session:Object;
			var totalLines:int;
			var columns:int;
			var tokenInfo:TokenInformation;
			var attributeName:String;
			var dataURIMatch:Array;
			var tokens:Array;
			
			attribute = attribute.toLowerCase();
			
			// first get tag
			tokenInfo = getTagName(editor, row, column);
			
			if (tokenInfo.row>-1 && tokenInfo.column>-1) {
				row = tokenInfo.row;
				column = tokenInfo.column;
			}
			
			if (row<0 || column<0) {
				return tokenInfo;
			}
			
			if (AceEditor.isBrowser && editor.useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, attribute, row, column) {
					var editor = ace.edit(id);
					var session = editor!=null ? editor.session : null;
					var token;
					var line;
					var type;
					var value;
					var notFound;
					var totalLines;
					var row;
					var column;
					var columns;
					var attributeFound = false;
					var found = false;
					var dataURIMatch;
					var tokens;
					
					const XML_END_TAG_OPEN = "meta.tag.punctuation.end-tag-open.xml";
					const XML_ATTRIBUTE_NAME = "entity.other.attribute-name.xml";
					const XML_ATTRIBUTE_VALUE = "string.attribute-value.xml";

					var dataURIExpPrefix = /\s*?data:image\/(png|jpeg);base64,/i;
					var dataURIExpFull = /\s*?data:image\/(png|jpeg);base64,([^]*)==/gi;
					
					if (session==null) return false;
					totalLines = session.getLength();
					
					for (var i=row; row<totalLines; row++) {
						line = session.getLine(row);
						columns = line.length;
					
						for (var j = column; column<columns; column++) {
							token = session.getTokenAt(row, column);
							if (token==null) break;
							type = token.type;
							value = token.value.toLowerCase();
							
							// found value - basic - expects value right after attribute name
							if (attributeFound && type==XML_ATTRIBUTE_VALUE) {
								value = token.value;
								found = true;
								break;
							}
							
							// found attribute
							if (type==XML_ATTRIBUTE_NAME && value==attribute) {
								attributeFound = true;
								attributeName = token.value;
							}
							
							if (type==XML_END_TAG_OPEN) {
								notFound = true;
							}
						
							// if we encounter data uri we should skip
							if (value && value.length>128) {
								dataURIMatch = value.match(dataURIExpPrefix);
								
								if (dataURIMatch!=null && dataURIMatch.length>0) {
									column = column+value.length-1;
									
									dataURIMatch = value.match(dataURIExpFull);
									//tokens = session.getTokens(row);
									
									// spans multiple lines or is data uri is malformed
									// if full match not found exit out of loop for now
									if (dataURIMatch==null) {
										row = totalLines;
										break;
									}
								}
							}
						}
							
						if (found || notFound) break;
					}
					
					if (found) {
						token.row = row;
						token.column = column;
						token.attributeName = attributeName;
						return token;
					}
					
					return false;
				}
				]]></xml>;
				
				token = ExternalInterface.call(string, editor.editorIdentity, attribute, row, column);
				
				if (token) {
					attributeName = token.attributeName;
					row = token.row;
					column = token.column;
					found = true;
				}
				
			}
			else {
				
				var useTokenIterator:Boolean;
				
				if (useTokenIterator) {
					// this is not tested
					var TokenIterator:Object;
					var stream:Object;
					var searching:Boolean;
					var searchLimit:int;
					
					TokenIterator = editor.ace.require("ace/token_iterator").TokenIterator;
					stream = new TokenIterator(editor.session, row, column);
					searching = true;
					searchLimit = getTimer();
					
					token = stream.getCurrentToken();
					
					while (token || searching) {
						token = stream.stepForward();
						
						if (!token || !(token.type == "storage.type" || token.type == "constant.character.escape")) {
							token = stream.stepForward();
							continue;
						}
						
						type = token ? token.type : "";
						value = token.value.toLowerCase();
						
						
						// found value - basic - expects value right after attribute name
						if (attributeFound && type==XML_ATTRIBUTE_VALUE) {
							value = token.value;
							found = true;
							break;
						}
						
						// found attribute
						if (type==XML_ATTRIBUTE_NAME && value==attribute) {
							attributeFound = true;
							attributeName = token.value;
						}
						
						if (type==XML_END_TAG_OPEN) {
							notFound = true;
						}
						
						if (found || notFound) break;
					}
				}
				else {
				
					session = editor.session;
					totalLines = session.getLength();
					
					for (;row<totalLines; row++) {
						line = session.getLine(row);
						columns = line.length;
						
						for (column = 0; column<columns; column++) {
							token = session.getTokenAt(row, column);
							type = token ? token.type : "";
							value = token.value.toLowerCase();
							
							// found value - basic - expects value right after attribute name
							if (attributeFound && type==XML_ATTRIBUTE_VALUE) {
								value = token.value;
								found = true;
								break;
							}
							
							// found attribute
							if (type==XML_ATTRIBUTE_NAME && value==attribute) {
								attributeFound = true;
								attributeName = token.value;
							}
							
							if (type==XML_END_TAG_OPEN) {
								notFound = true;
							}
							
							// if we encounter data uri we should skip
							if (value && value.length>128) {
								dataURIMatch = value.match(dataURIExpPrefix);
								
								if (dataURIMatch!=null && dataURIMatch.length>0) {
									column = column+value.length-1;
									
									dataURIMatch = value.match(dataURIExpFull);
									//tokens = session.getTokens(row);
									
									// spans multiple lines or is data uri is malformed
									// if full match not found exit out of loop for now
									if (dataURIMatch==null) {
										row = totalLines;
										break;
									}
								}
							}
						}
						
						if (found || notFound) break;
					}
				}
			}
			
			if (found) {
				tokenInfo.found = true;
				tokenInfo.attributeName = new QName("", attributeName);
				tokenInfo.row = row;
				tokenInfo.column = column;
				tokenInfo.token = token;
				tokenInfo.value = token ? token.value : null;
				tokenInfo.innerValue = token ? token.value.replace(/(^"|')(.*)("|'$)/, "$2") : null;
			}
			
			return tokenInfo;
			
		}
		
		public static var dataURIExpPrefix:RegExp = /\s*?data:image\/(png|jpeg);base64,/i;
		public static var dataURIExpFull:RegExp = /\s*?data:image\/(png|jpeg);base64,(.*)==/gsi;
		
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
		 * Get an array of auto complete suggestions for an attribute
		 * */
		public static function getAttributeValueSuggestions(memberMetaData:MetaData):Array {
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
		
		public static function getTokenInformation(aceEditor:AceEditor, qualifyToTargetNamespace:Boolean = false):TokenInformation {
			var cursor:Object = aceEditor.getCursor();
			var token:Object = aceEditor.getTokenAt(cursor.row, cursor.column);
			var tokenType:String = token ? token.type : null;
			var prefixedClassName:String = "";
			var classFound:Boolean;
			var uriQName:QName;
			var classObject:Object;
			var tagQName:QName;
			var idTokenInfo:TokenInformation;
			var tagTokenInfo:TokenInformation;
			var attributeTokenInfo:TokenInformation;
			var attributeQName:QName;
			var qualifiedClassName:String;
			var classRegistry:ClassRegistry;
			var tokenInfo:TokenInformation;
			
			tokenInfo = new TokenInformation();
			
			if (classRegistry==null) classRegistry = ClassRegistry.getInstance();
			
			tagTokenInfo = getTagName(aceEditor, cursor.row, cursor.column);
			tagQName = tagTokenInfo.tagName;
			idTokenInfo = getAttributeValue(aceEditor, "id", tagTokenInfo.row, tagTokenInfo.column);
			tokenInfo.idToken = idTokenInfo;
			
			tokenInfo.cursor = cursor;
			tokenInfo.token = token;
			tokenInfo.tagName = tagQName;
			tokenInfo.tokenType = tokenType;
			
			if (tagQName!=null) {
				prefixedClassName = tagQName.localName; // returns "s:Button"
				// from "s:Button" it returns "new QName("library://ns.adobe.com/flex/spark", "Button")"
				uriQName = classRegistry.getQNameForPrefixedName(prefixedClassName, null, qualifyToTargetNamespace);
				classObject = classRegistry.getClass(uriQName);
				qualifiedClassName = classRegistry.getClassName(uriQName);
				
				tokenInfo.uriTagName = uriQName;
				tokenInfo.entity = prefixedClassName;
				tokenInfo.classFound = classObject!=null;
				tokenInfo.classObject = classObject;
				tokenInfo.qualifiedClassName = qualifiedClassName;
				
				//PerformanceMeter.mark("After getQNameForPrefixedName");
				
				// if in or next to an attribute gets the meta data of the attribute
				if (tokenType==XML_ATTRIBUTE_VALUE || tokenType==XML_ATTRIBUTE_EQUALS || tokenType==XML_ATTRIBUTE_NAME) {
					attributeTokenInfo = getAttributeName(aceEditor, cursor.row, cursor.column);
					attributeQName = attributeTokenInfo.tagName;
					
					if (classObject && attributeQName) {
						tokenInfo.attributeMetaData = ClassUtils.getMetaDataOfMember(classObject, attributeQName.localName);
					}
					else {
						tokenInfo.attributeMetaData = null;
					}
					//PerformanceMeter.mark("After getXMLAttributeQNameFromCursorPosition");
					
					tokenInfo.attributeName = attributeQName;
					//tokenInfo.qualifiedClassName = null;
				}
				else if (tokenType==XML_TEXT) {
					// if in empty text (white space) gets the class of the parent node
					//qualifiedClassName = getQualifiedClassName(FlexGlobals.topLevelApplication);
					
					if (cachedClassValues[qualifiedClassName]==null) {
						///suggestions = classRegistry.getPrefixedClassNames();
						/// suggestions = getObjectsFromArray(suggestions, "Classes", null, false, true);
						//PerformanceMeter.mark("After getObjectsFromArray");
						///cachedClassValues[qualifiedClassName] = suggestions;
						///aceEditor.setCompleterValues(qualifiedClassName, suggestions);
					}
					else {
						///suggestions = cachedClassValues[qualifiedClassName];
						//aceEditor.setCompleterValues(qualifiedClassName, null);
					}
					
					tokenInfo.attributeName = null;
					tokenInfo.qualifiedClassName = qualifiedClassName;
					
					return tokenInfo;
				}
				
			}
			
			return tokenInfo;
		}
		
		public static function getSuggestionList(tokenInfo:TokenInformation, aceEditor:AceEditor = null):Array {
			var qualifiedClassName:String;
			var classRegistry:ClassRegistry;
			var suggestions:Array;
			var tokenType:String;
			var classObject:Object;
			
			if (tokenInfo==null) {
				return [];
			}
			
			tokenType = tokenInfo.tokenType;
			classObject = tokenInfo.classObject;
			
			classRegistry = ClassRegistry.getInstance();
			
			// List Class names
			//if (tokenType==XML_TEXT || tokenType==XML_TAG_OPEN) {
			if (tokenType==XML_TEXT) {
				// for now we are using the top level application to cache suggestions
				qualifiedClassName = getQualifiedClassName(FlexGlobals.topLevelApplication);
				
				// check cache
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
				
				//tokenInformation.attributeName = null;
				//tokenInformation.qualifiedClassName = qualifiedClassName;
				
				return suggestions;
			}
			
			if (tokenInfo.classFound) {
				qualifiedClassName = tokenInfo.qualifiedClassName;
				
				// List for Attribute values
				if (tokenInfo.attributeName && (tokenType==XML_ATTRIBUTE_VALUE || tokenType==XML_ATTRIBUTE_EQUALS)) {
					suggestions = getAttributeValueSuggestions(tokenInfo.attributeMetaData);
					aceEditor.setCompleterValues(tokenInfo.qualifiedClassName, suggestions, tokenInfo.attributeName.localName);
				}
				else {
					
					// List members of Class - check chache
					if (cachedClassValues[qualifiedClassName]==null) {
						suggestions = getMemberSuggestionListFromObject(classObject);
						aceEditor.setCompleterValues(qualifiedClassName, suggestions);
						cachedClassValues[qualifiedClassName] = suggestions;
					}
					else {
						suggestions = cachedClassValues[qualifiedClassName];
						aceEditor.setCompleterValues(qualifiedClassName, null);
					}
				}
			}
			else {
				suggestions = [];
			}
			
			return suggestions;
		}
		
		public static function getAutoCompleteList(aceEditor:AceEditor):Array {
			var cursor:Object = aceEditor.getCursor();
			var token:Object = aceEditor.getTokenAt(cursor.row, cursor.column);
			var type:String = token ? token.type : null;
			var entity:String = "";
			var classFound:Boolean;
			var prefixedQName:QName;
			var classObject:Object;
			var tagTokenInfo:TokenInformation;
			var attributeTokenInfo:TokenInformation;
			var tagQName:QName;
			var attributeQName:QName;
			var qualifiedClassName:String;
			var classRegistry:ClassRegistry;
			var suggestions:Array;
			
			if (tokenInformation==null) {
				tokenInformation = new TokenInformation();
			}
			
			classRegistry = ClassRegistry.getInstance();
			
			tagTokenInfo = getTagName(aceEditor, cursor.row, cursor.column);
			tagQName = tagTokenInfo.tagName;
			
			//PerformanceMeter.mark("After AceUtils.getTagName");
			
			//tagQName = aceEditor.getTagName(cursor.row, cursor.column) as QName;
			
			//PerformanceMeter.mark("After aceEditor.getTagName");
			
			tokenInformation.cursor = cursor;
			tokenInformation.token = token;
			tokenInformation.tagName = tagQName;
			tokenInformation.type = type;
			
			if (tagQName!=null) {
				prefixedQName = classRegistry.getQNameForPrefixedName(tagQName.localName);
				entity = tagQName.localName;
				classObject = classRegistry.getClass(prefixedQName);
				
				tokenInformation.uriTagName = prefixedQName;
				tokenInformation.entity = entity;
				tokenInformation.classFound = classObject!=null;
				tokenInformation.classObject = classObject;
				//PerformanceMeter.mark("After getQNameForPrefixedName");
				
				
				if (type==XML_ATTRIBUTE_VALUE || type==XML_ATTRIBUTE_EQUALS || type==XML_ATTRIBUTE_NAME) {
					attributeTokenInfo = getAttributeName(aceEditor, cursor.row, cursor.column);
					attributeQName = attributeTokenInfo.tagName;
					
					if (classObject) {
						tokenInformation.attributeMetaData = ClassUtils.getMetaDataOfMember(classObject, attributeQName.localName);
					}
					else {
						tokenInformation.attributeMetaData = null;
					}
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
					//tokenInformation.classMetaData;
					
					if (attributeQName && type==XML_ATTRIBUTE_VALUE) {
						tokenInformation.attributeMetaData = ClassUtils.getMetaDataOfMember(classObject, attributeQName.localName);
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