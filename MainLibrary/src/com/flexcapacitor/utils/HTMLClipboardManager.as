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
		public function HTMLClipboardManager() {
			createChildren();
			
			super(); // event listeners in mxml get added here
		}
		
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
		public var elementIdentity:String = "window";
		public var created:Boolean;
		public var id:String;
		public static var debug:Boolean = true;
		
		public function createChildren():void {
			var marshallExceptions:Boolean;
			var results:Boolean;
			
			marshallExceptions = ExternalInterface.marshallExceptions;
			ExternalInterface.marshallExceptions = debug;
			
			if (isSupported()==false) {
				return;
			}
			else {
	 			created = true;
			}
			
			//results = enable();
			//results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID);
 			//created = results;
			
			if (debug==false) {
				ExternalInterface.marshallExceptions = marshallExceptions;
			}
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
					removeEventListener(PASTE, pasteHandler, false);
				}
				else {
					addEventListener(PASTE, pasteHandler, false, 0, true);
				}
			}
			
			return results;
		}
		
		/**
		 * Sometimes type is null or empty string. The data URI for this is:
		 * 
		 * data:;base64,
		 * 
		 * For example, if you drop .DS_Store this is the data URI string.  
		 * */
		public function pasteHandler(file:Object):void {
			var event:HTMLClipboardEvent;
			
			if (hasEventListener(PASTE)) {
				event = new HTMLClipboardEvent(PASTE);
				event.data = new HTMLClipboardData(file);
				dispatchEvent(event);
			}
		}
		
		/**
		 * Adds an event listener 
		 * */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var eventName:String;
			var callbackName:String;
			
			if (type==PASTE) {
				eventName = "paste";
				callbackName = elementIdentity+"_paste";
				ExternalInterface.addCallback(callbackName, pasteHandler);
			}
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, objectId, eventName, callbackName, debug) {
						var element;
						var application = document.getElementById(objectId);
						var useCapture = true;

						if (id=="body") {
							element = document.body;
						}
						else if (id=="window") {
							element = window;
						}
						else {
							element = document.getElementById(id);
						}

						if (debug) {
							console.log("Adding listener for: " + eventName + " to " + element);
						}
console.log("2");
						if (element==null) {
							if (debug) console.log("Element was not found: " + id);
							return false;
						}
console.log("3");
						if (application==null) {
							if (debug) console.log("application was not found: " + objectId);
							return false;
						}
console.log("4");
						var pasteFunction = function(event) {
							var preventDefault;
							var items;
							var numberOfItems;
							var files;
							var fileObject;
							var reader;
							var clipboardData;
							var blob;

							if (debug) console.log( "Paste event handler");
							
							clipboardData = event.clipboardData || event.originalEvent.clipboardData;
							
							if (clipboardData.items && clipboardData.items.length) {
								items = clipboardData.items;
							}
							else if (clipboardData.files && clipboardData.files.length) {
								items = clipboardData.files;
							}
							else {
								items = [];
							}
							
							numberOfItems = items.length;
							files = {};
							fileObject = {};

							if (debug) console.log("Item count:" + items.length);
							//if (debug) console.log(JSON.stringify(items));
							if (debug) console.log(event);
							
							for (var i = 0; i < numberOfItems; i++) {
								if (debug) console.log("Item: " + items[i].type + ", " + items[i].kind);

								// local references seem to be overwritten when in a loop and using local variables and readers
								files[i] = items[i];

								// type DataTransferItem
								if (debug) console.log(items[i]);

								if (items[i].type.indexOf("image") === 0) {
									if (debug) console.log("Getting blob");
									blob = items[i].getAsFile();
									if (debug) console.log(blob);
								}
								else {
									blob = null;
									fileObject.type = items[i].type;
									fileObject.kind = items[i].kind;
									application[callbackName](fileObject);
									continue;
								}

								reader = new FileReader();
								reader.file = files[i]; 
								
								reader.addEventListener("loadend", function (e) {
									var currentReader = e.target;
									
									loadedFile = currentReader.file; // our reference

									fileObject.dataURI = currentReader.result;
									fileObject.name = loadedFile.name;
									fileObject.type = loadedFile.type;
									fileObject.kind = loadedFile.kind;
									//fileObject.size = loadedFile.size;
									if (debug) console.log(loadedFile);
									if (debug) console.log(currentReader);
									
									if (debug) console.log("File loaded:" + fileObject.type);
									if (debug) console.log("Calling application:" + callbackName);

									application[callbackName](fileObject);
									reader.addEventListener("loadend", this);
									//application.pasteReaders[currentReader] = null;
									//delete application.pasteReaders[currentReader];
								});

								// could also be text/rtf, text/plain, text/html
								if (blob) {
									if (debug) console.log("Reading blob as data URL");
									reader.readAsDataURL(blob);
								}
							}

							if (numberOfItems==0) {
								fileObject.name = null;
								fileObject.type = "invalid";
								fileObject.dataURI = null;
								if (debug) console.log("CallbackName:" + callbackName);
							
								application[callbackName](fileObject);
							}
							else {
								//event.preventDefault();
								//event.stopPropagation();
							}

							if (debug) console.log("End of paste event handler");
						}

						if (application.clipboardHandlers==null) {
							application.clipboardHandlers = {};
						}
console.log("5");
						if (eventName=="paste") {
							if (debug) console.log("Adding paste listener");
							application.clipboardHandlers[eventName] = pasteFunction;
						}
						
						element.addEventListener(eventName, application.clipboardHandlers[eventName], useCapture);
						element.addEventListener(eventName, application.clipboardHandlers[eventName], !useCapture);

						//document.onpaste = pasteFunction;
console.log("6");
						if (debug) console.log("End of add listener");
						return true;
					}
				]]></xml>;
				var results:Boolean;
				results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID, eventName, callbackName, debug);
			}
		}
		
		/**
		 * Removes an event listener
		 * */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			
			//super.removeEventListener(type, listener, useCapture);
			
			var eventName:String;
			var callbackName:String;
			
			if (type==PASTE) {
				eventName = "paste";
				callbackName = elementIdentity+"_paste";
				ExternalInterface.addCallback(elementIdentity+"_paste", null);
			}
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, objectId, eventName, callbackName) {
						//var element = document.getElementById(id);
						var element;
						var application = document.getElementById(objectId);
						//console.log(element);

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
							return false;
						}
						
						if (application.clipboardHandlers && application.clipboardHandlers[eventName]) {
							element.removeEventListener(eventName, application.clipboardHandlers[eventName]);
						}

						return true;
					}
				]]></xml>;
				var results:Boolean;
				results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID, eventName, callbackName);
			}
		}
		
		/**
		 * Called when MXML document is initialized
		 * */
		public function initialized(document:Object, id:String):void {
			this.id = id;
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