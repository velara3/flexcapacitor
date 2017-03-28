

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
	 * A set of utilities for working with SVG
	 * */
	public class SVGUtils extends EventDispatcher {
		
		public function SVGUtils() {
			
		}
		
		public static const ELEMENT:String = "element";
		public static var CONVERT_FUNCTION_NAME:String = "convertSVG";
		
		public static const NewLine:String 		= "&#10;";
		
		public static var addedSVGFunctionToPage:Boolean;
		public static var autoInitialize:Boolean = true;
		
		public static var notInitializedMessage:String = "The call was invalid. You must call initialize() a few frames before calling convert().";
		
		public static var validationError:Error;
		
		public static var validationErrorMessage:String;
		
		public static var defaultHTMLClassName:String = "flash.html.HTMLLoader";
		
		public static var HTMLLoaderClass:Object;
		
		public static var htmlLoader:Object;
		
		public static var htmlLoaderLoaded:Boolean;
		
		[Embed(source="supportClasses/svg2fxg.xsl", mimeType="application/octet-stream")]
		public static var svgXSLClass:Class;
		public static var svgXSL:String;
		
		/**
		 * Converts SVG to FXG. 
		 * When running as a desktop application call initialize() a few frames before calling this method. 
		 * 
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
		 * @param value The string that contains valid SVG.
		 * @return An XML object containing FXG 
		 */
		public static function convert(value:String):String {
			var validationInfo:XMLValidationInfo;
			var result:String;
			var marshall:Boolean;
			
			if (value==null) value = "";
			
			if (svgXSL==null) {
				svgXSL = new svgXSLClass();
			}
			
			if (ExternalInterface.available) {
				marshall = ExternalInterface.marshallExceptions;
				//ExternalInterface.marshallExceptions = true;
				result = ExternalInterface.call(browserConversionFunction, value, svgXSL);
				ExternalInterface.marshallExceptions = marshall;
			}
			else if (Capabilities.playerType == "Desktop") {
				var isValid:Boolean;
				var htmlText:String;
				var hasStageWebView:Boolean;
				
				if (htmlLoader==null) {
					// You must call initialize() a few frames before calling validateXML().
					// Example: SVGUtils.initialize();
					throw new Error(notInitializedMessage);
				}
				
				if (htmlLoader && htmlLoader.window) {
					if (htmlLoader.window.convert==null) {
						htmlLoader.window.convert = getFXG; 
					}
					
					result = htmlLoader.window.convert(value);
				}
				else {
					var stageWebView:String = "flash.media.StageWebView";
					var callbackFunction:Function;
					var StageWebViewDefinition:Object;
					var stageWebViewInstance:Object;
					var out:String = "";
					var output:String;
					
					// if using stage web view then we are limited to an async call
					if (ApplicationDomain.currentDomain.hasDefinition(stageWebView)) {
						
						StageWebViewDefinition = getDefinitionByName(stageWebView);
						stageWebViewInstance = new StageWebViewDefinition();
						
						stageWebViewInstance.addEventListener("locationChanging", function (event:Object):void {
							var locationValue:String = event.location;
							
							try {
								// check if it's an event dispatched from JS
								var object:Object = JSON.parse(locationValue);
								var eventName:String = object.event;
								var methodName:String = object.method;
								//validate(value, callbackFunction, object);
							}
							catch (error:Error) {
								//validate(value, callbackFunction, object);
							}
						});
						
						stageWebViewInstance.addEventListener(ErrorEvent.ERROR, function (error:ErrorEvent):void {
							trace("Error:" + error.toString());
						});
						
						stageWebViewInstance.loadURL("javascript:"+browserConversionFunction);
						output = "javascript:validateXMLWebView(\""+JSON.stringify(value)+"\")";
						stageWebViewInstance.loadURL(output);
						
						if (callbackFunction!=null) {
							callbackFunction(validationInfo);
						}
						
					}
				}
				
			}
			
			return result;
		}
		
		/**
		 * Reference to HTML Loader document on desktop applications
		 * */
		public static var document:Object;
		public static var window:Object;
		
		/**
		 * Get FXG from SVG on desktop AIR apps
		 * */
		public static function getFXG(value:String):String {
			var domParser:Object;
			var xmlObject:Object;
			var xslObject:Object;
			var xsltProcessor:Object;
			var result:String;
			var serializer:Object;
			var errorMessage:String;
			var fragment:Object;
			
			if (htmlLoader==null) {
				// You must call initialize() a few frames before calling getFXG().
				// Example: SVGUtils.initialize();
				throw new Error(notInitializedMessage);
			}
			
			if (window==null) {
				window = htmlLoader.window;
			}
			
			if (document==null) {
				document = window.document;
			}
			
			if (document.implementation.createDocument) {
				domParser 		= new window.DOMParser();
				xsltProcessor 	= new window.XSLTProcessor();
				serializer 		= new window.XMLSerializer();
				
				xmlObject = domParser.parseFromString(value,'text/xml');
				xslObject = domParser.parseFromString(svgXSL,'text/xml');
				xsltProcessor.importStylesheet(xslObject);
				fragment = xsltProcessor.transformToFragment(xmlObject, document);
				result = serializer.serializeToString(fragment);
				
				if (xmlObject.getElementsByTagName("parsererror").length > 0) {
					errorMessage = xmlObject.toString();
					//checkErrorXML(xmlDoc.getElementsByTagName("parsererror")[0]);
					return errorMessage;
				}
				
			}
			
			return result;
		}
		
		/**
		 * Call this method at least a few frames before calling validateXML()
		 * @see #validateXML()
		 * @see htmlLoaderLoaded
		 * */
		public static function initialize(htmlClassName:String = null):void {
			var isAir:Boolean = Platform.isAir;
			var isDesktop:Boolean = Platform.isDesktop;
			var isBrowser:Boolean = Platform.isBrowser;
			
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
			var errorMessage:String = "Could not find the class {0} necessary for SVG conversion. " +
				"Check the spelling and ensure to add a reference in your main application to include the class."
			
			if (htmlClassName) {
				if (ApplicationDomain.currentDomain.hasDefinition(htmlClassName)) {
					HTMLLoaderClass = getDefinitionByName(htmlClassName);
				}
				else {
					errorMessage = StringUtil.substitute(errorMessage, htmlClassName);
					throw new Error(errorMessage);
				}
			}
			else if (HTMLLoaderClass==null && (Platform.isAir || Platform.isDesktop)) {
				htmlClassName = defaultHTMLClassName;
				
				if (ApplicationDomain.currentDomain.hasDefinition(htmlClassName)) {
					HTMLLoaderClass = getDefinitionByName(htmlClassName);
				}
				else {
					errorMessage = StringUtil.substitute(errorMessage, htmlClassName);
					throw new Error(errorMessage);
				}
			}
			
			//htmlText = "<html><script>"+browserConversionFunction+"</script><body></body></html>";
			htmlText = "<html><body></body></html>";
			htmlLoader = new HTMLLoaderClass();
			htmlLoader.loadString(htmlText);
			htmlLoader.addEventListener(Event.COMPLETE, function(e:Event):void {htmlLoaderLoaded = true;});
		}
		
		/**
		 * Used to make convert work in the browser
		 * */
		public static function initializeInBrowser():void {
			insertValidationScript();
		}
		
		/**
		 * Adds the JavaScript method in the browser web page to validate XML. 
		 * Must be called before the JavaScript validation calls will work
		 * */
		private static function insertValidationScript():void {
			var results:Boolean = ExternalInterface.call("document.insertScript = function() { " + browserConversionFunction + "; return true;}");
			addedSVGFunctionToPage = results;
		}
		
		/**
		 * Used as a callback from the browser DOM. Not used at this time. 
		 * */
		private static function universalCallback(... rest):void {
			//lastResult = String(rest[0]);
			//trace("WHEN??? universalCallback = " + rest[0]);
		}
		
		/**
		 * Function used to validate XML 
		 * can also use "application/xml", image/svg+xml, text/html
		 * 
	     * https://developer.mozilla.org/en-US/docs/Web/API/DOMParser
		 * 
		 * enum SupportedType {
		 *	  "text/html",
		 *    "text/xml",
		 *    "application/xml",
		 *    "application/xhtml+xml",
		 *    "image/svg+xml"
		 * }
		 * 
		 * https://w3c.github.io/DOM-Parsing/
		 * */
		public static var browserConversionFunction:String = <xml><![CDATA[
			function (svg, xsl) {
				var output;
				var errorMessage;

				// code for IE
				if (window.ActiveXObject) {
					var xmlDoc;
					var xslt;
					var processor;
					var objXSLTProc;
					
					xslt = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
					xmlDoc = new ActiveXObject("Microsoft.XMLDOM"); 
					processor = new ActiveXObject("Msxml2.XSLTemplate");
					
					xmlDoc.async = false;
					xmlDoc.validateOnParse = false;
					xmlDoc.resolveExternals = false;
					xmlDoc.preserveWhiteSpace = false 
					
					xmlDoc.loadXML(svg);
					xslt.loadXML(xsl);
					
					processor.stylesheet = xslt;
					
					objXSLTProc = processor.createProcessor();
					objXSLTProc.input = xml;
					objXSLTProc.transform();
					output = objXSLTProc.output;
					
					if (xmlDoc.parseError.errorCode != 0) {
						errorMessage = "Error Code: " + xmlDoc.parseError.errorCode + "\\n";
						errorMessage = errorMessage + "Error Reason: " + xmlDoc.parseError.reason;
						errorMessage = errorMessage + "Error Line: " + xmlDoc.parseError.line;
						return errorMessage;
					}

					return output;
				}
			
				// code for Mozilla, Firefox, Opera, etc.
				else if (document.implementation.createDocument) {
					var parser = new DOMParser();
					var xmlObject = parser.parseFromString(svg,'text/xml');
					var xslObject = parser.parseFromString(xsl,'text/xml');
					var xsltProcessor = new XSLTProcessor();
					xsltProcessor.importStylesheet(xslObject);
					var result = xsltProcessor.transformToFragment(xmlObject, document);
					var serializer = new XMLSerializer();
					output = serializer.serializeToString(result);
				
					if (xmlObject.getElementsByTagName("parsererror").length > 0) {
						errorMessage = xmlObject.toString();
						//checkErrorXML(xmlDoc.getElementsByTagName("parsererror")[0]);
						return errorMessage;
					}
					
					return output;
				}
				else {
					//return "Your browser does not support xslt";
				}
			}
			]]></xml>;

	}
}