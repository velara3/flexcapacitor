package com.flexcapacitor.utils
{
	import com.flexcapacitor.events.HTMLDragEvent;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import mx.core.IMXMLObject;

	
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
	var fileObject:Object = event.data;

	if (!(fileObject is String)) {
		trace("Dropped " + fileObject.name);
		trace(file.dataURI);
	}
}
</pre>
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
		 * Identity of draggable element on the page.
		 * */
		public var elementIdentity:String = "body";
		public var created:Boolean;
		public static var debug:Boolean;
		
		public function createChildren():void {
			var marshallExceptions:Boolean = ExternalInterface.marshallExceptions;
			ExternalInterface.marshallExceptions = debug;
			
			if (isSupported()==false) {
				return;
			}
			
			var results:Boolean = enable();
			//results = ExternalInterface.call(string, elementIdentity, ExternalInterface.objectID);
 			created = results;
			
			ExternalInterface.marshallExceptions = marshallExceptions;
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
		
		public function dragEnterHandler(type:String = null):void {
			
			if (hasEventListener(DRAG_ENTER)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_ENTER);
				dispatchEvent(event);
			}
		}
		
		public function dragExitHandler(type:String = null):void {
			
			if (hasEventListener(DRAG_EXIT)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_EXIT);
				dispatchEvent(event);
			}
		}
		
		public function dragStartHandler(type:String = null):void {
			
			if (hasEventListener(DRAG_START)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_START);
				dispatchEvent(event);
			}
		}
		
		public function dragEndHandler(type:String = null):void {
			
			if (hasEventListener(DRAG_END)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_END);
				dispatchEvent(event);
			}
		}
		
		public function dragOverHandler(type:String = null):void {
			
			if (hasEventListener(DRAG_OVER)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_OVER);
				dispatchEvent(event);
			}
		}
		
		public function dragDropHandler(file:Object):void {
			
			if (hasEventListener(DRAG_DROP)) {
				var event:HTMLDragEvent = new HTMLDragEvent(DRAG_DROP);
				event.data = file;
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
							
							if (debug) console.log("drag prevented:"+event.type);
							if (debug) console.log("calling callback:"+callbackName);
							application[callbackName](event.type);
						}
						
						var dropFunction = function(event) {
							event.preventDefault();
							event.stopPropagation();
							
							var droppedFiles = event.dataTransfer.files;
							var numberOfFiles = droppedFiles.length;
							var files = {};
							var fileObject = {};
							var reader;

							if (debug) console.log( "Drop. File count:" + droppedFiles.length);
							if (debug) console.log( event);
							
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

									application[callbackName](fileObject);

									//application.dragAndDropReaders[currentReader] = null;
									//delete application.dragAndDropReaders[currentReader];
								});
								
								reader.readAsDataURL(files[i]);
							}

							if (numberOfFiles==0) {
								fileObject.name = null;
								fileObject.type = "invalid";
								fileObject.dataURI = null;
								application[callbackName](fileObject);
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
			
		}
	}
}