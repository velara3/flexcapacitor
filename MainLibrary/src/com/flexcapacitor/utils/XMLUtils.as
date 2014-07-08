

package com.flexcapacitor.utils
{
	import flash.external.ExternalInterface;

	public class XMLUtils
	{
		
		// I don't know if this is the correct method to identify byte order markers 60% confident
		// Sources:
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
		
		[Bindable]
		public static var addedXMLValidationToPage:Boolean;
		
		public function XMLUtils() {
			
		}
		
		
		/**
		 * Constant representing a element type returned from XML.nodeKind.
		 *
		 * @see XML.nodeKind()
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static const ELEMENT:String = "element";
		
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
		 * */
		public static function getAttributeSafeString(value:String = ""):String {
			var outputValue:String = value;
			outputValue = outputValue.replace(/&(?!amp;)/g, "&amp;");
			outputValue = outputValue.replace(/"/g, "&quot;");
			outputValue = outputValue.replace(/</g, "&lt;");
			outputValue = outputValue.replace(/>/g, "&gt;");
			return outputValue;
		}
		
		/**
		 * Decodes HTML entities that are not allowed in attribute quotes. 
		 * Replaces double quote, ampersand, less than sign and greater than sign. 
		 * 
		 * For example, replaces "&quot;" with double quote.
		 * */
		public static function decodeAttributeString(value:String = ""):String {
			var outputValue:String = value.replace(/&quot;/g, '"');
			outputValue = outputValue.replace(/&amp;/g, "&");
			outputValue = outputValue.replace(/&lt;/g, "<");
			outputValue = outputValue.replace(/&gt;/g, ">");
			return outputValue;
		}
		
		public static var validationError:Error;
		public static var validationErrorMessage:String;
		
		/**
		 * Checks whether the specified string is valid and well formed XML. Uses the Flash Player
		 * XML parser. Use the Validate method to return more information than true and false. 
		 *
		 * @param data The string that is being checked to see if it is valid XML.
		 *
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 *
		 * @see validate
		 */
		public static function isValidXML(value:String):Boolean {
			var xml:XML;
			
			try {
				xml = new XML(value);
			}
			catch (error:Error) { // TypeError
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
		public static function validate(value:*):XMLValidationInfo {
			(!addedXMLValidationToPage) ? insertValidationScript() : null;
			var xml:String = value != null ? value : "";
			var hasMarker:Boolean = hasByteOrderMarker(value);
			var validationResult:String = ExternalInterface.call("validateXML", xml);
			var validationInfo:XMLValidationInfo = new XMLValidationInfo();
			var byteMarkerType:String;
			var isValidMarker:Boolean;
			var characterCount:int;
			var isMozilla:Boolean;
			var isChrome:Boolean;
			var lastLine:String;
			var isValid:Boolean;
			var matchIndex:int;
			var results:Array;
			var lines:Array;
			var column:int;
			var row:int;
			
			if (hasMarker) {
				byteMarkerType = XMLUtils.getByteOrderMarkerType(xml);
				validationInfo.hasMarker = true;
				validationInfo.byteMarkerType = byteMarkerType;
			}
			else {
				byteMarkerType = "";
			}
			
			if (validationResult) {
				isMozilla = (validationResult.indexOf("XML Parsing Error:") != -1);
				isChrome = (validationResult.indexOf("This page contains the following errors:") != -1);
			}
			
			// error - xml is not valid
			if (isChrome || isMozilla) {
				
				// get row and column
				if (isMozilla) {
					results = validationResult.match(/Line\s+Number\s+(\d+),\s+Column\s+(\d+):/i);
					row = results.length > 1 ? results[1] : 0;
					column = results.length > 2 ? results[2] : 0;
					validationInfo.row = row;
					validationInfo.column = column;
				}
				else if (isChrome) {
					results = validationResult.match(/line\s+(\d+)\s+at\s+column\s+(\d+):/i);
					row = results.length > 1 ? results[1] : 0;
					column = results.length > 2 ? results[2] : 0;
					validationInfo.row = row;
					validationInfo.column = column;
				}
				
				
				validationInfo.valid = false;
				
				validationResult = String(validationResult).replace(/Location:.*/g, "");
				
				validationInfo.browserErrorMessage = String(validationResult);
				
				lines = xml.split("\n");
				lastLine = xml;
				characterCount = column;
				
				if (row < lines.length) {
					for (var i:int; i < row; i++) {
						characterCount += lines[i].length - 1;
						lastLine = lines[i];
					}
					
					validationInfo.value = xml;
					matchIndex = xml.search(lastLine);
					//xmlTextArea.selectRange(matchIndex + column - row, xmlTextArea.text.length);
					validationInfo.beginIndex = matchIndex + column - row;
					validationInfo.endIndex = xml.length;
					
				}
				
				try {
					if (xml != null) {
						xml = new XML(xml as String);
					}
				}
				catch (error:TypeError) {
					validationInfo.errorMessage = error.message;
				}
				finally {
					
				}
				
			}
			else if (validationResult && validationResult.indexOf("No errors found") != -1) {
				validationInfo.valid = true;
			}
			else {
				validationInfo.valid = false;
			}
			
			return validationInfo;
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
		 * Injects the browser with the javascript used to check the value
		 * Must be called before javascript validation will work
		 * */
		public static function insertValidationScript():void {
			ExternalInterface.addCallback("universalCallback", universalCallback);
			insertScript(); // may need to call later callLater()
		}
		
		private static function insertScript():void {
			ExternalInterface.call("eval", browserXMLValidationScript);
			addedXMLValidationToPage = true;
		}
		
		private static function universalCallback(... rest):void {
			//lastResult = String(rest[0]);
			trace("WHEN??? universalCallback = " + rest[0]);
		}
		
		/**
		 * Javascript Validation Code - source W3C Validator
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
				]]></root>
	}
}


////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: XML Validation Info
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class XMLValidationInfo
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	public function XMLValidationInfo () {
		super();
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasMarker
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var hasMarker:Boolean;
	
	//----------------------------------
	//  byteMarkerType
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var byteMarkerType:String;
	
	//----------------------------------
	//  row
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var row:int;
	
	//----------------------------------
	//  column
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var column:int;
	
	//----------------------------------
	//  valid
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var valid:Boolean;
	
	//----------------------------------
	//  browser error message
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var browserErrorMessage:String;
	
	//----------------------------------
	//  Flash Player parsing error message
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var errorMessage:String;
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var value:String;
	
	//----------------------------------
	//  error begin index
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var beginIndex:int;
	
	//----------------------------------
	//  error end index
	//----------------------------------
	
	/**
	 *  @private
	 */
	public var endIndex:int;
}