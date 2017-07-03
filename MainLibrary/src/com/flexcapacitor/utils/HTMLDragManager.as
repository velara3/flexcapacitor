package com.flexcapacitor.utils
{
	import com.flexcapacitor.events.HTMLDragEvent;
	import com.flexcapacitor.model.HTMLDragData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.managers.SystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;

	
	/**
	 *  Dispached after a drag enter event
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="dragEnter", type="com.flexcapacitor.events.HTMLDragEvent")]
	
	/**
	 *  Dispached after a drag exit event
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="dragExit", type="com.flexcapacitor.events.HTMLDragEvent")]
	
	/**
	 *  Dispached after a drag over event
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="dragOver", type="com.flexcapacitor.events.HTMLDragEvent")]
	
	/**
	 *  Dispached after a drag drop event
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="dragDrop", type="com.flexcapacitor.events.HTMLDragEvent")]
	
	/**
	 * Adds basic support for dragging files into the browser
	 * 
<pre>
 
public function dragDropHandler(event:HTMLDragEvent):void {
	var htmlDragData:HTMLDragData;
	htmlDragData = event.data as HTMLDragData;
	
	if (htmlDragData.mimeType==HTMLDragManager.INVALID) {
		return;
	}
	
	var bitmapData:BitmapData = DisplayObjectUtils.getBitmapDataFromBase64(htmlDragData.dataURI, null, true, htmlDragData.mimeType);
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
	public class HTMLDragManager extends EventDispatcher implements IMXMLObject {
		
		/**
		 * Constructor
		 * */
		public function HTMLDragManager() {
			createChildren();
			
			super(); // event listeners in mxml get added here
		}
		
		public static const DRAG_ENTER:String = "dragEnter";
		public static const DRAG_OVER:String = "dragOver";
		public static const DRAG_EXIT:String = "dragExit";
		public static const DRAG_DROP:String = "dragDrop";
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_END:String = "dragEnd";
		
		public static const APPLICATION_XV_XML:String = "data:application/xv+xml";
		public static const TEXT_PLAIN:String = "data:text/plain";
		public static const IMAGE_JPEG:String = "data:image/jpeg";
		public static const IMAGE_JPG:String = "data:image/jpg";
		public static const IMAGE_PNG:String = "data:image/png";
		public static const IMAGE_GIF:String = "data:image/gif";
		public static const IMAGE:String = "data:image/";
		//public static const IMAGE_SWF:String = "data:image/";
		
		/**
		 * Value that is returned if the dropped file is not of an accepted type
		 * For example, if a user drops an image or a url from another browser window
		 * there is no file to process. 
		 * */
		public static const INVALID:String = "invalid";
		
		public static var debug:Boolean;
		
		public var id:String;
		public var created:Boolean;
		
		/**
		 * Identity of draggable element on the page.
		 * */
		public var elementIdentity:String = "body";
		
		/**
		 * Listen for keyboard keys. Not getting any key events while dragging in FP / Safari / Mac
		 * so listening for keys via web
		 * */
		public var addKeyListeners:Boolean;
		public var isAltKeyDown:Boolean;
		public var isShiftKeyDown:Boolean;
		public var isCTRLKeyDown:Boolean;
		public var isCommandKeyDown:Boolean;
		
		public function createChildren():void {
			var marshallExceptions:Boolean = ExternalInterface.marshallExceptions;
			ExternalInterface.marshallExceptions = debug;
			
			if (isSupported()==false) {
				return;
			}
			
			var results:Boolean = enable();
			//results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID);
 			created = results;
			
			if (debug==false) {
				ExternalInterface.marshallExceptions = marshallExceptions;
			}
		}
		
		public static function isSupported():Boolean {
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id) {
						var div = document.createElement("div");
						return (("draggable" in div) || ("ondragstart" in div && "ondrop" in div)) && "FormData" in window && "FileReader" in window;
						return true;
					}]]>
					</xml>;
				var results:Boolean;
				results = ExternalInterface.call(string);
				
				return results;
			}
			
			return false;
		}
		
		public function enable(value:Boolean = true):Boolean {
			
			if (ExternalInterface.available) {
				var disableScript:String = <xml><![CDATA[
					function(id, objectId, debug) {
						var element = id=="body" ? document.body : document.getElementById(id);
						var application = document.getElementById(objectId);
						var useCapture = true;
						var dragFunction;
						var dropFunction;
						
						if (application.dragAndDropHandlers!=null) {
							dragFunction = application.dragAndDropHandlers["globalDragOver"];
							dropFunction = application.dragAndDropHandlers["globalDragDrop"];
							
							if (dragFunction!=null) {
								element.removeEventListener("dragover", dragFunction, useCapture);
							}
							
							if (dropFunction!=null) {
								element.removeEventListener("drop", dropFunction, useCapture);
							}
						}
						
						return true;
					}]]>
					</xml>;
				
				// we must always have at least dragover and drop handlers or it doesn't handle drag drop 
				var enableScript:String = <xml><![CDATA[
					function(id, objectId, debug) {
						var element = id=="body" ? document.body : document.getElementById(id);
						var application = document.getElementById(objectId);
						var useCapture = true;
						
						var dragFunction = function(e) {
							e = e || event;
							e.preventDefault();
							if (debug) console.log("global over true");
						}
						
						var dropFunction = function(e) {
							e = e || event;
							e.preventDefault();
							if (debug) console.log("global drop true");
						}
						
						element.addEventListener("dragover", dragFunction, useCapture);
						element.addEventListener("drop", dropFunction, useCapture);
						
						if (application.dragAndDropHandlers==null) {
							application.dragAndDropHandlers = {};
							application.dragAndDropReaders = {};
						}
						
						application.dragAndDropHandlers["globalDragOver"] = dragFunction;
						application.dragAndDropHandlers["globalDragDrop"] = dropFunction;

						return true;
					}]]>
					</xml>;
				var results:Boolean;
				
				if (value) {
					results = ExternalInterface.call(enableScript, elementIdentity, ExternalInterface.objectID, debug);
				}
				else {
					results = ExternalInterface.call(disableScript, elementIdentity, ExternalInterface.objectID, debug);
				}
			}
			
			return results;
		}
		
		public function dragEnterHandler(type:String, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			if (addKeyListeners) {
				SystemManager.getSWFRoot(this).addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
				SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
				FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
			
				SystemManager.getSWFRoot(this).addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
			}
			else {
				updateKeys(ctrl, shift, alt, meta);
			}
			
			if (hasEventListener(DRAG_ENTER)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_ENTER);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		public function dragExitHandler(type:String, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			if (addKeyListeners) {
				SystemManager.getSWFRoot(this).removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
				SystemManagerGlobals.topLevelSystemManagers[0].removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
				FlexGlobals.topLevelApplication.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
				
				SystemManager.getSWFRoot(this).removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
			}
			else {
				updateKeys(ctrl, shift, alt, meta);
			}
			
			if (hasEventListener(DRAG_EXIT)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_EXIT);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		public function dragStartHandler(type:String, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			updateKeys(ctrl, shift, alt, meta);
			
			if (hasEventListener(DRAG_START)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_START);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		public function dragEndHandler(type:String, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			updateKeys(ctrl, shift, alt, meta);
			
			if (hasEventListener(DRAG_END)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_END);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		public function dragOverHandler(type:String, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			updateKeys(ctrl, shift, alt, meta);
			
			if (hasEventListener(DRAG_OVER)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_OVER);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		/**
		 * The event when a drop occurs. If there is an event listener for this event
		 * a HTMLDragEvent is created and the event has a property called data
		 * that is of type HTMLDragData. 
		 * 
		 * The HTMLDragData class has a name, dataURI and type that describes the dropped file. 
		 * 
		 * Sometimes the dropped object is invalid. In this case the type will be "invalid"
		 * or HTMLDragManager.INVALID.  
		 * 
		 * In the past when the file was invalid the type was null or empty string. But for some
		 * files the data URI for this is:
		 * 
		 * data:;base64,
		 * 
		 * For example, if you drop .DS_Store the dataURI is only, "data:;base64,".   
		 * 
		 * Or for others it is null. 
		 * 
		 * If you drag and drop an image from another browser window from another domain a 
		 * drop event is dispatched but there is no data. What has data or does not 
		 * have data is a decision of the browser manufacturers).
		 *  
		 * When this happens a drop event occurs as usual but HTMLDragData object has a type 
		 * of HTMLDragManager.INVALID and the name or dataURI are both null.
		 * 
		 * Check for the type value to handle cases like this. 
		 * */
		public function dragDropHandler(file:Object, ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			var event:HTMLDragEvent;
			var data:HTMLDragData;
			
			updateKeys(ctrl, shift, alt, meta);
			
			if (hasEventListener(DRAG_DROP)) {
				event = new HTMLDragEvent(DRAG_DROP);
				event.data = new HTMLDragData(file);
				updateEventKeys(event);
				dispatchEvent(event);
			}
		}
		
		protected function updateKeys(ctrl:Boolean, shift:Boolean, alt:Boolean, meta:Boolean):void {
			isAltKeyDown = alt;
			isCommandKeyDown = meta;
			isShiftKeyDown = shift;
			isCTRLKeyDown = ctrl;
		}
		
		protected function updateEventKeys(event:HTMLDragEvent):void {
			event.altKey = isAltKeyDown;
			event.commandKey = isCommandKeyDown;
			event.shiftKey = isShiftKeyDown;
			event.controlKey = isCTRLKeyDown;
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void {
			isCTRLKeyDown = event.ctrlKey;
			isCommandKeyDown = "commandKey" in event && event.commandKey;
			isShiftKeyDown = event.shiftKey;
			isAltKeyDown = event.altKey;
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void {
			//trace("Event target = " + event.currentTarget);
			isCTRLKeyDown = event.ctrlKey;
			isCommandKeyDown = "commandKey" in event && event.commandKey;
			isShiftKeyDown = event.shiftKey;
			isAltKeyDown = event.altKey;
		}
		
		/**
		 * Adds an event listener 
		 * */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var eventName:String;
			var callbackName:String;
			
			if (type==DRAG_ENTER) {
				eventName = "dragenter";
				callbackName = elementIdentity+"_dragEnter";
				ExternalInterface.addCallback(callbackName, dragEnterHandler);
			}
			else if (type==DRAG_EXIT) {
				eventName = "dragleave";
				callbackName = elementIdentity+"_dragExit";
				ExternalInterface.addCallback(callbackName, dragExitHandler);
			}
			else if (type==DRAG_START) {
				eventName = "dragstart";
				callbackName = elementIdentity+"_dragStart";
				ExternalInterface.addCallback(callbackName, dragStartHandler);
			}
			else if (type==DRAG_END) {
				eventName = "dragend";
				callbackName = elementIdentity+"_dragEnd";
				ExternalInterface.addCallback(callbackName, dragEndHandler);
			}
			else if (type==DRAG_DROP) {
				eventName = "drop";
				callbackName = elementIdentity+"_dragDrop";
				ExternalInterface.addCallback(callbackName, dragDropHandler);
			}
			else if (type==DRAG_OVER) {
				eventName = "dragover";
				callbackName = elementIdentity+"_dragOver";
				ExternalInterface.addCallback(callbackName, dragOverHandler);
			}
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, objectId, eventName, callbackName, debug) {
						var element = id=="body" ? document.body : document.getElementById(id);
						var application = document.getElementById(objectId);
						var useCapture = true;

						if (debug) {
							console.log("Adding listener for: " + eventName + " to " + element);
						}

						if (element==null) {
							if (debug) console.log("Element was not found: " + id);
							return false;
						}

						if (application==null) {
							if (debug) console.log("application was not found: " + objectId);
							return false;
						}
						
						var dragFunction = function(event) {
							event.preventDefault();
							event.stopPropagation();
							
							if (debug) console.log(event);
							if (debug) console.log("drag prevented:"+event.type);
							if (debug) console.log("calling callback:"+callbackName);
							
							application[callbackName](event.type, event.ctrlKey, event.shiftKey, event.altKey, event.metaKey);
						}
						
						var dropFunction = function(event) {
							event.preventDefault();
							event.stopPropagation();
							
							var droppedFiles = event.dataTransfer.files;
							var numberOfFiles = droppedFiles.length;
							var files = {};
							var fileObject = {};
							var reader;

							if (debug) console.log("Drop. File count:" + droppedFiles.length);
							if (debug) console.log(event);
							
							for (var i = 0; i < numberOfFiles; i++) {
								files[i] = droppedFiles[i];
								if (debug) console.log("Loading file: " + files[i].name + " " + files[i].size);
								reader = new FileReader();
								reader.file = files[i];
								
								reader.addEventListener("loadend", function (e) {
									var currentReader = e.target;
									
									loadedFile = currentReader.file;
									fileObject.dataURI = currentReader.result;
									fileObject.name = loadedFile.name;
									fileObject.type = loadedFile.type;
									
									if (debug) console.log( "File loaded:" + fileObject.name);
									if (debug) console.log(" Calling:"+callbackName);

									application[callbackName](fileObject, event.ctrlKey, event.shiftKey, event.altKey, event.metaKey);

									//application.dragAndDropReaders[currentReader] = null;
									//delete application.dragAndDropReaders[currentReader];
								});
								
								reader.readAsDataURL(files[i]);
							}

							if (numberOfFiles==0) {
								fileObject.name = null;
								fileObject.type = "invalid";
								fileObject.dataURI = null;
								application[callbackName](fileObject, event.ctrlKey, event.shiftKey, event.altKey, event.metaKey);
							}
						}

						if (eventName=="drop") {
							if (debug) console.log("adding drop listener");
							application.dragAndDropHandlers[eventName] = dropFunction;
						}
						else {
							if (debug) console.log("adding drag listener");
							application.dragAndDropHandlers[eventName] = dragFunction;
						}
						
						element.addEventListener(eventName, application.dragAndDropHandlers[eventName], useCapture);
						if (debug) console.log("end of add listener");
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
			
			super.removeEventListener(type, listener, useCapture);
			
			var eventName:String;
			var callbackName:String;
			
			if (type==DRAG_ENTER) {
				eventName = "dragenter";
				callbackName = elementIdentity+"_dragEnter";
				ExternalInterface.addCallback(elementIdentity+"_dragEnter", null);
			}
			else if (type==DRAG_EXIT) {
				eventName = "dragleave";
				callbackName = elementIdentity+"_dragExit";
				ExternalInterface.addCallback(elementIdentity+"_dragExit", null);
			}
			else if (type==DRAG_START) {
				eventName = "dragstart";
				callbackName = elementIdentity+"_dragStart";
				ExternalInterface.addCallback(elementIdentity+"_dragStart", null);
			}
			else if (type==DRAG_END) {
				eventName = "dragend";
				callbackName = elementIdentity+"_dragEnd";
				ExternalInterface.addCallback(elementIdentity+"_dragEnd", null);
			}
			else if (type==DRAG_DROP) {
				eventName = "drop";
				callbackName = elementIdentity+"_dragDrop";
				ExternalInterface.addCallback(elementIdentity+"_dragDrop", null);
			}
			else if (type==DRAG_OVER) {
				eventName = "dragover";
				callbackName = elementIdentity+"_dragOver";
				ExternalInterface.addCallback(elementIdentity+"_dragOver", null);
			}
			
			if (ExternalInterface.available) {
				var string:String = <xml><![CDATA[
					function(id, objectId, eventName, callbackName) {
						//var element = document.getElementById(id);
						var element = document.body;
						var application = document.getElementById(objectId);
						//console.log(element);

						if (element==null) {
							return false;
						}
						
						element.removeEventListener(eventName, application.dragAndDropHandlers[eventName]);
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