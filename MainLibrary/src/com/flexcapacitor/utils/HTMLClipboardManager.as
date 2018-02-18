package com.flexcapacitor.utils
{
	import com.flexcapacitor.events.HTMLClipboardEvent;
	import com.flexcapacitor.model.HTMLClipboardData;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import mx.core.IMXMLObject;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;

	
	/**
	 *  Dispached after a paste event
	 *
	 *  @eventType com.flexcapacitor.events.HTMLClipboardEvent
	 */
	[Event(name="paste", type="com.flexcapacitor.events.HTMLClipboardEvent")]
	
	/**
	 *  Dispached before a paste event is processed
	 *
	 *  @eventType com.flexcapacitor.events.HTMLClipboardEvent
	 */
	[Event(name="beforePaste", type="com.flexcapacitor.events.HTMLClipboardEvent")]
	
	
	/**
	 * Adds basic support for retrieving content pasted into the browser
	 * 
<pre>
 
public function htmlPasteHandler(event:HTMLDragEvent):void {
	var htmlClipboardData:HTMLClipboardData;
	htmlClipboardData = event.data as HTMLClipboardData;
	
	if (htmlClipboardData.mimeType==HTMLClipboardManager.INVALID) {
		return;
	}
	
	var bitmapData:BitmapData = DisplayObjectUtils.getBitmapDataFromBase64(htmlClipboardData.dataURI, null, true, htmlClipboardData.mimeType);
}
</pre>
	 * <br/>
	 * Errors: <br/><br/>
	 * 
	 * SecurityError: Error #2060: Security sandbox violation: ExternalInterface caller file:///Users/me/Documents/projects/myproject/MyApp/bin-debug/MyApp.swf cannot access file:///Users/me/Documents/projects/myproject/MyApp/bin-debug/MyApp.html.
		at flash.external::ExternalInterface$/_initJS()
		at flash.external::ExternalInterface$/call()
		at com.flexcapacitor.utils::HTMLDragManager$/isSupported()[/Users/me/Documents/projects/flexcapacitor/MainLibrary/src/com/flexcapacitor/utils/HTMLDragManager.as:114]<br/>
	 * 
	 * Possible Solutions: <br/>
	 * Run clean and try again. <br/>
	 * Restart FB or your browser and launch again<br/>
	 * Instead of running the page on file:// use http:// <br/>
	 * In your wrapper page set allowscriptaccess: "always"<br/>
	 * http://stackoverflow.com/questions/26921469/swf-sandbox-violation-error-2060-in-chrome
	 * */
	public class HTMLClipboardManager extends EventDispatcher implements IMXMLObject {
		
		/**
		 * Constructor
		 * */
		public function HTMLClipboardManager(id:String = null) {
			initialize();
			
			super(); // event listeners in mxml get added here
			
			// if created in code pass in ID of HTML element to listen for paste events
			// if declared in MXML set attributes of HTML element on the page
			// and then call reinitialize when html element is created
			if (id) {
				enableElement(id);
			}
		}
		
		public static const BEFORE_PASTE:String = "beforePaste";
		public static const PASTE:String = "paste";
		public static const COPY:String = "copy";
		public static const CUT:String = "cut";
		
		public static const APPLICATION_XV_XML:String = "data:application/xv+xml";
		public static const TEXT_PLAIN:String = "data:text/plain";
		public static const IMAGE_JPEG:String = "data:image/jpeg";
		public static const IMAGE_JPG:String = "data:image/jpg";
		public static const IMAGE_PNG:String = "data:image/png";
		public static const IMAGE_GIF:String = "data:image/gif";
		public static const IMAGE:String = "data:image/";
		//public static const IMAGE_SWF:String = "data:image/";
		
		/**
		 * Value that is returned if the pasted file is not of an accepted type
		 * For example, if a user pastes an image or a url from another browser window
		 * there is no file to process. 
		 * */
		public static const INVALID:String = "invalid";
		
		/**
		 * Identity of pastable element on the page.
		 * */
		public var elementIdentity:String;
		public var created:Boolean;
		public var runAtStartup:Boolean = true;
		public var id:String;
		public static var debug:Boolean = true;
		
		[Embed(source="./supportClasses/clipboardFunction.js", mimeType="application/octet-stream")]
		public var imageFunction:Class;
		public var imageFunctionValue:String;
		
		/**
		 * Create byte array from base 64 when available
		 **/
		public var createByteArray:Boolean;
		
		public function initialize():void {
			var marshallExceptions:Boolean;
			var results:Boolean;
			
			if (debug) {
				ExternalInterface.marshallExceptions = true;
			}
			
			if (isSupported()==false) {
				return;
			}
			else {
	 			created = true;
			}
			
			imageFunctionValue = new imageFunction();
		}
		
		/**
		 * Called when MXML document is initialized
		 * */
		public function initialized(document:Object, id:String):void {
			this.id = id;
			
			if (runAtStartup) {
				addHandlers();
			}
		}
		
		/**
		 * If you create an HTML element after this class is created you will
		 * need to set up the element. Pass in the id of the element on the page 
		 **/
		public function enableElement(id:String):void {
			removeHandlers();
			elementIdentity = id;
			addHandlers();
		}
		
		/**
		 * If you create an HTML element after this class is created you will
		 * need to set up the element. Pass in the id of the element on the page 
		 **/
		public function disableElement(id:String):void {
			removeHandlers();
			elementIdentity = id;
			removeHandlers();
		}
		
		/**
		 * If HTML element needs to be enabled and element name is already defined
		 * then call this method to add paste handlers to the element
		 **/
		public function refresh():void {
			removeHandlers();
			elementIdentity = id;
			addHandlers();
		}
		
		/**
		 * No test is made to check for this yet
		 * */
		public static function isSupported():Boolean {
			var results:Boolean;
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, debug) {
						if (debug) console.log("All good");
						return true;
					}]]>
					</xml>;
				results = ExternalInterface.call(string);
				
				return results;
			}
			
			return false;
		}
		
		public function enable(value:Boolean = true):Boolean {
			
			if (ExternalInterface.available) {
				var results:Boolean;
				
				if (value) {
					addHandlers();
				}
				else {
					removeHandlers();
				}
			}
			
			return results;
		}
		
		public function disable():void {
			enable(false);
		}
		
		/**
		 * Handles paste event. Dispatches an event that contains a HTMLClipboardData object.
		 * The type is sometimes null or empty string. The data URI for this is:
		 * 
		 * data:;base64,
		 * 
		 * For example, if you drop .DS_Store this is the data URI string.
		 * 
		 * If the type is invalid then the paste operation was not successful. 
		 * This results when the object pasted is not compatible or accepted type.   
		 * */
		public function pasteHandler(file:Object):Boolean {
			var event:HTMLClipboardEvent;
			var eventType:String = file.eventType;
			
			if (eventType==BEFORE_PASTE) {
				
				if (hasEventListener(BEFORE_PASTE)) {
					event = new HTMLClipboardEvent(BEFORE_PASTE);
					event.data = new HTMLClipboardData(file);
					dispatchEvent(event);
				}
				return event.isDefaultPrevented();
			}
			
			if (hasEventListener(PASTE)) {
				event = new HTMLClipboardEvent(PASTE);
				event.data = new HTMLClipboardData(file, createByteArray);
				dispatchEvent(event);
				return event.isDefaultPrevented();
			}
			
			return false;
		}
		
		/**
		 * Adds an event listener 
		 * */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		/**
		 * Add event handlers to element. Exits if element can't be found. 
		 **/
		public function addHandlers():void {
			var eventName:String;
			var callbackName:String;
			var elementExists:Boolean;
			
			elementExists = getElementExists(elementIdentity);
			
			if (!elementExists) {
				return;
			}
			
			eventName = "paste";
			callbackName = elementIdentity+"_paste";
			ExternalInterface.addCallback(callbackName, pasteHandler);
			
			
			if (ExternalInterface.available) {
				var results:Boolean;
				results = ExternalInterface.call(imageFunctionValue, elementIdentity, ExternalInterface.objectID, eventName, callbackName, debug);
				//results = ExternalInterface.call("addPasteListeners", elementIdentity, ExternalInterface.objectID, eventName, callbackName, debug);
				
				if (!results) {
					throw new Error("Error in JavaScript");
				}
			}
		}
		
		/**
		 * Removes an event listener
		 * */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			
			super.removeEventListener(type, listener, useCapture);
			
		}
		
		public function removeHandlers():void {
			var eventName:String;
			var callbackName:String;
			
			if (elementIdentity==null) {
				return;
			}
			
			eventName = PASTE;
			callbackName = elementIdentity+"_paste";
			ExternalInterface.addCallback(elementIdentity+"_paste", null);
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, objectId, eventName, callbackName, debug) {
						var application = document.getElementById(objectId);
						var element;

						if (debug) {
							console.log("Removing listeners");
						}

						if (id=="body") {
							element = document.body;
						}
						else if (id=="window") {
							element = window;
						}
						else {
							element = document.getElementById(id);
						}

						if (element==null) {
							return true;
						}
						
						if (application.clipboardHandlers && application.clipboardHandlers[eventName]) {
							element.removeEventListener(eventName, application.clipboardHandlers[eventName]);
						}

						return true;
					}
				]]></xml>;
				var results:Boolean;
				results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID, eventName, callbackName, debug);
			}
		}
		
		/**
		 * Checks if the element exists on the page
		 **/
		public function getElementExists(id:String):Boolean {
			if (ExternalInterface.available) {
				var elementString:String = <xml><![CDATA[
					function(id, objectId, debug) {
						var element;

						if (id=="body") {
							element = document.body;
						}
						else if (id=="window") {
							element = window;
						}
						else {
							element = document.getElementById(id);
						}

						return element!=null;
					}
				]]></xml>;
				var elementExists:Boolean;
				elementExists = ExternalInterface.call(elementString, id, ExternalInterface.objectID, debug);
			}
			
			return elementExists;
		}
		
		public static var removeBase64HeaderPattern:RegExp = /.*base64,/si;
		public static var lineEndingsGlobalPattern:RegExp = /\n/g;
		
		/**
		 * Used to encode images
		 * */
		public static var base64Encoder:Base64Encoder;
		
		/**
		 * Used to decode images
		 * */
		public static var base64Decoder:Base64Decoder;
		
		/**
		 * Alternative base 64 encoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Encoder2:Object;
		
		/**
		 * Alternative base 64 decoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Decoder2:Object;
		
		/**
		 * Returns a byte array from a base 64 string. Need to remove the header text, ie "data:image/png;base64,"
		 * and possibly line breaks.
		 * 
		 * @param alternativeEncoder Set the static Base64Decoder2 property to an alternative decoder before calling this.
		 * @see #getBitmapDataFromByteArray()
		 * @see #getBase64ImageData()
		 * @see #getBase64ImageDataString()
		 * */
		public static function getByteArrayFromBase64(encoded:String, alternativeDecoder:Boolean = false, removeHeader:Boolean = true, removeLinebreaks:Boolean = true):ByteArray {
			var results:ByteArray;
			
			if (!alternativeDecoder) {
				if (!base64Decoder) {
					base64Decoder = new Base64Decoder();
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				base64Decoder.reset();
				base64Decoder.decode(encoded);
				results = base64Decoder.toByteArray();
				
				// if you get the following error then try removing the header or line breaks
				//    Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			}
			else {
				if (Base64Decoder2==null) {
					throw new Error("Set the static alternative base decoder before calling this method");
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				Base64Decoder2.reset();
				Base64Decoder2.decode(encoded);
				results = Base64Decoder2.toByteArray();
			}
			
			/*
			Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			at mx.utils::Base64Decoder/flush()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:139]
			at mx.utils::Base64Decoder/toByteArray()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:173]
			at com.flexcapacitor.utils::DisplayObjectUtils$/getByteArrayFromBase64()[/Users/monkeypunch/Documents/ProjectsGithub/flexcapacitor/MainLibrary/src/com/flexcapacitor/utils/DisplayObjectUtils.as:1673]
			*/
			
			return results as ByteArray;
		}
	}
}