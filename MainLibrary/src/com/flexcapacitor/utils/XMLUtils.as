

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
	
	import mx.utils.Platform;
	import mx.utils.StringUtil;
	
	
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
		
		public static const NewLine:String 		= "&#10;";
		
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
		
		public static var defaultHTMLClassName:String = "flash.html.HTMLLoader";
		
		public static var HTMLLoaderClass:Object;
		
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
		 * Creates a node with the given name. 
		 * 
		 * @see #flash.xml.XMLDocument.createElement()
		 * */
		public static function createElement(xml:XML, name:*):XML {
			var newNode:XML;
			
			if (xml==null) {
				if (name is QName) {
					xml = new XML();
					xml.setName(QName(name).localName);
					xml.setNamespace(QName(name).uri);
					return xml;
				}
				
				return new XML("<" + name + "/>");
			}
			
			newNode = new XML();
			newNode.setName(name);
			
			// doing it this way to add namespaces?
			newNode = xml.appendChild(newNode);
			delete xml[newNode.childIndex()];
			return newNode;
		}
		
		/**
		 * Creates a text node with the given value. 
		 * 
		 * @see flash.xml.XMLDocument#createTextNode()
		 * */
		public static function createTextNode(xml:XML, value:String):XML {
			var textNode:XML;
			
			if (xml==null) {
				xml = new XML();
				return xml.appendChild(value);
			}
			
			textNode = xml.appendChild(value);
			delete xml[textNode.childIndex()];
			return textNode;
		}
		
		/**
		 * Removes the node if it has a parent.
		 * */
		public static function removeNode(xml:XML):XML {
			var parent:XML = xml ? xml.parent() : null;
			if (parent) {
				delete parent[xml.name()][xml.childIndex()];
			}
			return xml;
		}
		
		/**
		 * Removes node from the list.
		 * */
		public static function removeNodeFromXMLList(xmlList:XMLList, node:Object):Object {
			//var parent:XML = xmlList.parent();
			var deleted:Boolean; // always reports true :/
			var index:int;
			var numberOfItems:int = xmlList.length();
			var numberOfItemsAfter:int;
			var removed:Object;
			
			index = getItemIndex(xmlList, node);
			numberOfItemsAfter = numberOfItems;
			
			if (index!=-1) {
				removed = xmlList[index];
				deleted = delete xmlList[index];
				numberOfItemsAfter = xmlList.length();
			}
			
			if (numberOfItems!=numberOfItemsAfter) {
				return removed;
			}
			
			/*
			if (parent!=null) {
				index = node.childIndex();
				deleted = delete xmlList[index];
			}
			else {
				parent = <node/>;
				parent.appendChild(xmlList);
				index = node.childIndex();
				deleted = delete xmlList[index];
				
				/// we added a parent to delete an items in xmllist 
				// but now how to do we delete the parent?
				
				//delete xmlList.parent();
				// return parent.children().copy(); ?
				//numberOfItems = xmlList.length();
				
				// answers in XMLListAdapter.removeItem();
			}
			*/
			
			return removed;
		}
		
		/**
		 * Get index of xml node
		 * */
		public static function getItemIndex(source:XMLList, item:Object):int
		{
			if (item is XML && source.contains(XML(item)))
			{
				var numberOfItems:int = source.length();
				for (var i:int = 0; i < numberOfItems; i++)
				{
					var search:Object = source[i];
					if (search === item)
					{
						return i;
					}
				}
			}
			
			return -1;           
		}
		
		
		/**
		 * Gets the XML that is not a property, style or event of the object
		 * 
		 * @param node XML item
		 * */
		public static function getDefaultPropertyValueObject(object:Object, 
															 node:XML, 
															 defaultProperty:Object, 
															 includeQualifiedNames:Boolean = true, 
															 ignoreWhitespace:Boolean = false, 
															 excludedProperties:Array = null):Object {
			var defaultPropertyName:String;
			var defaultPropertyURI:String;
			var memberNames:Array;
			var attributes:XMLList;
			var attributeNames:Array;
			var childNodes:XMLList;
			var childNodeNames:Array;
			//var childNodes:XMLList;
			var declaredAsAttribute:Boolean;
			var declaredAsChild:Boolean;
			var message:String;
			var nodeName:String;
			var error:Error;
			var childNodeName:String;
			var defaultPropertyChildren:XMLList;
			var deleted:Boolean;
			var result:Object;
			var localName:String;
			var fullNodeName:String;
			var nodeKind:String;
			var childNodeIndex:int;
			var subtractionMethod:Boolean;
			
			
			result = {};
			
			if (defaultProperty==null) {
				return result;
			}
			else if (defaultProperty is QName) {
				defaultPropertyName = QName(defaultProperty).localName;
				defaultPropertyURI = QName(defaultProperty).uri;
			}
			else if (defaultProperty is String) {
				defaultPropertyName = String(defaultProperty);
			}
			
			//defaultProperty 	= object ? object : null;
			
			if (excludedProperties && excludedProperties.indexOf(defaultPropertyName)!=-1) {
				return result;
			}
			
			subtractionMethod = true;
			
			
			var settings:Object;
			
			settings = XML.settings();
			XML.ignoreWhitespace = ignoreWhitespace;
			//XML.prettyPrinting = ignoreWhitespace;
			//XML.ignoreProcessingInstructions = ignoreWhitespace;
			
			node = new XML(node);
			
			memberNames 		= ClassUtils.getMemberNames(object);
			attributes 			= node.attributes();
			attributeNames 		= XMLUtils.convertXMLListToArray(attributes);
			
			// check if default property is defined as an attribute
			if (attributeNames.indexOf(defaultProperty)!=-1) {
				declaredAsAttribute = true;
			}
			
			childNodes			= node.children();
			childNodeNames 		= XMLUtils.getChildNodeNames(node);
			
			// check if default property is defined as a child node
			if (childNodeNames.indexOf(defaultProperty)!=-1) {
				declaredAsChild = true;
			}
			
			XML.setSettings(settings);
			
			if (declaredAsChild && declaredAsAttribute) {
				nodeName = node.name().localName;
				message = "Multiple initializers for property '{0}'. (note: '{0}' is the default property of '{1}')";
				message = StringUtil.substitute(message, defaultProperty, nodeName);
				error = new Error(message);
				return error;
			}
			
			// remove properties not part of the element 
			if (subtractionMethod) {
				// loop through child nodes and delete nodes that are properties of the element
				//var tempParent:XML = <test/>;
				//var namespaces:Array = node.inScopeNamespaces();
				var copy:XML = node.copy();
				
				//tempParent.appendChild(copy);
				var numberOfItems:int;
				
				for each (var childNode:XML in copy.*) {
					/*
					for each (var ns:Namespace in namespaces) {
						childNode.setNamespace(ns);
						break;
					}*/
					
					localName = childNode.localName();
					fullNodeName = childNode.name();
					nodeKind = childNode.nodeKind();
					childNodeIndex = childNode.childIndex();
					
					// node is null or comment
					if (fullNodeName==null) {
						continue;
					}
					
					if (memberNames.indexOf(localName)!=-1) {
						numberOfItems = copy.*.length();
						deleted = delete copy.*[childNodeIndex];
						
						if (numberOfItems==copy.*.length()) {
							deleted = delete copy.*[childNodeIndex];
							if (numberOfItems==copy.*.length()) {
								// couldn't delete the node for some reason
							}
						}
					}
				}
				
				numberOfItems = copy.*.length();
				
				if (numberOfItems) {
					result[defaultPropertyName] = copy.*;
				}
				
			}
			// add each XML node that is not a property of the element
			else {
			
				// alternatively loop through child nodes and create a new XMLList
				var copy2:XMLList = childNodes.copy();
				if (defaultPropertyChildren==null) {
					defaultPropertyChildren = new XMLList();
				}
				
				for each (var childNode1:XML in copy2) {
					childNodeName = childNode1.name().localName;
					
					if (memberNames.indexOf(childNodeName)!=-1) {
						defaultPropertyChildren += childNode1;
					}
				}
				
				if (defaultPropertyChildren.length()) {
					result[defaultPropertyName] = defaultPropertyChildren;
				}
				
			}
			
			return result;
			
			// get default property
			// if no default property return null
			
			// get a list of all element members
			// get a list of all attributes on node
			// check if default property is defined as attribute
			
			// get a list of all child nodes
			// check if it's also defined as child node
			
			// if defined as both throw error
			
			// filter all child nodes out that are part of the element
			// 
			
			/*
			var result:Array = [];
			var localName:String;
			var qualifiedName:String;
			var ignoreWhitespaceValue:Boolean;
			var settings:Object;
			
			settings = XML.settings();
			XML.ignoreWhitespace = ignoreWhitespace;
			XML.prettyPrinting = ignoreWhitespace;
			XML.ignoreProcessingInstructions = ignoreWhitespace;
			
			
			XML.setSettings(settings);
			
			return result;
			*/
		}
		/**
		 * Add a namespace to a XML node
		 * */
		public static function addNamespace(xml:XML, namespaceName:String, namespaceURI:String, setAttributes:Boolean = false):XML {
			var newNamespace:Namespace;
			
			newNamespace = new Namespace(namespaceName, namespaceURI);
			xml.setNamespace(newNamespace);
			
			for each (var node:XML in xml.descendants()) {
				node.setNamespace(newNamespace);
				
				if (setAttributes) {
					for each (var attribute:XML in node.attributes()) {
						attribute.setNamespace(newNamespace);
					}
				}
			}
			
			return xml;
		}
		
		/**
		 * Remove a namespace
		 * */
		public static function removeNamespace(xml:XML, namespaceReference:Namespace, includeAttributes:Boolean = false):XML {
			xml.removeNamespace(namespaceReference);
			
			// pretty sure this isn't necessary
			for each (var node:XML in xml.descendants()) {
				node.removeNamespace(namespaceReference);
				
				if (includeAttributes) {
					for each (var attribute:XML in node.attributes()) {
						attribute.removeNamespace(namespaceReference);
					}
				}
			}
			
			return xml;
		}
		
		/**
		 * Add namespace to XML
		 * */
		public function addNamespaceToXML(value:XML, newNamespace:Namespace, oldNamespace:Namespace = null, includeAttributes:Boolean = true):XML {
			var newNamespace:Namespace;
			var xml:XML;
			var node:XML;
			var attribute:XML
			
			xml = value as XML;
			
			if (oldNamespace) {
				xml.removeNamespace(oldNamespace);
			}
			
			xml.setNamespace(newNamespace);
			
			for each (node in xml.descendants()) {
				node.setNamespace(newNamespace);
				
				if (includeAttributes) {
					for each (attribute in node.attributes()) {
						attribute.setNamespace(newNamespace);
					}
				}
			}
			
			return xml;
		}
		
		/**
		 * Encodes values that are not allowed in attribute quotes. 
		 * Replaces single quote, double quote, ampersand, less than and greater than sign and new line. 
		 * For example, replaces double quote with "&quot;"
		 * Use decodeAttributeString() when reading values. 
		 * 
		 * @see #decodeAttributeString()
		 * */
		public static function getAttributeSafeString(value:String = ""):String {
			var outputValue:String = value;
			outputValue = outputValue.replace(/&(?!amp;)/g, "&amp;");
			outputValue = outputValue.replace(/"/g, "&quot;");
			outputValue = outputValue.replace(/'/g, "&apos;");
			outputValue = outputValue.replace(/</g, "&lt;");
			outputValue = outputValue.replace(/>/g, "&gt;");
			outputValue = outputValue.replace(/\n/g, "&#10;");
			return outputValue;
		}
		
		/**
		 * Decodes HTML entities that are not allowed in attribute quotes. 
		 * Replaces single quote, double quote, ampersand, less than sign and greater than sign. 
		 * 
		 * For example, replaces "&quot;" with double quote.
		 * Use getAttributeSafeString() when writing values. 
		 * 
		 * @see #getAttributeSafeString()
		 * */
		public static function decodeAttributeString(value:String = ""):String {
			var outputValue:String = value.replace(/&quot;/g, '"');
			outputValue = outputValue.replace(/&apos;/g, "'");
			outputValue = outputValue.replace(/&amp;/g, "&");
			outputValue = outputValue.replace(/&lt;/g, "<");
			outputValue = outputValue.replace(/&gt;/g, ">");
			outputValue = outputValue.replace(/&#10;/g, "\n");
			return outputValue;
		}
		
		/**
		 * Sets an attribute to the given value
		 * */
		public static function setAttribute(xml:XML, attributeName:*, value:String = ""):XML {
			xml.@[attributeName] = value;
			return xml;
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
					// Error: The validateXML() call was invalid. 
					// You must call initialize() a few frames before calling validateXML().
					// Example: XMLUtils.initialize();
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
		public static function initialize(htmlClassName:String = null):void {
			var isAir:Boolean = Platform.isAir;
			var isDesktop:Boolean = Platform.isDesktop;
			
			if (Platform.isAir) {
				initializeInDesktop(htmlClassName);
			}
			else if (ExternalInterface.available) {
				initializeInBrowser();
			}
		}
		
		/**
		 * Used to make validateXML work on the desktop or AIR
		 * */
		public static function initializeInDesktop(htmlClassName:String = null):void {
			var playerType:String = Capabilities.playerType;
			var htmlText:String;
			
			if (htmlClassName) {
				if (ApplicationDomain.currentDomain.hasDefinition(htmlClassName)) {
					HTMLLoaderClass = getDefinitionByName(htmlClassName);
				}
				else {
					throw new Error("Could not find class for XML validation. Check the spelling and ensure to add a reference to include the class.");
				}
			}
			else if (HTMLLoaderClass==null && Platform.isAir || Platform.isDesktop) {
				htmlClassName = defaultHTMLClassName;
				
				if (ApplicationDomain.currentDomain.hasDefinition(htmlClassName)) {
					HTMLLoaderClass = getDefinitionByName(htmlClassName);
				}
				else {
					throw new Error("Could not find " + htmlClassName + " class for XML validation. Be sure to add a reference so the class is included");
				}
			}
			
			htmlText = "<html><script>"+XMLUtils.browserXMLValidationScript+"</script><body></body></html>";
			htmlLoader = new HTMLLoaderClass();
			htmlLoader.loadString(htmlText);
			htmlLoader.addEventListener(Event.COMPLETE, function(e:Event):void {htmlLoaderLoaded = true;});
		}
		
		/**
		 * Used to make validateXML work in the browser
		 * */
		public static function initializeInBrowser():void {
			insertValidationScript();
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
			var isChrome:Boolean; // by chrome we may mean webkit
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
					if (lines.length>2) {
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
					if (lines.length>2) {
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
					// we could also use childNode.name().localName (QName)
					name = childNode.localName();
				}
				
				result.push(name);
			}
			
			return result;
		}
		
		/**
		 * Get list of childnode names from a node
		 * and allows you to skip nodes with namespace is set.
		 * 
		 * <pre>
		 * &lt;s:HGroup xmlns:s="library://ns.adobe.com/flex/spark">
		 * </pre>
		 * Returns "HGroup" when local is true or
		 * "library://ns.adobe.com/flex/spark::HGroup" when local is false. 
		 * 
		 * @param node XML item
		 * @param includeNamespace indicates to node names that have namespace set
		 * */
		public static function getChildNodeNamesNamespace(node:XML, includeNamespace:Boolean = true):Array {
			var result:Array = [];
			var name:String;
			var nodeKind:String;
			var namespaceValue:Namespace;
			
			for each (var childNode:XML in node.children()) {
				namespaceValue = childNode.namespace();
				
				if (!includeNamespace) {
					if (namespaceValue) {
						continue;
					}
				}
				
				if (namespaceValue) {
					name = namespaceValue.toString();
				}
				
				// nodeKind = childNode.nodeKind(); // text node 
				
				//if (nodeKind) {
					
				//}
				
				name = childNode.name();
				
				if (name!=null) {
					result.push(name);
				}
			}
			
			return result;
		}
		
		/**
		 * Get list of childnode names from a node
		 * that include only nodes with a specific namespace set.
		 * 
		 * <pre>
		 * &lt;s:HGroup xmlns:s="library://ns.adobe.com/flex/spark">
		 * </pre>
		 * Returns "library://ns.adobe.com/flex/spark::HGroup" when the namespace is not default. 
		 * 
		 * @param node XML item
		 * @param includeNamespace indicates to node names that have namespace set
		 * */
		public static function getQualifiedChildNodeNames(node:XML):Array {
			var result:Array = [];
			var name:String;
			
			for each (var childNode:XML in node.children()) {
				
				if (childNode.namespace()) {
					name = childNode.name();
					
					if (name!=null) {
						result.push(name);
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Returns true if a node has attribute. Not handling namespaces.
		 * 
		 * @param node XML item
		 * @return true if attribute exists
		 * @see #hasAttributeDefined()
		 * */
		public static function hasAttribute(node:XML, attribute:String):Boolean {
			var attributes:Array = node ? getAttributeNames(node) : [];
			var exists:Boolean = (attributes.indexOf(attribute)!=-1);
			
			return exists;
		}
		
		/**
		 * Returns true if a node has attribute defined. Might be faster than hasAttribute()
		 * 
		 * @param node XML item
		 * @return true if attribute exists
		 * @see #hasAttribute()
		 * */
		public static function hasAttributeDefined(node:XML, attributeName:String):Boolean {
			var exists:Boolean = node.@[attributeName]!==undefined;
			
			return exists;
		}
		
		/**
		 * Remove attribute from a node
		 * 
		 * @param node XML item
		 * */
		public static function removeAttribute(node:XML, attributeName:Object):XML {
			var result:Array = [];
			
			delete node.@[attributeName];
			return node;
		}
		
		/**
		 * Get list of attribute names defined on a node
		 * 
		 * @param node XML item
		 * */
		public static function getAttributeNames(node:XML, includeNamespaceAttributes:Boolean = true):Array {
			var result:Array = [];
			var attributeName:String;
			
			for each (var attribute:XML in node.attributes()) {
				attributeName = attribute.name().toString();
				
				if (!includeNamespaceAttributes) {
					// skip namespace attributes
					if (attribute.namespace()) {
						continue;
					}
				}
				
				result.push(attributeName);
			}
			
			return result;
		}
		
		/**
		 * Get list of qualified attribute names from a node. Attributes with a namespace.
		 * 
		 * @param node XML item
		 * */
		public static function getQualifiedAttributeNames(node:XML):Array {
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
				
				// add only namespace attributes
				if (attribute.namespace()) {
					result.push(attributeName);
				}
				
			}
			
			return result;
		}
		
		/**
		 * Get name value pair from attributes from a node. Decodes attribute values
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
		public static function getChildNodesValueObject(node:XML, includeQualifiedNames:Boolean = true, toSimpleString:Boolean = true, ignoreWhitespace:Boolean = false):Object {
			var result:Object = {};
			var localName:String;
			var qualifiedName:String;
			var ignoreWhitespaceValue:Boolean;
			var settings:Object;
			var qname:QName;
			
			settings = XML.settings();
			XML.ignoreWhitespace = ignoreWhitespace;
			XML.prettyPrinting = ignoreWhitespace;
			XML.ignoreProcessingInstructions = ignoreWhitespace;
			
			for each (var childNode:XML in node.children()) {
				
				if (includeQualifiedNames) {
					qualifiedName = childNode.localName();
				}
				
				qname = childNode.name();
				
				localName = childNode.name();
				if (localName==null) {
					continue;
				}
				
				// http://www.morearty.com/blog/2007/03/13/common-e4x-pitfalls/
				/*
				E4X intentionally blurs the distinction between XML and XMLList. Any XMLList that 
				contains exactly one element can be treated as if it were an XML.
				
				For example, another place where this blurring is evident is in the behavior of XMLList.toString(). 
				As the Flex docs say:
				
				If the XML object has simple content, toString() returns the string contents of the XML object with the 
				following stripped out: the start tag, attributes, namespace declarations, and end tag.
				If the XML object has complex content, toString() returns an XML encoded string representing the entire 
				XML object, including the start tag, attributes, namespace declarations, and end tag.
				
				So if an XMLList contains <node>hello</node>, then toString() will return "hello"; 
				but if the list contains <node>hello</node><node>goodbye</node>, then toString() will return 
				"<node>hello</node><node>goodbye</node>" (not "hellogoodbye"). 
				
				Presumably this decision was made in an effort to achieve “do what I mean” behavior, 
				where the output would match what developers most often intended; 
				but personally I find it a little confusing. If you really need the full XML version of an 
				XMLList that contains simple content, use toXMLString() instead of toString().
				*/
				if (toSimpleString) {
					if (includeQualifiedNames) {
						result[qualifiedName] = result[localName] = childNode.children().toString();
					}
					else {
						result[localName] = childNode.children().toString();
					}
				}
				else {
					if (includeQualifiedNames) {
						result[qualifiedName] = result[localName] = childNode.children().toXMLString();
					}
					else {
						result[localName] = childNode.children().toXMLString();
					}
				}
			}
			
			XML.setSettings(settings);
			
			return result;
		}
		
		/**
		 * Get XML node with namespaces added. <br/><br/>
		 * 
		 * If the XML is not valid and errors occurred a XMLValidationInfo object is returned with 
		 * more info.<br/><br/>
		 * 
		 * Usage:  
<pre>
var code:String = '<?xml version="1.0" encoding="utf-8"?><node ></node>';
var namespaces:Dictionary = MXMLDocumentConstants.getNamespaces(); // dictionary[prefix] = namespaceURI
var xml:XML = XMLUtils.getXMLFromStringWithNamespaces(code, namespaces);
</pre>
		 * 
		 * Usage:  
<pre>
var code:String = '<?xml version="1.0" encoding="utf-8"?><node xmlns="noprefix.com"></node>';
var namespaces:String = 'xmlns:s="library://ns.adobe.com/flex/spark" xmlns:b="testnamespace.com"';
var xml:XML = XMLUtils.getXMLFromStringWithNamespaces(code, namespaces);
</pre>
		 * @param string that is formatted as XML
		 * @param namespaces a string of namespaces such as xmlns:s="library" or an object or dictionary 
		 * containing a name value pair of prefix and namespace URI. 
		 * */
		public static function getXMLFromStringWithNamespaces(code:String, namespaces:Object):Object {
			var settings:Object;
			var isValid:Boolean;
			var validationInfo:XMLValidationInfo;
			var error:Error;
			var xml:XML;
			var root:String;
			var updatedCode:String;
			var rootNodeName:String = "ROOTNODENAMENOONEWILLEVERUSE";
			var secondMethod:Boolean;
			
			if (code=="" || code==null) {
				return null;
			}
			
			// this method takes 3-4x as long as the second
			if (!(namespaces is String)) {
				updatedCode = addNamespacesToXMLString(code, namespaces);
				isValid = XMLUtils.isValidXML(updatedCode);
			}
			else {
				root = '<'+rootNodeName + " " + namespaces +'>\n';
				updatedCode = root + code + "\n</"+rootNodeName+">";
				isValid = XMLUtils.isValidXML(updatedCode);
				secondMethod = true;
			}
			
			settings = XML.settings();
			
			// don't modify the XML in any way
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			XML.ignoreProcessingInstructions = false;
			
			isValid = XMLUtils.isValidXML(updatedCode);
			//error = XMLUtils.validationError;
			
			if (!isValid) {
				validationInfo = XMLUtils.validateXML(code);
				error = validationInfo.error;
				
				if (error is TypeError && error.errorID==1083) {
					
					if (isValid) {
						xml = new XML(updatedCode);
					}
				}
			}
			else {
				xml = new XML(updatedCode);
			}
			
			XML.setSettings(settings);
			
			if (isValid) {
				if (secondMethod) {
					return xml.children()[0];
				}
				return xml;
			}
			
			return validationInfo;
		}
		
		/**
		 * Get XML string with namespaces added to the first node
		 * 
		 * If the namespaces could not be added null is returned.<br/><br/>
		 * 
		 * Usage:  
<pre>
var code:String = '<?xml version="1.0" encoding="utf-8"?><node something xmlns:s = "library://ns.adobe.com/flex/spark" xmlns:b=\'testnamespace.com\' xmlns="noprefix.com"></node>';
var namespaces:Dictionary = MXMLDocumentConstants.getNamespaces(); // dictionary[prefix] = namespaceURI
var newCode:String = XMLUtils.addNamespacesToXMLString(code, namespaces);
</pre>
		 * 
		 * @param string that is formatted as XML
		 * @param namespaces a string of namespaces such as xmlns:s="library" or an object or dictionary 
		 * containing a name value pair of prefix and namespace URI. 
		 * */
		public static function addNamespacesToXMLString(code:String, namespaces:Object):String {
			var simpleMethod:Boolean = true;
			var match:Array;
			var firstNode:String;
			var firstTag:String;
			var tagName:String;
			var firstTagContents:String;
			var isValid:Boolean;
			var attributes:Array;
			var original:String;
			var attribute:String;
			var attributeMatch:Array;
			var namespaceURI:String;
			var namespacePrefix:String;
			var existingNamespaces:Array;
			var newCode:String;
			var namespacesToAdd:Array;
			var newNode:String;
			var xml:XML;
			
			
			if (simpleMethod) {
				match = code.match(/((<([\w|:]+) )(.*?)>)/);
				
				if (match) {
					original = match[0];
					firstNode = match[1];
					firstTag = match[2];
					tagName = match[3];
					firstTagContents = match[4];
					attributes = firstTagContents.split(/\s+(?!=|"|')/g);
					//firstTagContents = firstTagContents.replace(/\s+=\s+|=\s+|\s+=/g,"");
					//attributes = firstTagContents.split(/\s+(?!=|"|')/g);
					existingNamespaces = [];
					
					for (var j:int = 0; j < attributes.length; j++) 
					{
						attribute = attributes[j];
						
						if (attribute.toLowerCase().indexOf("xmlns")==0 && attribute.indexOf("=")!=-1) {
							attributeMatch = attribute.match(/(x.*?)\s*?=\s*?["|'](.*?)["|']/);
							
							if (attributeMatch) {
								namespacePrefix = attributeMatch[1];
								namespacePrefix = namespacePrefix.indexOf(":")!=-1 ? namespacePrefix.split(":").pop() : "";
								namespaceURI 	= attributeMatch[2];
								
								existingNamespaces.push(namespaceURI);
							}
						}
					}
					
					namespacesToAdd = getNamespacesArray(namespaces, true, existingNamespaces);
					newNode 		= "<" + tagName + " " + namespacesToAdd.join(" ") + " " + firstTagContents + ">";
					newCode 		= code.replace(original, newNode);
				}
			}
			
			return newCode;
		}
		
		/**
		 * Gets an array of namespaces or namespace attributes excluding any passed in
		 * namespaceURI's. 
		 * */
		public static function getNamespacesArray(namespaces:Object, prefixed:Boolean = true, excludedNamespaceURIs:Array = null):Array {
			var namespaceURI:String;
			var uri:String;
			var uriLowerCase:String;
			var namespacesArray:Array = [];
			var isFound:Boolean;
			var xmlns:String = "xmlns";
			
			for (var prefix:String in namespaces) {
				uri = namespaces[prefix];
				uriLowerCase = uri.toLowerCase();
				isFound = false;
				
				for (var i:int = 0; excludedNamespaceURIs && i < excludedNamespaceURIs.length; i++)  {
					namespaceURI = excludedNamespaceURIs[i].toLowerCase();
					
					if (uriLowerCase==namespaceURI) {
						isFound = true;
						break;
					}
				}
				
				if (!isFound) {
					if (prefixed) {
						if (prefix==null || prefix=="") {
							namespacesArray.push(xmlns + "=\"" + uri + "\"");
						}
						else {
							namespacesArray.push(xmlns + ":" + prefix + "=\"" + uri + "\"");
						}
					}
					else {
						namespacesArray.push(uri);
					}
				}
			}
			
			return namespacesArray;
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