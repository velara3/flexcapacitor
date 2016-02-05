

package com.flexcapacitor.utils
{
	import com.flexcapacitor.utils.supportClasses.XMLValidationInfo;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * A set of utilities for working with XML
	 * */
	public class XMLUtils extends EventDispatcher {
		
		public function XMLUtils() {
			
		}
		
		// I don't know if this is the correct method to identify byte order markers 60% confident
		// Sources: Wikipedia
		// 
		
		// While identifying text as UTF-8, this is not really a "byte order" mark. Since the byte 
		// is also the word in UTF-8, there is no byte order to resolve.
		public static const UTF_8:RegExp 		= /^\xEF\xBB\xBF/;
		public static const UTF_16_BE:RegExp 	= /^\xFE\xFF/;
		public static const UTF_16_LE:RegExp 	= /^\xFF\xFE/;
		public static const UTF_32_BE:RegExp 	= /^..\xFE\xFF/; // using . instead of /\x00\x00\xFE\xFF/;
		public static const UTF_32_LE:RegExp 	= /^\xFF\xFE../;
		
		// 2B 2F 76, and one of the following: [ 38 | 39 | 2B | 2F ][t 2]
		// In UTF-7, the fourth byte of the BOM, before encoding as base64, is 001111xx in binary, 
		// and xx depends on the next character (the first character after the BOM). 
		// Hence, technically, the fourth byte is not purely a part of the BOM, 
		// but also contains information about the next (non-BOM) character. 
		// For xx=00, 01, 10, 11, this byte is, respectively, 38, 39, 2B, or 2F when encoded 
		// as base64. If no following character is encoded, 38 is used for the fourth byte 
		// and the following byte is 2D.
		public static const UTF_7:RegExp		= /^\x2B\x2F\x76/; // NOT TESTED
		
		public static const UTF_1:RegExp		= /^\xF7\x64\x4C/;
		public static const UTF_EBCDIC:RegExp 	= /^\xDD\x73\x66\x73/;
		
		// SCSU allows other encodings of U+FEFF, the shown form is the signature recommended in UTR #6
		public static const SCSU:RegExp			= /^\x0E\xFE\xFF/;
		
		// For BOCU-1 a signature changes the state of the decoder. Octet 0xFF resets the decoder to the initial state.
		public static const BOCU_1:RegExp		= /^\xFB\xEE\x28/; // FB EE 28 optionally followed by FF
		public static const GB_18030:RegExp		= /^\x84\x31\x95\x33/;
		
		/**
		 * Constant representing a element type returned from XML.nodeKind.
		 *
		 * @see XML.nodeKind()
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static const ELEMENT:String = "element";
		
		public static var addedXMLValidationToPage:Boolean;
		
		public static var notInitializedMessage:String = "The validateXML() call was invalid. You must call initialize() a few frames before calling validateXML().";
		
		public static var validationError:Error;
		
		public static var validationErrorMessage:String;
		
		public static var htmlLoader:Object;
		
		public static var htmlLoaderLoaded:Boolean;
		
		/**
		 * Set xml object node with the given value
		 * */
		public static function setItemContents(xml:XML, propertyName:String = "content", value:Object=""):XML {
			if (xml) {
				if (value is String) {
					// The following code may do what we want - need to check
					// XML(item.content).insertChildAfter(null, wrapInCDATA(String(value)));
					//TypeError: Error #1088: The markup in the document following the root element must be well-formed.
					// -- property name is not in xml
					if (!(propertyName in xml)) {
						xml[propertyName] = new XML();
					}
					XML(xml[propertyName]).replace(0, encloseInCDATA(String(value)));
				}
				else if (value is XML) {
					// right now we are not doing anything special in XML cases
					//XML(xml.content) = (0, encloseInCDATA(String(value)));
					XML(xml.content)[0] = XML(value);
				}
			}
			
			return xml;
		}
		
		/**
		 * Wraps the value in CDATA tags. 
		 *
		 * For example, 
 * <pre>
 * var xml:XML = encloseInCDATA("Some value");
 * </pre>
 * 
 * Append to a node: 
 * <pre>
 * var value:String = "&lt;span>Hello&lt;/span>";
 * var xml:XML = &lt;p/>;
 * xml.appendChild(encloseInCDATA(value));
 * </pre>
		 * */
		public static function encloseInCDATA(value:String):XML {
			var xml:XML = new XML("<![" + "CDATA[" + value + "]]" + ">");
			return xml;
		}
		
		/**
		 * Encodes values that are not allowed in attribute quotes. 
		 * Replaces double quote, ampersand, less than sign and greater than sign. 
		 * For example, replaces double quote with "&quot;"
		 * Use decodeAttributeString() when reading values. 
		 * 
		 * @see #decodeAttributeString()
		 * */
		public static function getAttributeSafeString(value:String = ""):String {
			var outputValue:String = value;
			outputValue = outputValue.replace(/&(?!amp;)/g, "&amp;");
			outputValue = outputValue.replace(/"/g, "&quot;");
			outputValue = outputValue.replace(/</g, "&lt;");
			outputValue = outputValue.replace(/>/g, "&gt;");
			outputValue = outputValue.replace(/\n/g, "&#10;");
			return outputValue;
		}
		
		/**
		 * Decodes HTML entities that are not allowed in attribute quotes. 
		 * Replaces double quote, ampersand, less than sign and greater than sign. 
		 * 
		 * For example, replaces "&quot;" with double quote.
		 * Use getAttributeSafeString() when writing values. 
		 * 
		 * @see #getAttributeSafeString()
		 * */
		public static function decodeAttributeString(value:String = ""):String {
			var outputValue:String = value.replace(/&quot;/g, '"');
			outputValue = outputValue.replace(/&amp;/g, "&");
			outputValue = outputValue.replace(/&lt;/g, "<");
			outputValue = outputValue.replace(/&gt;/g, ">");
			outputValue = outputValue.replace(/&#10;/g, "\n");
			return outputValue;
		}
		
		/**
		 * Checks whether the specified string is valid and well formed XML. Uses the Flash Player
		 * XML parser. Use the ValidateXML method to return more information
		 * and check the validationError and validationErrorMessage properties.  
		 *
		 * @param data The string that is being checked to see if it is valid XML.
		 *
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 *
		 * @see #Validate
		 */
		public static function isValidXML(value:String):Boolean {
			var xml:XML;
			
			try {
				xml = new XML(value);
			}
			catch (error:Error) {
				// Usually: TypeError - Error #1088: The markup in the document following the root element must be well-formed.
				validationError = error;
				validationErrorMessage = error.message;
				return false;
			}
			
			if (xml.nodeKind() != ELEMENT) {
				validationErrorMessage = "XML node kind is not element";
				return false;
			}
			
			return true;
		}
		
		/**
		 * Checks whether the specified string is valid and well formed XML. Uses the Flash Player
		 * XML parser.  
		 *
		 * @param data The string that is being checked to see if it is valid XML.
		 *
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 *
		 * @see #Validate
		 */
		public static function getValidationXML(value:String):Object {
			var xml:XML;
			var object:Object = {};
			object.isValid = false;
			
			try {
				xml = new XML(value);
				object.isValid = true;
			}
			catch (error:Error) {
				// Usually: TypeError - Error #1088: The markup in the document following the root element must be well-formed.
				object.error = error;
				object.message = error.message;
				return object;
			}
			
			if (xml.nodeKind() != ELEMENT) {
				object.message = "XML node kind is not element";
				return object;
			}
			
			return object;
		}
		
		/**
		 * Checks whether the specified string is valid HTML or XML. Uses the browser XML 
		 * validator. You must write the JavaScript to the page before calling this method.
		 * Call initialize() a few frames before calling this method. 
		 * We use the browser XML validation because it gives row and column information.
		 * We use the Flash Player XML validation because it gives verbose error messages.
		 * 
		 * @param value The string that is being checked to see if it is valid HTML or XML.
		 * @return An array with the original value in the first item and any errors in the proceeding items
		 * @see isValid
		 */
		public static function validateXML(value:*, useFlashParser:Boolean = true, useBrowserParser:Boolean = true):XMLValidationInfo {
			var validationInfo:XMLValidationInfo;
			var result:String;
			
			if (value==null) value = "";
			
			if (ExternalInterface.available) {
				result = ExternalInterface.call("validateXML", value);
				validationInfo = parseValidationResult(result, value);
			}
			else if (Capabilities.playerType == "Desktop") {
				var isValid:Boolean;
				var htmlText:String;
				
				if (htmlLoader==null) {
					throw new Error(notInitializedMessage);
				}
				
				if (htmlLoader.window && htmlLoader.window.validateXML) {
					result = htmlLoader.window.validateXML(value);
					validationInfo = XMLUtils.parseValidationResult(result, value);
				}
				
			}
			
			if (validationInfo==null) {
				validationInfo = new XMLValidationInfo();
			}
			
			if (useFlashParser) {
				isValid = isValidXML(value);
				validationInfo.valid = isValid;
				validationInfo.internalErrorMessage = validationErrorMessage;
				validationInfo.error = validationError;
			}
			
			return validationInfo;
		}
		
		/**
		 * Call this method at least a few frames before calling validateXML()
		 * @see #validateXML()
		 * @see htmlLoaderLoaded
		 * */
		public static function initialize():void {
			
			if (Capabilities.playerType == "Desktop") {
				var htmlText:String = "<html><script>"+XMLUtils.browserXMLValidationScript+"</script><body></body></html>";
				htmlLoader = HTMLUtils.createLoaderInstance();
				htmlLoader.loadString(htmlText);
				htmlLoader.addEventListener(Event.COMPLETE, function(e:Event):void {htmlLoaderLoaded = true;});
			}
			else if (ExternalInterface.available) {
				insertValidationScript();
			}
		}
		
		/**
		 * Checks whether the specified string is valid and well formed XML. Uses the browser XML 
		 * validator and Flash Player XML parser. 
		 * Use the isValidXML method to return true and false. 
		 *
		 * @param data The string that is being checked to see if it is valid XML.
		 *
		 * @return An array with the original value in the first item and any errors in the proceeding items
		 * 
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see isValid
		 */
		public static function validate(value:*, callbackFunction:Function = null, callbackValidation:Object = null):XMLValidationInfo {
			var xml:String = value != null ? value : "";
			var validationInfo:XMLValidationInfo;
			var validationResult:String;
			var byteMarkerType:String;
			var isValidMarker:Boolean;
			var characterCount:int;
			var lastLine:String;
			var isValid:Boolean;
			var matchIndex:int;
			var results:Array;
			var lines:Array;
			var column:int;
			var row:int;
			
			if (!addedXMLValidationToPage) {
				throw new Error(notInitializedMessage);
			}			
			
			if (ExternalInterface.available) {
				validationResult = ExternalInterface.call("validateXML", xml);
			}
			else if (Capabilities.playerType == "Desktop") {
				
				if (callbackValidation) {
					validationResult = callbackValidation.result;
				}
				else {
					var stageWebView:String = "flash.media.StageWebView";
					if (ApplicationDomain.currentDomain.hasDefinition(stageWebView)) {
						var definition:Object = getDefinitionByName(stageWebView);
						var instance:Object = new definition();
						
						instance.addEventListener("locationChanging", function (event:Object):void {
							var locationValue:String = event.location;
							
							try {
								// check if it's an event dispatched from JS
								var object:Object = JSON.parse(locationValue);
								var eventName:String = object.event;
								var methodName:String = object.method;
								validate(value, callbackFunction, object);
							}
							catch (error:Error) {
								//validate(value, callbackFunction, object);
							}
						});
						
						instance.addEventListener(ErrorEvent.ERROR, function (error:ErrorEvent):void {
							trace("Error:" + error.toString());
						});
						var out:String = ""
						instance.loadURL("javascript:"+XMLUtils.browserXMLValidationScript);
						var output:String = "javascript:validateXMLWebView(\""+JSON.stringify(xml)+"\")";
						instance.loadURL(output);
					}
				}
			}
			
			validationInfo = parseValidationResult(validationResult, value);
			
			var hasMarker:Boolean = hasByteOrderMarker(value);
			
			if (hasMarker) {
				byteMarkerType = XMLUtils.getByteOrderMarkerType(value);
				validationInfo.hasMarker = true;
				validationInfo.byteMarkerType = byteMarkerType;
			}
			else {
				byteMarkerType = "";
			}
			
			if (callbackFunction!=null) {
				callbackFunction(validationInfo);
			}
			
			return validationInfo;
		}
		
		public static function parseValidationResult(result:String, value:String):XMLValidationInfo {
			var validationInfo:XMLValidationInfo = new XMLValidationInfo();
			var isMozilla:Boolean;
			var isChrome:Boolean;
			var characterCount:int;
			var lastLine:String;
			var isValid:Boolean;
			var matchIndex:int;
			var results:Array;
			var lines:Array;
			var column:int;
			var row:int;
			var errorLines:Array;
			var specificError:String;
			
			if (result) {
				isMozilla = (result.indexOf("XML Parsing Error:") != -1);
				isChrome = (result.indexOf("This page contains the following errors:") != -1);
			}
			
			// error - xml is not valid
			if (isChrome || isMozilla) {
				
				// get row and column
				if (isMozilla) {
					lines = result.match(/Line\s+Number\s+(\d+),\s+Column\s+(\d+):/i);
					row = lines.length > 1 ? lines[1] : 0;
					column = lines.length > 2 ? lines[2] : 0;
					validationInfo.row = row;
					validationInfo.column = column;
					lines = result.split(/:/);
					if (lines.length>3) {
						specificError = StringUtils.trim(lines.slice(2).join(":"));
					}
				}
				else if (isChrome) {
					lines = result.match(/line\s+(\d+)\s+at\s+column\s+(\d+):/i);
					row = lines.length > 1 ? lines[1] : 0;
					column = lines.length > 2 ? lines[2] : 0;
					validationInfo.row = row;
					validationInfo.column = column;
					lines = result.split(/:/);
					if (lines.length>3) {
						specificError = StringUtils.trim(lines.slice(2).join(":"));
					}
				}
				
				
				validationInfo.valid = false;
				
				var browserMessage:String = result.replace(/Location:.*/g, "");
				
				validationInfo.browserErrorMessage = browserMessage;
				validationInfo.specificErrorMessage = specificError;
				
				lines = value.split("\n");
				lastLine = value;
				characterCount = column;
				
				// get index of error based on column and row
				if (row < lines.length) {
					for (var i:int; i < row; i++) {
						characterCount += lines[i].length - 1;
						lastLine = lines[i];
					}
					
					validationInfo.value = value;
					matchIndex = value.search(lastLine);
					//xmlTextArea.selectRange(matchIndex + column - row, xmlTextArea.text.length);
					validationInfo.beginIndex = matchIndex + column - row;
					validationInfo.endIndex = value.length;
					
				}
				
			}
			else if (result && result.indexOf("No errors found") != -1) {
				validationInfo.valid = true;
			}
			else {
				validationInfo.valid = false;
			}
			
			return validationInfo;
		}
		
		/**
		 * Converts a XMLList to string values and places them in an array.
		 * 
		 * @param list XMLList of items to convert
		 * @param toSimpleContent uses xml.toString() if true and xml.toXMLString() if false
		 * @see XML.toString()
		 * @see XML.toXMLString()
		 * */
		public static function convertXMLListToArray(list:XMLList, toSimpleContent:Boolean = false):Array {
			var result:Array = [];
			
			for each (var node:XML in list) {
				
				if (toSimpleContent) {
					result.push(node.toString());
				}
				else {
					result.push(node.toXMLString());
				}
			}
			
			return result;
		}
		
		/**
		 * Get list of childnode names from a node
		 * Local allows you to get the local value or full value. 
		 * For example, with the XML:  
		 * 
 * <pre>
 * &lt;s:HGroup xmlns:s="library://ns.adobe.com/flex/spark">
 * </pre>
		 * Returns "HGroup" when local is true or
		 * "library://ns.adobe.com/flex/spark::HGroup" when local is false. 
		 * 
		 * @param node XML item
		 * @param local indicates to return the local name or full name
		 * */
		public static function getChildNodeNames(node:XML, local:Boolean = true):Array {
			var result:Array = [];
			var name:String;
			
			for each (var childNode:XML in node.children()) {
				
				if (!local) {
					name = childNode.name().toString();
				}
				else {
					name = childNode.localName();
				}
				
				result.push(name);
			}
			
			return result;
		}
		
		/**
		 * Returns true if node has attribute. Not handing namespaces.
		 * 
		 * @param node XML item
		 * @return true if attribute exists
		 * */
		public static function hasAttribute(node:XML, attribute:String):Boolean {
			var attributes:Array = node ? getAttributeNames(node) : [];
			var exists:Boolean = (attributes.indexOf(attribute)!=-1);
			
			return exists;
		}
		
		/**
		 * Get list of attribute names from a node
		 * 
		 * @param node XML item
		 * */
		public static function getAttributeNames(node:XML):Array {
			var result:Array = [];
			var attributeName:String;
			
			for each (var attribute:XML in node.attributes()) {
				attributeName = attribute.name().toString();
				
				/*
				var a:Object = attribute.namespace().prefix     //returns prefix i.e. rdf
				var b:Object = attribute.namespace().uri        //returns uri of prefix i.e. http://www.w3.org/1999/02/22-rdf-syntax-ns#
				
				var c:Object = attribute.inScopeNamespaces()   //returns all inscope namespace as an associative array like above
				
				//returns all nodes in an xml doc that use the namespace
				var nsElement:Namespace = new Namespace(attribute.namespace().prefix, attribute.namespace().uri);
				
				var usageCount:XMLList = attribute..nsElement::*;
				*/
				result.push(attributeName);
			}
			
			return result;
		}
		
		/**
		 * Get name value pair from attributes from a node
		 * 
		 * @param node XML item
		 * */
		public static function getAttributesValueObject(node:XML):Object {
			var result:Object = {};
			var attributeName:String;
			
			for each (var attribute:XML in node.attributes()) {
				attributeName = attribute.name().toString();
				
				result[attributeName] = decodeAttributeString(attribute.toString());
			}
			
			return result;
		}
		
		/**
		 * Takes the trailing "/>" off and puts on a ">"
		 * */
		public static function getOpeningTag(xml:XML):String {
			var result:String = xml.toXMLString();
			
			result = result.substr(0, result.length-2) + ">";
			
			return result;
		}
		
		/**
		 * Get name value pair from child nodes
		 * 
		 * Returns a string representation of the XML object. The rules for this conversion depend 
		 * on whether the XML object has simple content or complex content: <br><br>
		 * 
		 * If the XML object has simple content, toString() returns the String contents of the XML object 
		 * with the following stripped out: the start tag, attributes, namespace declarations, and end tag.<br><br>
		 * 
		 * If the XML object has complex content, toString() returns an XML encoded String representing 
		 * the entire XML object, including the start tag, attributes, namespace declarations, and end tag.<br><br>
		 * 
		 * @param node XML item
		 * */
		public static function getChildNodesValueObject(node:XML, local:Boolean = true, toSimpleString:Boolean = true):Object {
			var result:Array = [];
			var nodeName:String;
			
			for each (var childNode:XML in node.children()) {
				
				if (!local) {
					nodeName = childNode.name().toString();
				}
				else {
					nodeName = childNode.localName();
				}
				
				if (toSimpleString) {
					result[nodeName] = childNode.toString();
				}
				else {
					result[nodeName] = childNode.toXMLString();
				}
			}
			
			return result;
		}
		
		/**
		 * Checks for a Byte-Order-Marker or BOM at the beginning of the text. This character is invisible in many text editors.
		 * This will break many XML parsers since no characters are allowed before the XML declaration. Some editors, such as 
		 * Windows Notepad, automatically insert a byte order marker in UTF-8 files. 
		 * To fix it save the file as ANSI or use another editor to save your file (one that does not insert this marker) 
		 * or strip it out before passing it to the XML parser. Check the size of an empty file. 
		 * 
		 * When creating a new file, save it before entering anything in and then check the size. It should be 0 bytes.
		 * 
		 * More info at https://secure.wikimedia.org/wikipedia/en/wiki/Byte_Order_Mark
		 * 
		 * Tip: Use a RegExp to search for the Unicode character FEFF
		 * */
		public static function hasByteOrderMarker(value:*):Boolean {
			var hasBOM:Boolean;
			
			// While identifying text as UTF-8, this is not really a "byte order" mark. Since the byte 
			// is also the word in UTF-8, there is no byte order to resolve.
			var hasUTF_8:Boolean 		= UTF_8.test(value);
			var hasUTF_16_BE:Boolean 	= UTF_16_BE.test(value);
			var hasUTF_16_LE:Boolean 	= UTF_16_LE.test(value);
			var hasUTF_32_BE:Boolean 	= UTF_32_BE.test(value);
			var hasUTF_32_LE:Boolean 	= UTF_32_LE.test(value);
			
			// 2B 2F 76, and one of the following: [ 38 | 39 | 2B | 2F ][t 2]
			// In UTF-7, the fourth byte of the BOM, before encoding as base64, is 001111xx in binary, 
			// and xx depends on the next character (the first character after the BOM). 
			// Hence, technically, the fourth byte is not purely a part of the BOM, 
			// but also contains information about the next (non-BOM) character. 
			// For xx=00, 01, 10, 11, this byte is, respectively, 38, 39, 2B, or 2F when encoded 
			// as base64. If no following character is encoded, 38 is used for the fourth byte 
			// and the following byte is 2D.
			var hasUTF_7:Boolean		= UTF_7.test(value);
			
			var hasUTF_1:Boolean		= UTF_1.test(value);
			var hasUTF_EBCDIC:Boolean 	= UTF_EBCDIC.test(value);
			
			// SCSU allows other encodings of U+FEFF, the shown form is the signature recommended in UTR #6
			var hasSCSU:Boolean			= SCSU.test(value);
			
			// For BOCU-1 a signature changes the state of the decoder. Octet 0xFF resets the decoder to the initial state.
			var hasBOCU_1:Boolean		= BOCU_1.test(value); // FB EE 28 optionally followed by FF
			var hasGB_18030:Boolean		= GB_18030.test(value);
			
			
			if (hasUTF_8 || hasUTF_16_BE || hasUTF_16_BE || 
				hasUTF_32_BE || hasUTF_32_LE || hasUTF_7 ||
				hasUTF_1 || hasUTF_EBCDIC || hasSCSU ||
				hasBOCU_1 || hasGB_18030) {
				
				hasBOM = true;
			}
			
			return hasBOM;
		}
		
		/**
		 * Get byte order marker type if it exists
		 * */
		public static function getByteOrderMarkerType(value:*):String {
			
			
			// While identifying text as UTF-8, this is not really a "byte order" mark. Since the byte 
			// is also the word in UTF-8, there is no byte order to resolve.
			if (UTF_8.test(value)) {
				return "UTF-8";
			}
			else if (UTF_16_BE.test(value)) {
				return "UTF-16 (BE)";
			}
			else if (UTF_16_LE.test(value)) {
				return "UTF-16 (LE)";
			}
			else if (UTF_32_BE.test(value)) {
				return "UTF-32 (BE)";
			}
			else if (UTF_32_LE.test(value)) {
				return "UTF-32 (LE)";
			}
			
			// 2B 2F 76, and one of the following: [ 38 | 39 | 2B | 2F ][t 2]
			// In UTF-7, the fourth byte of the BOM, before encoding as base64, is 001111xx in binary, 
			// and xx depends on the next character (the first character after the BOM). 
			// Hence, technically, the fourth byte is not purely a part of the BOM, 
			// but also contains information about the next (non-BOM) character. 
			// For xx=00, 01, 10, 11, this byte is, respectively, 38, 39, 2B, or 2F when encoded 
			// as base64. If no following character is encoded, 38 is used for the fourth byte 
			// and the following byte is 2D.
			else if (UTF_7.test(value)) {
				return "UTF-7";
			}
			else if (UTF_1.test(value)) {
				return "UTF-1";
			}
			else if (UTF_EBCDIC.test(value)) {
				return "UTF-EBCDIC";
			}
			
			// SCSU allows other encodings of U+FEFF, the shown form is the signature recommended in UTR #6
			else if (SCSU.test(value)) {
				return "SCSU";
			}
			
			// For BOCU-1 a signature changes the state of the decoder. Octet 0xFF resets the decoder to the initial state.
			else if (BOCU_1.test(value)) {
				return "BOCU-1";
			}
			else if (GB_18030.test(value)) {
				return "GB-18030";
			}
			
			return "false";
		}
		
		/**
		 * Adds the JavaScript method in the browser web page to validate XML. 
		 * Must be called before the JavaScript validation calls will work
		 * */
		public static function insertValidationScript():void {
			//ExternalInterface.addCallback("universalCallback", universalCallback);
			insertScript(); // may need to call later callLater()
		}
		
		private static function insertScript():void {
			ExternalInterface.call("eval", browserXMLValidationScript);
			addedXMLValidationToPage = true;
		}
		
		/**
		 * Used as a callback from the browser DOM. Not used at this time. 
		 * */
		private static function universalCallback(... rest):void {
			//lastResult = String(rest[0]);
			//trace("WHEN??? universalCallback = " + rest[0]);
		}
		
		/**
		 * Javascript XML Validation Code - source W3C Validator
		 * This is written to the HTML page on load
		 * Note: wherever we have linebreaks we have to escape them - \n -> \\n
		 * */
		public static var browserXMLValidationScript:XML = <root><![CDATA[
				var xt = "";
				var h3OK = 1;
				
				function checkErrorXML(x) {
					xt = ""
					h3OK = 1
					checkXML(x)
				}
				
				function checkXML(n) {
					var l;
					var i;
					var nam;
					nam = n.nodeName;
				
					if (nam=="h3") {
						if (h3OK==0) {
							return;
						}
						h3OK = 0;
					}
				
					if (nam == "#text") {
						xt = xt + n.nodeValue + "\\n";
					}
				
					l = n.childNodes.length
				
					for (i = 0; i < l; i++) {
						checkXML(n.childNodes[i])
					}
				
				}
				
				function validateXML(txt) {
				
					// code for IE
					if (window.ActiveXObject) {
						var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async = "false";
						xmlDoc.loadXML(txt);
						
						if (xmlDoc.parseError.errorCode != 0) {
							txt = "Error Code: " + xmlDoc.parseError.errorCode + "\\n";
							txt = txt + "Error Reason: " + xmlDoc.parseError.reason;
							txt = txt + "Error Line: " + xmlDoc.parseError.line;
							return txt;
						}
						else {
							return "No errors found";
						}
					}
				
					// code for Mozilla, Firefox, Opera, etc.
					else if (document.implementation.createDocument) {
						var parser = new DOMParser();
						var text = txt;
						// can also use "application/xml", image/svg+xml, text/html
						//- https://developer.mozilla.org/en-US/docs/Web/API/DOMParser
						// enum SupportedType {
						//    "text/html",
						//    "text/xml",
						//    "application/xml",
						//    "application/xhtml+xml",
						//    "image/svg+xml"
						//}
						//- https://w3c.github.io/DOM-Parsing/
						var xmlDoc = parser.parseFromString(text, "text/xml");
					
						if (xmlDoc.getElementsByTagName("parsererror").length > 0) {
							checkErrorXML(xmlDoc.getElementsByTagName("parsererror")[0]);
							return xt;
						}
						else {
							return "No errors found";
						}
					}
					else {
						return "Your browser cannot handle the truth. I mean XML validation";
					}
				}

				function validateXMLWebView(txt) {
					var result = validateXML(txt);
					document.location = JSON.stringify({event:"result", method:"result","result":result});
				}
				]]></root>
	
	}
}