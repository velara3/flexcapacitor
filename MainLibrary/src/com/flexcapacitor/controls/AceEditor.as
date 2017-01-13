/**
 
  Ace Editor ActionScript 3 class

  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

 **/

/**
    The Ace Editor JavaScript class
	
    The Ace source code is released under the BSD License. This license is very simple, 
    and is friendly to all kinds of projects, whether open source or not. Take charge 
    of your editor and add your favorite language highlighting and keybindings!
   
	Copyright (c) 2010, Ajax.org B.V.
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	    * Redistributions of source code must retain the above copyright
	      notice, this list of conditions and the following disclaimer.
	    * Redistributions in binary form must reproduce the above copyright
	      notice, this list of conditions and the following disclaimer in the
	      documentation and/or other materials provided with the distribution.
	    * Neither the name of Ajax.org B.V. nor the
	      names of its contributors may be used to endorse or promote products
	      derived from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 
  ***/
package com.flexcapacitor.controls {

	import com.flexcapacitor.events.AceEvent;
	import com.flexcapacitor.utils.ClassUtils;
	import com.flexcapacitor.utils.supportClasses.log;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.NameUtil;
	import mx.utils.Platform;
	
	import spark.core.IDisplayText;
	import spark.events.TextOperationEvent;
	
	import avmplus.getQualifiedClassName;
	
	import flashx.textLayout.operations.FlowOperation;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispached when the editor has been created
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="editorReady", type="flash.events.Event")]
	
	/**
	 *  Dispatched after the last loading operation caused by
	 *  setting the <code>location</code> or <code>htmlText</code>
	 *  property has completed.
	 *
	 *  <p>This event is always dispatched asynchronously,
	 *  after the JavaScript <code>load</code> event
	 *  has been dispatched in the HTML DOM.</p>
	 *
	 *  <p>An event handler for this event may call any method
	 *  or access any property of this control
	 *  or its internal <code>htmlLoader</code>.</p>
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 * 
	 *  @see location
	 *  @see htmlText
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *  Dispatched after the HTML DOM has been initialized
	 *  in response to a loading operation caused by
	 *  setting the <code>location</code> or <code>htmlText</code> property.
	 *
	 *  <p>When this event is dispatched,
	 *  no JavaScript methods have yet executed.
	 *  The <code>domWindow</code>and <code>domWindow.document</code>
	 *  objects exist, but other DOM objects may not.
	 *  You can use this event to set properties
	 *  onto the <code>domWindow</code> and <code>domWindow.document</code>
	 *  objects for JavaScript methods to later access.</p>
	 *
	 *  <p>A handler for this event should not set any properties
	 *  or call any methods which start another loading operation
	 *  or which affect the URL for the current loading operation;
	 *  doing so causes either an ActionScript or a JavaScript exception.</p>
	 *
	 *  @eventType flash.events.Event.HTML_DOM_INITIALIZE
	 * 
	 *  @see location
	 *  @see htmlText
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="htmlDOMInitialize", type="flash.events.Event")]
	
	/**
	 *  Dispatched when this control's HTML content initially renders,
	 *  and each time that it re-renders.
	 *
	 *  <p>Because an HTML control can dispatch many of these events,
	 *  you should avoid significant processing in a <code>render</code>
	 *  handler that might negatively impact performance.</p>
	 *
	 *  @eventType flash.events.Event.HTML_RENDER
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="htmlRender", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the <code>location</code> property changes.
	 *
	 *  <p>This event is always dispatched asynchronously.
	 *  An event handler for this event may call any method
	 *  or access any property of this control
	 *  or its internal <code>htmlLoader</code>.</p>
	 *
	 *  @eventType flash.events.Event.LOCATION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="locationChange", type="flash.events.Event")]
	
	/**
	 *  Dispatched when an uncaught JavaScript exception occurs.
	 *
	 *  <p>This event is always dispatched asynchronously.
	 *  An event handler for this event may call any method
	 *  or access any property of this control
	 *  or its internal <code>htmlLoader</code>.</p>
	 *
	 *  The actual event type is flash.events.HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION
	 *  but then it won't find the class when running in the browser.
	 *  
	 *  VerifyError: Error #1014: Class flash.events::HTMLUncaughtScriptExceptionEvent could not be found.
	 * 
	 *  @eventType flash.events.Event
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="uncaughtScriptException", type="flash.events.Event")]
	
	/**
	 *  Dispached when the user presses CTRL + S on Win and Linux or CMD + S on Mac
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="save", type="flash.events.Event")]
	
	/**
	 *  Dispached when the user presses CTRL + F on Win or Linux or CMD + F on Mac 
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="find", type="flash.events.Event")]
	
	/**
	 *  Dispached as the mouse moves over the editor.
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="mousemove", type="com.flexcapacitor.events.AceEvent")]
	
	/**
	 *  Dispached after the cursor changes positions.
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="changeCursor", type="com.flexcapacitor.events.AceEvent")]
	
	/**
	 *  Dispached after the session has changed
	 *
	 *  @eventType flash.events.Event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="changeSession", type="com.flexcapacitor.events.AceEvent")]
	
	/**
	 *  Dispached after the selection anchor position and/or
	 *  selection active or lead position properties have changed
	 *  for any reason.
	 *
	 *  @eventType flash.events.Event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="changeSelection", type="com.flexcapacitor.events.AceEvent")]
	
	/**
	 *  Dispatched after a user editing operation is complete.
	 *
	 *  @eventType spark.events.TextOperationEvent.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="change", type="com.flexcapacitor.events.AceEvent")]
	
	
	/**
	 * Ace editor for AIR apps. For this to work you must do the following things. <br/><br/>
	 * 
	 * To run in Air on the desktop you must: <br/>
	 * • You need to copy the ace source code (src-min-noconflict)  <br/>
	 * • You must copy the ace.html page into your project src directory.<br/>
	 * • You must set a reference to the airClass to HTMLLoader or FlexHTMLLoader.<br/><br/>
	 * 
	 * To run in the browser you must: <br/>
	 * • Copy the ace source code (src-min-noconflict) to your project src directory (customizable) or destination directory.<br/>
	 * • You must set a reference to the browserClass to IFrame component or I might add support to create it dynamically in the future.<br/>
	 * • You must set the wmode to opaque or transparent on the HTML wrapper. I can't remember which.<br/><br/>
	 *   
	 * The ace.html page is included in this library in a sub directory and the ace source is available at 
	 * http://ace.c9.io/ or on github (link further down).<br/><br/>
	 * 
	 * The editor automatically loads unless you set loadOnCreationComplete to false.
	 * If it is false then call initializeEditor() when you want to load the editor. <br/><br/>
	 * 
	 * Only about 3/4ths of the API is supported at this time but you have references to the 
	 * objects so you can add or access additional API and events through them.
	 * More instructions are at the http://ace.c9.io/ website.<br/><br/>
	 * 
	 * Use the editor.on() method to add listeners and editor.off() to remove them. <br/><br/>
	 * 
	 * Listening and dispatching events duration: Average:4ms with debug build.<br>
	 * Not listening or dispatching events duration: Average:1ms with debug build.<br/><br/>
	 * 
	 * A "editorReady" event is dispatched when the editor is ready to use. The 
	 * bindable isEditorReady property is also set to true when the editor is ready. <br/><br/>
	 * 
	 * There is a related AceTextInput that makes it easier to perform searches on 
	 * an Ace editor instance.<br/><br/> 
	 * 
	 * You can also uncomment the search javascript file in the ace.html page to 
	 * use the search input built into ace editor.<br/><br/> 
	 * 
	 * To use in MXML:<br/>
<pre>
&lt;local:AceEditor id="aceEditor" height="100%" width="100%"
		top="60" left="0" right="0" bottom="30" 
		airClass="{FlexHTMLLoader}"
		editorReady="aceEditorReadyHandler(event);trace('You can access aceEditor.editor now')"
		selectionChange="ace_selectionChangeHandler(event)"
		cursorChange="ace_cursorChangeHandler(event)"
		mouseMoveOverEditor="ace_mouseMoveOverChangeHandler(event)"
		pathToTemplate="app:/ace.html"/>
		
&lt;s:TextInput id="searchInput" prompt="Search" 
		change="searchInput_clickHandler(event)"
		enter="searchInput_clickHandler(event)"/>


public function selectionChangeHandler(event:Object, editor:Object):void {
	var type:String = event.type; // changeSelection
	anchor = editor.anchor;
	lead = editor.lead;
}

protected function ace_cursorChangeHandler(event:Event):void {
	var cursorPositionLabel:String = ace.row + ":" + ace.column;
	var token:Object = ace.getTokenAt(ace.row, ace.column);
	var tokenLabel:String = token ? token.type : "";
}

protected function ace_mouseMoveOverEditorHandler(event:Event):void {
	var position:Object = ace.mouseMoveEvent.getDocumentPosition();
	var mousePositionLabel:String = position.row + ":" + position.column;
	var token:Object = ace.getTokenAt(position.row, position.column);
	var tokenLabel:String = token ? token.type : "";
}

protected function aceEditorReadyHandler(event:Event):void {
	ace.isEditorReady; // true when editor is ready
	ace.setMode("ace/mode/html");
	ace.setValue(myHTMLContent);
}

private var lastSearchValue:String;
		
protected function searchInput_clickHandler(event:Event):void {
	var searchText:String = searchInput.text;
	
	// enter key pressed
	if (lastSearchValue==searchText) {
		lastFocusedEditor.findNext(searchText);
	}
	// change event
	else {
		var selectionAnchor:Object = aceEditor.getSelectionAnchor();
		var options:Object = {start:{row:selectionAnchor.row,column:selectionAnchor.column}};
		var result:Object = aceEditor.find(searchInput.text, options);
	}
	
	lastSearchValue = searchText;
}

protected function searchInput_changeHandler(event:Event):void {
	var searchText:String = searchInput.text;
	
	// enter key pressed
	if (lastSearchValue==searchText) {
		
		if (searchText!="") {
			if (!shiftDown) {
				lastFocusedEditor.findNext(null);
			}
			else {
				lastFocusedEditor.findPrevious(null);
			}
		}
	}
	
	// change event
	else {
		var options:Object = {};
		options.skipCurrent = false;
		var result:Object = lastFocusedEditor.find(searchInput.text, options);
	}
	
	lastSearchValue = searchText;
}
</pre>
	 * 
	 * Marshalled Errors: 
	 * 
	 * Error: ReferenceError: object is not defined.
	 * That means in the JavaScript function an object is not defined. The editor may not be created yet.  
	 * 
	 * Error: Error: Error calling method on NPObject!
	 *		at flash.external::ExternalInterface$/_toAS()
	 *		at flash.external::ExternalInterface$/call()
	 * 
	 * The listener you added is private or protected. It must be a public method
	 * 
	 * ReferenceError: method is not defined
	 * The method is not defined on the application. Create a strong reference (store function). 
	 * 
	 * Error: Bad NPObject as private data!
	 * The event passed from JS to AS is of an incompatible type. 
	 * Flash expected an event with the same type as declared in events metadata but event is 
	 * transfered typed as an object.
	 * Or there are an incorrect number of arguments  
	 * 
	 * Ace Editor Website - http://ace.c9.io/<br>
	 * Ace Editor Source Code - https://github.com/ajaxorg/ace/blob/master/lib/ace/editor.js<br>
	 * 
	 * @see https://github.com/ajaxorg/ace/blob/master/lib/ace/editor.js
	 * @see http://ace.c9.io/#nav=howto
	 * */	
	public class AceEditor extends UIComponent implements IAceEditor, IDisplayText {
		
		
		public function AceEditor(airClassName:String = null, browserClassName:String = null) {
			isBrowser = Platform.isBrowser;
			isAIR = Platform.isAir;
			isMobile = Platform.isMobile;
			
			if (debug) {
				log();
			}
			
			
			if (airClassName) {
				airClass = ApplicationDomain.currentDomain.getDefinition(airClassName); 
			}
			if (browserClassName) {
				browserClass = ApplicationDomain.currentDomain.getDefinition(browserClassName); 
			}
			
			
			if (eventsDictionary==null) {
				eventsDictionary = new Dictionary(true);
				eventsDictionary[Event.COPY] 				= EDITOR;
				eventsDictionary[Event.PASTE] 				= EDITOR;
				eventsDictionary[SESSION_MOUSE_MOVE] 		= EDITOR;
				
				eventsDictionary[BLUR] 						= SESSION;
				eventsDictionary[FOCUS] 					= SESSION;
				eventsDictionary[EDITOR_CHANGE] 			= SESSION;
				eventsDictionary[SESSION_CHANGE_SESSION] 	= SESSION;
				
				eventsDictionary[SESSION_CHANGE_SELECTION] 	= SELECTION;
				eventsDictionary[SESSION_CHANGE_CURSOR] 	= SELECTION;
			}
			
			super();
			
			// Desktop version
			// Step 1. Create an HTMLLoader instance in createChildren and add listeners
			// Step 2. Listen for the initialize event and set the location to the ace HTML page
			// Step 3. After completeHandler page is loaded. Create a reference to the ace editor
			// Step 4. Invalidate properties
			// Step 5. In commitProperties set values on ace editor
			
			// Browser version
			// Step 1. Flex calls createChildren and we create a div and editor in the browser  
			// Step 2. In createChildren manually call completeHandler()
			// Step 3. Invalidate properties
			// Step 4. In commitProperties call methods that communicate with the browser
		}
		
		public static var UNCAUGHT_SCRIPT_EXCEPTION:String = "uncaughtScriptException";
		
		/**
		 * Version of ace core version
		 * */
		public var version:String;
		
		/**
		 * Class to use when running in the browser.
		 * 
		 * Typically you would set this to something like an iframe component
		 * */
		public var browserClass:Object;
		
		/**
		 * Class to use when running on a mobile device.
		 * 
		 * */
		public var mobileClass:Object;
		
		/**
		 * Class to use when running in the desktop in AIR.
		 * 
		 * Typically you would set this to something like an HTML component
		 * 
		 * @see flash.html.HTMLLoader
		 * */
		public var airClass:Object;
		
		/**
		 * Class to use when running in the desktop in AIR.
		 * 
		 * Typically you would set this to something like an HTML component
		 * 
		 * @see mx.core.FlexHTMLLoader
		 * @see mx.controls.HTML
		 * */
		public var defaultAIRClassName:String = "mx.controls.HTML";
		public var defaultBrowserClassName:String;
		public var defaultMobileClassName:String;
		
		public static var isBrowser:Boolean;
		public static var isAIR:Boolean;
		public static var isMobile:Boolean;
		
		public static var isHTMLLoader:Boolean;
		
		/**
		 * Use external interface to connect while in the browser
		 * */
		public var useExternalInterface:Boolean = true;
		public var HTMLLoaderLoaded:Boolean;
		
		public var browserInstance:Object;
		public var airInstance:Object;
		public var mobileInstance:Object;
		
		public var editorContainer:Object;
		
		public static var editors:Object = new Dictionary(true);
		
		/**
		 * Gets the editor by the editor id. Useful when using in the browser
		 * and using multiple editors on the page. Pass in the editor id. 
		 * The class has a editorIdentity that is unique for each editor instance. 
		 * */
		public static function addEditorById(id:String, instance:AceEditor):void {
			if (editors[id]) {
				throw new Error("Editor already created");
			}
			
			editors[id] = instance;
		}
		
		public static function removeEditorById(id:String):void {
			if (editors[id]) {
				delete editors[id];
			}
		}
		
		public static function getEditorById(id:String):AceEditor {
			return editors[id];
		}
		
		public static var debug:Boolean = false;
		
		private var _location:String;

		/**
		 * Location or URL
		 * */
		public function get location():String {
			
			if (isAIR) {
				return airInstance.location;
			}
			else if (isBrowser) {
				return browserInstance.location;
			}
			else if (isMobile) {
				return browserInstance.location;
			}
			
			return _location;
		}

		/**
		 * @private
		 * */
		public function set location(value:String):void {
			if (debug) {
				log();
			}
			
			if (isAIR) {
				airInstance.location = value;
			}
			else if (isBrowser) {
				browserInstance.location = value;
			}
			else if (isMobile) {
				browserInstance.location = value;
			}
			_location = value;
		}
		
		/**
		 *  @private
		 */
		override protected function createChildren():void {
			super.createChildren();
			
			
			if (isAIR) {
				
				if (airClass==null) {
					
					if (!ApplicationDomain.currentDomain.hasDefinition(defaultAIRClassName)) {
						var message:String;
						message = "Ace Editor: There is no reference to the class " + defaultAIRClassName +". ";
						message += "Set the airClass property to a reference or include a reference in your application. ";
						message += "See example code on this class.";
						throw new Error(message);
					}
					
					airClass = ApplicationDomain.currentDomain.getDefinition(defaultAIRClassName);
				}
				
				airInstance = new airClass();
				airInstance.addEventListener(FlexEvent.INITIALIZE, initializedHandler, false, 0, true);
				airInstance.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				airInstance.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
				airInstance.addEventListener(Event.HTML_DOM_INITIALIZE, htmlDomInitializeHandler, false, 0, true);
				airInstance.addEventListener(Event.HTML_RENDER, htmlRenderHandler, false, 0, true);
				airInstance.addEventListener(Event.LOCATION_CHANGE, locationChangeHandler, false, 0, true);
				airInstance.addEventListener(Event.HTML_BOUNDS_CHANGE, htmlBoundsChangeHandler, false, 0, true);
				airInstance.addEventListener(Event.SCROLL, htmlScrollHandler, false, 0, true);
				airInstance.addEventListener(UNCAUGHT_SCRIPT_EXCEPTION, uncaughtScriptExceptionHandler, false, 0, true);
				//addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
				addChild(airInstance as DisplayObject);
			}
			else if (isBrowser) {
				
				if (useExternalInterface) {
					var marshallExceptions:Boolean = ExternalInterface.marshallExceptions;
					ExternalInterface.marshallExceptions = true;
					
					if (editorIdentity==null || editorIdentity=="editor") {
						editorIdentity = NameUtil.createUniqueName(this);
					}
					
					var string:String = <xml><![CDATA[
						function(id) {
							var div = document.createElement("div");
							div.id = id;
							div.style.position = "absolute";
							document.body.appendChild(div);
							return true;
						}]]>
						</xml>;
					var created:String;
					created = ExternalInterface.call(string, editorIdentity);
					
					string = <xml><![CDATA[
						function(id) {
							ace.require("ace/ext/language_tools");
							ace.require("ace/ext/beautify");
							ace.require("ace/lib/lang");
							ace.edit(id);
							return true;
						}]]>
						</xml>;
					created = ExternalInterface.call(string, editorIdentity);
					
					if (!scriptAdded) {
						created = ExternalInterface.call(removeReferences);
						scriptAdded = true;
					}
					
					if (created=="true") {
						addEditorById(editorIdentity, this);
						aceEditorFound = true;
						aceFound = true;
						isEditorReady = true;
						callLater(completeHandler, [null]);
					}
					
					ExternalInterface.marshallExceptions = marshallExceptions;
				}
				else {
					if (browserClass==null) {
						browserClass = ApplicationDomain.currentDomain.getDefinition(defaultBrowserClassName);
					}
					
					browserInstance = new browserClass();
					browserInstance.addEventListener(FlexEvent.INITIALIZE, initializedHandler);
					browserInstance.addEventListener(Event.COMPLETE, completeHandler);
					browserInstance.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
					addChild(browserInstance as DisplayObject);
				}
			}
			else if (isMobile) {
				
				if (mobileClass==null) {
					mobileClass = ApplicationDomain.currentDomain.getDefinition(defaultMobileClassName);
				}
				
				mobileInstance = new mobileClass();
				mobileInstance.addEventListener(FlexEvent.INITIALIZE, initializedHandler);
				mobileInstance.addEventListener(Event.COMPLETE, completeHandler);
				mobileInstance.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
				addChild(mobileInstance as DisplayObject);
			}
			
			// listen for events once editor is created
			var functionReference:Function;
			
			for (var eventName:String in deferredEventHandlers) {
				functionReference = deferredEventHandlers[eventName];
				
				addEventListener(eventName, functionReference, false, 0, true);
				//editorEventHandlers[eventName] = null;
				//delete editorEventHandlers[eventName];
			}
		}
		
		/**
		 * Initialize event
		 * 
		 * Step 1. Set the HTML location to the ace.html page
		 * */
		public function initializedHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (isAIR) {
				/*
				if ("domWindow" in airInstance) {
					window = airInstance.domWindow;
				}
				else if ("window" in airInstance) {
					window = airInstance.window;
				}*/
			}
			else if (isBrowser) {
				//ExternalInterface.call("document.insertScript = function() { getWindow = function() { return document.window }}");
				//domWindow = ExternalInterface.call("getWindow()");
				//domWindow = browserInstance.window
			}
			else if (isMobile) {
				//domWindow = mobileInstance.window
			} 
			
			var qualifiedClassName:String;
			var request:URLRequest;
			
			if (loadOnCreationComplete) {
				
				if (isAIR) {
					if (HTMLLoaderLoaded && isHTMLLoader) {
						request = new URLRequest(pathToTemplate);
						airInstance.load(request);
					}
					else {
						airInstance.location = pathToTemplate;
					}
				}
				else if (isBrowser) {
					browserInstance.source = pathToTemplate;
				}
				else if (isMobile) {
					mobileInstance.location = pathToTemplate;
				}
			}
			
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * HTML but renderers 
		 * */
		protected function htmlRenderHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			
			instanceClassName = getQualifiedClassName(airInstance);
			
			if (!HTMLLoaderLoaded && 
				(instanceClassName=="flash.html::HTMLLoader" || 
				instanceClassName=="mx.core::FlexHTMLLoader")) {
				isHTMLLoader = true;
				HTMLLoaderLoaded = true;
				
				initializedHandler(event);
				//completeHandler(event);
				
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		/**
		 * Handles when page containing the ace editor is loaded.
		 * 
		 * Step 2. When the page is loaded then we can get the ace editor instance 
		 * */
		protected function completeHandler(event:Event):void {
			if (debug) {
				log();
			}
			//var isPrimaryApplication:Boolean = SystemManagerGlobals.topLevelSystemManagers[0] == systemManager;
			
			// somehow the editor is getting reloaded on exit of application
			// this throws errors
			if (isAIR && aceFound && ignoreCloseErrors) {
				return;
			}
			
			// browser and desktop compatibility
			if (isAIR) {
				//window = airInstance.domWindow;
				//editorContainer = airInstance.domWindow;
			}
			else if (isBrowser) {
				//domWindow = browserInstance.domWindow;
				//editorContainer = browserInstance.domWindow;
			}
			else if (isMobile) {
				//window = mobileInstance.domWindow;
				//editorContainer = mobileInstance.domWindow;
			}
			else {
				//throw new Error("Where are you running this at?");
			}
			
			if (validateSources) {
				
				if (isBrowser && useExternalInterface) {
					var results:Object;
					
					var string:String = <xml><![CDATA[
					function (id) {
						var element = document.getElementById(id);
						var divFound = element!=null && element.nodeName!=null && element.nodeName.toLowerCase()=="div";
						var editorFound = element!=null && element.env!=null && element.env.editor!=null;
						var aceFound = ace!=null;
						var results = {};
						results.divFound = divFound;
						results.editorFound = editorFound;
						results.aceFound = aceFound;
						return results;
					}
					]]></xml>;
					
					results = ExternalInterface.call(string, editorIdentity);
					
					aceFound = results.aceFound;
					aceEditorFound = results.editorFound;
					aceEditorContainerFound = results.divFound;
				}
				else {
					aceFound = window.ace ? true : false;
				}
				
				try {
					if (isAIR && aceFound) {
						
						// can't seem to catch this error!
						// the following line always throws an error if div is not found:
						// domWindow.ace.edit(id);
						// would have hoped it returned null
						// using old fashioned method
						var element:Object = window.document.getElementById(editorIdentity);
						var localName:String = element ? element.nodeName : null;
						
						aceEditorFound = (element && localName && localName.toLowerCase()=="div");
					}
				}
				catch (e:Error) {
					aceEditorFound = false;
				}
				
				// THIS ERROR APPEARS TO HAPPEN ON APPLICATION CLOSE
				// Error: The ace JavaScript variable was not found. Make sure to copy the directory, 'src-min-noconflict' to your project src directory and include a reference to it in the template page.
				// Not sure what is going on here. Maybe an unload event
				// or an application deactivate event. TODO Add listener for deactivate
				
				// UPDATE: 
				// a new complete event is triggered by the location change to "about:blank"
				// need to check for location change and handle this case
				
				if (!aceFound) {
					errorMessage = "The ace JavaScript variable was not found. Make sure to copy the directory, ";
					errorMessage += "'src-min-noconflict' to your project src directory and include a reference ";
					errorMessage += "to it in the template page.";
					throw new Error(errorMessage);
				}
				else if (!aceEditorFound) {
					errorMessage = "The ace editor div was not found. Make sure the template page ";
					errorMessage += "has a div with an id of '" + editorIdentity + "'.";
					throw new Error(errorMessage);
				}
			}
			
			if (isAIR) {
				createHTMLReferences();
				setEditorProperties();
				commitProperties();
				setValue(text);
				clearSelection();
				addSearchBox();
			}
			else if (isBrowser && useExternalInterface) {
				setEditorProperties();
				commitProperties();
				setValue(text);
				clearSelection();
			}
			
			dispatchEvent(new Event(EDITOR_READY));
		}
		
		
		/**
		 * Creates references we will use to reference the ace editor
		 * */
		private function createHTMLReferences():void {
			if (debug) {
				log();
			}
			
			if (isAIR) {
				pageDocument = window.document;
				pagePlugins = pageDocument.plugins;
				pageScripts = pageDocument.scripts;
				pageStyleSheets = pageDocument.styleSheets;
				
				ace = window.ace;
				languageTools = ace.require("ace/ext/language_tools");
				beautify = ace.require("ace/ext/beautify");
				language = ace.require("ace/lib/lang");
				editor = ace.edit(editorIdentity);
				version	= ace.version;
				element = editor.container;
				//session = editor.getSession();
				selection = session.selection;
				config = ace.config;
				
				// this is a hack because somewhere in ace javascript someone is calling console.log
				// and there is no console in the AIR HTML component dom window
				// however you can create your own and assign it to the console property
				if (console==null) {
					console = {};
					console.log = trace;
					console.error = trace;
				}
				
				if (window.console==null) {
					window.console = console;
					//domWindow.console.log("hello");
					//domWindow.console.error("hello error");
				}
			}
			
			editor.commands.addCommand({
				name: 'save',
				bindKey: {win: "Ctrl-S", mac: "Cmd-S"},
				exec: saveKeyboardHandler});
			
			editor.commands.addCommand({
				name: 'blockComment',
				bindKey: {win: "Ctrl-Shift-c", mac: "Cmd-Shift-C"},
				exec: blockCommentHandler});
			
			// doesnt seem to work - air is catching it. add to component, parent or application
			editor.commands.addCommand({
				name: "find",
				bindKey: {win:"Ctrl-F", mac: "Cmd-F"},
				exec: searchInputHandler});
			
			editor.commands.addCommand({
				name: "search",
				bindKey: {win:"Ctrl-B", mac: "Cmd-B"},
				exec: searchInputHandler});
			
			/*editor.commands.addCommand({
			name: 'find',
			bindKey: {win: "Ctrl-F", "mac": "Cmd-F"},
			exec: findKeyboardHandler});*/
			
			isEditorReady = true;
		}
		
		/**
		 * Sets the ace editor properties. We might want to use
		 * Flex commit properties to handle changes
		 * */
		public function setEditorProperties():void {
			invalidateProperties();
			// set values from editor
			//var options:Object = editor.getOptions();
			
			autoCompleterPopUpSizeChanged = true;
			enableBehaviorsChanged = true;
			enableFindChanged = true;
			enableReplaceChanged = true;
			enableSnippetsChanged = true;
			enableBasicAutoCompletionChanged = true;
			enableLiveAutoCompletionChanged = true;
			enableWrapBehaviorsChanged = true;
			fontSizeChanged = true;
			highlightActiveLineChanged = true;
			highlightGutterLineChanged = true;
			highlightSelectedWordChanged = true;
			isReadOnlyChanged = true;
			keyBindingChanged = true;
			listenForChangesChanged = false;
			modeChanged = true;
			marginChanged = true;
			scrollSpeedChanged = true;
			showInvisiblesChanged = true;
			showIndentGuidesChanged = true;
			showFoldWidgetsChanged = true;
			showPrintMarginsChanged = true;
			showGutterChanged = true;
			showCursorChanged = true;
			showLineNumbersChanged = true;
			tabSizeChanged = true;
			textChanged = true;
			themeChanged = true;
			useSoftTabsChanged = true;
			useWordWrapChanged = true;
			useWorkerChanged = true;
		}
		
		protected function creationCompleteHandler(event:FlexEvent):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		protected function htmlDomInitializeHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		/**
		 *  @private
		 */
		protected function htmlBoundsChangeHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		protected function locationChangeHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		protected function uncaughtScriptExceptionHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 *  @private
		 */
		protected function htmlScrollHandler(event:Event):void {
			if (debug) {
				log();
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		/**
		 *  @private
		 */
		protected function mouseWheelHandler(event:MouseEvent):void {
			if (debug) {
				log();
			}
			
			if (isAIR && airInstance is EventDispatcher) {
				//isDispatchingMouseWheel = true;
				//airInstance.dispatchEvent(event);
				//isDispatchingMouseWheel = false;
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		public var loadOnCreationComplete:Boolean = true;
		
		public static const INSERT_ACTION:String = "insert";
		public static const INSERT_TEXT_ACTION:String = "insertText";
		public static const INSERT_LINES_ACTION:String = "insertLines";
		public static const REMOVE_LINES_ACTION:String = "removeLines";
		
		public static const SESSION_CHANGE:String = "sessionChange";
		public static const SELECTION_CHANGE:String = "selectionChange";
		public static const CURSOR_CHANGE:String = "cursorChange";
		public static const MOUSE_MOVE_OVER_EDITOR:String = "mouseMoveOverEditor";
		
		public static const EDITOR_READY:String = "editorReady";
		public static const EDITOR_CHANGE:String = "change";
		public static const SAVE:String = "save";
		
		// ACE uses event names such as changeSession instead of sessionChange
		// this is different than ActionScript3 conventions which is sessionChange
		public static const SESSION_CHANGE_SESSION:String = "changeSession";
		public static const SESSION_CHANGE_SELECTION:String = "changeSelection";
		public static const SESSION_CHANGE_CURSOR:String = "changeCursor";
		public static const SESSION_MOUSE_MOVE:String = "mousemove";
		
		public static const BLUR:String = "blur";
		public static const FOCUS:String = "focus";
		
		private var callBackAdded:Boolean;
		
		/**
		 * Path to HTML page that has the Ace editor in it 
		 * */
		public var pathToTemplate:String = "app:/ace.html";
		
		/**
		 * Reference to the HTML document
		 * */
		public var pageDocument:Object;
		
		/**
		 * Reference to ace editor config
		 * */
		public var config:Object;
		
		/**
		 * Reference to the HTML document
		 * */
		public var pagePlugins:Object;
		
		/**
		 * Reference to the HTML document
		 * */
		public var pageScripts:Object;
		
		/**
		 * Reference to the ace editor instance
		 * */
		public var editor:Object;
		
		/**
		 * If the editor is not created yet we store event listeners until it is
		 * and add them later
		 * */
		public var deferredEventHandlers:Object = {};
		public var eventHandlers:Object = {};
		
		/**
		 * Reference to the ace editor container element instance
		 * */
		public var element:Object;
		
		private var _session:Object;

		/**
		 * Reference to the ace session instance. 
		 * Not sure if this changes throughout the life of the editor. 
		 * */
		public function get session():Object {
			
			if (editor) {
				return editor.getSession();
			}
			
			return _session;
		}

		/**
		 * @private
		 */
		public function set session(value:Object):void
		{
			_session = value;
		}

		
		/**
		 * Reference to the ace selection instance
		 * Not sure if this changes throughout the life of the editor. 
		 * */
		public var selection:Object;
		
		/**
		 * Reference to the ace editor manager
		 * */
		public var ace:Object;
		
		/**
		 * Reference to the page stylesheets
		 * */
		public var pageStyleSheets:Object;
		
		/**
		 * Reference to the ace language tools
		 * */
		public var languageTools:Object;
		
		private var _window:Object;
		public var instanceClassName:String;
		
		/**
		 * Reference to the dom window
		 * */
		public function get window():Object {
			
			if (_window) {
				return _window;
			}
			else if (isAIR) {
				
				instanceClassName = getQualifiedClassName(airInstance);
				
				if (!HTMLLoaderLoaded && 
					instanceClassName=="flash.html::HTMLLoader" || 
					instanceClassName=="mx.core::FlexHTMLLoader") {
					
					_window = airInstance.window;
				}
				else {
					_window = airInstance.domWindow;
				}
				
				return _window;
			}
			else if (isBrowser) {
				
			}
			
			return _window;
		}

		/**
		 * @private
		 */
		public function set window(value:Object):void {
			_window = value;
		}

		/**
		 * Reference to the ace beautify extension
		 * */
		public var beautify:Object;
		
		/**
		 * Reference to the ace language extension
		 * */
		public var language:Object;
		
		/**
		 * Identity of editor on the page. <br/><br/>
		 * 
		 * You should have a div on your page with an identity like this:
 <pre>
 &lt;div id='editor'>&lt;/div>
 </pre>
		 * */
		public var editorIdentity:String = "editor";
		
		private var _theme:String = "ace/theme/crimson_editor";
		
		/**
		 * Theme of the editor as a path to the theme files.
		 * Default is "ace/theme/crimson_editor"
		 * */
		public function get theme():String {
			return _theme;
		}
		
		/**
		 * @private
		 */
		public function set theme(value:String):void {
			if (_theme!=value) themeChanged = true;
			_theme = value;
			invalidateProperties();
		}
		
		private var _showInvisibles:Boolean;
		
		public function get showInvisibles():Boolean {
			return _showInvisibles;
		}
		
		public function set showInvisibles(value:Boolean):void {
			if (_showInvisibles!=value) showInvisiblesChanged = true;
			_showInvisibles = value;
			invalidateProperties();
		}
		
		private var _enableBehaviors:Boolean;
		
		public function get enableBehaviors():Boolean {
			return _enableBehaviors;
		}
		
		/**
		 * Specifies whether to use behaviors or not. 
		 * "Behaviors" in this case is the auto-pairing of special characters, 
		 * like quotation marks, parenthesis, or brackets.
		 * */
		public function set enableBehaviors(value:Boolean):void {
			if (_enableBehaviors!=value) enableBehaviorsChanged = true;
			_enableBehaviors = value;
			invalidateProperties();
		}
		
		
		public var _mode:String = "ace/mode/xml";
		
		/**
		 * Mode of the editor as a path to the mode files.
		 * Default is "ace/mode/html"
		 * */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:String):void {
			if (_mode!=value) modeChanged = true;
			_mode = value;
			invalidateProperties();
		}
		
		private var _scrollSpeed:Number = 2;
		
		/**
		 * Sets scroll speed. Default is 2.
		 * */
		public function get scrollSpeed():Number {
			return _scrollSpeed;
		}

		public function set scrollSpeed(value:Number):void {
			if (_scrollSpeed!=value) scrollSpeedChanged = true;
			_scrollSpeed = value;
			invalidateProperties();
		}

		
		private var _showFoldWidgets:Boolean = true;
		
		/**
		 * Shows fold widgeths if true.
		 * Default is true.
		 * */
		public function get showFoldWidgets():Boolean {
			return _showFoldWidgets;
		}
		
		/**
		 * @private
		 */
		public function set showFoldWidgets(value:Boolean):void {
			if (_showFoldWidgets!=value) showFoldWidgetsChanged = true;
			_showFoldWidgets = value;
			invalidateProperties();
		}
		
		private var _showPrintMargin:Boolean;
		
		/**
		 * Show.
		 * Default is true.
		 * */
		public function get showPrintMargin():Boolean {
			return _showPrintMargin;
		}
		
		/**
		 * @private
		 */
		public function set showPrintMargin(value:Boolean):void {
			if (_showPrintMargin!=value) showPrintMarginsChanged = true;
			_showPrintMargin = value;
			invalidateProperties();
		}
		
		/**
		 * Shows the gutter if true
		 * Default is true.
		 * */
		public function get showGutter():Boolean {
			return _showGutter;
		}
		
		/**
		 * @private
		 */
		public function set showGutter(value:Boolean):void {
			if (_showGutter!=value) showGutterChanged = true;
			_showGutter = value;
			invalidateProperties();
		}
		private var _showGutter:Boolean = true;
		
		/**
		 * Shows line numbers if true
		 * Default is true.
		 * */
		public function get showLineNumbers():Boolean {
			return _showLineNumbers;
		}
		
		/**
		 * @private
		 */
		public function set showLineNumbers(value:Boolean):void {
			if (_showLineNumbers!=value) showLineNumbersChanged = true;
			_showLineNumbers = value;
			invalidateProperties();
		}
		private var _showLineNumbers:Boolean = true;
		

		public function get showCursor():Boolean
		{
			return _showCursor;
		}

		public function set showCursor(value:Boolean):void {
			if (_showCursor!=value) showCursorChanged = true;
			_showCursor = value;
			invalidateProperties();
		}
		private var _showCursor:Boolean = true;

		
		private var _useWordWrap:Boolean;
		
		/**
		 * Uses word wrap if true
		 * Default is false.
		 * */
		public function get useWordWrap():Boolean {
			return _useWordWrap;
		}
		
		/**
		 * @private
		 */
		public function set useWordWrap(value:Boolean):void {
			if (_useWordWrap!=value) useWordWrapChanged = true;
			_useWordWrap = value;
			invalidateProperties();
		}
		
		private var _highlightActiveLine:Boolean;
		
		public function get highlightActiveLine():Boolean {
			return _highlightActiveLine;
		}
		
		public function set highlightActiveLine(value:Boolean):void {
			if (_highlightActiveLine!=value) {
				highlightActiveLineChanged = true;
				invalidateProperties();
			}
			_highlightActiveLine = value;
		}
		
		private var _highlightGutterLine:Boolean;
		
		public function get highlightGutterLine():Boolean {
			return _highlightGutterLine;
		}
		
		public function set highlightGutterLine(value:Boolean):void {
			if (_highlightGutterLine!=value) {
				highlightGutterLineChanged = true;
				invalidateProperties();
			}
			_highlightGutterLine = value;
		}
		
		private var _highlightSelectedWord:Boolean;
		
		public function get highlightSelectedWord():Boolean {
			return _highlightSelectedWord;
		}
		
		public function set highlightSelectedWord(value:Boolean):void {
			if (_highlightSelectedWord!=value) {
				highlightSelectedWordChanged = true;
				invalidateProperties();
			}
			_highlightSelectedWord = value;
		}
		
		private var _tabSize:int = 4;
		
		public function get tabSize():int {
			return _tabSize;
		}
		
		public function set tabSize(value:int):void {
			if (_tabSize!=value) {
				tabSizeChanged = true;
				invalidateProperties();
			}
			_tabSize = value;
		}
		
		private var _useSoftTabs:Boolean;
		
		public function get useSoftTabs():Boolean {
			return _useSoftTabs;
		}
		
		public function set useSoftTabs(value:Boolean):void {
			if (_useSoftTabs!=value) {
				useSoftTabsChanged = true;
				invalidateProperties();
			}
			_useSoftTabs = value;
		}
		
		private var _useWorker:Boolean;
		
		public function get useWorker():Boolean {
			return _useWorker;
		}
		
		public function set useWorker(value:Boolean):void {
			if (_useWorker!=value) {
				useWorkerChanged = true;
				invalidateProperties();
			}
			_useWorker = value;
		}
		
		private var _enableWrapBehaviors:Boolean;
		
		public function get enableWrapBehaviors():Boolean {
			return _enableWrapBehaviors;
		}
		
		/**
		 * Specifies whether to automatically wrap the selection with 
		 * characters like brackets when the character is typed in.
		 * For example, select a word and then press the open curly brace key. 
		 * The selection would be enclosed with open and close curly braces
		 * with this option enabled. 
		 * 
		 * Before: "text". After: "{test}".
		 * */
		public function set enableWrapBehaviors(value:Boolean):void {
			if (_enableWrapBehaviors!=value) {
				enableWrapBehaviorsChanged = true;
				invalidateProperties();
			}
			_enableWrapBehaviors = value;
		}
		
		private var _enableBasicAutoCompletion:Boolean = true;
		
		public function get enableBasicAutoCompletion():Boolean {
			return _enableBasicAutoCompletion;
		}
		
		public function set enableBasicAutoCompletion(value:Boolean):void {
			if (_enableBasicAutoCompletion!=value) {
				enableBasicAutoCompletionChanged = true;
				invalidateProperties();
			}
			_enableBasicAutoCompletion = value;
		}
		
		private var _enableSnippets:Boolean;
		
		public function get enableSnippets():Boolean {
			return _enableSnippets;
		}
		
		public function set enableSnippets(value:Boolean):void {
			if (_enableSnippets!=value) {
				enableSnippetsChanged = true;
				invalidateProperties();
			}
			_enableSnippets = value;
		}
		
		private var _enableLiveAutoCompletion:Boolean;
		
		public function get enableLiveAutoCompletion():Boolean {
			return _enableLiveAutoCompletion;
		}
		
		public function set enableLiveAutoCompletion(value:Boolean):void {
			if (_enableLiveAutoCompletion!=value) {
				enableLiveAutoCompletionChanged = true;
				invalidateProperties();
			}
			_enableLiveAutoCompletion = value;
		}
		
		private var _keyBinding:String;
		
		public function get keyBinding():String {
			return _keyBinding;
		}
		
		public function set keyBinding(value:String):void {
			if (_keyBinding!=value) {
				keyBindingChanged = true;
				invalidateProperties();
			}
			_keyBinding = value;
		}
		
		/**
		 * Get first visible row
		 * */
		public function getFirstVisibleRow():int {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, select, expand) {
					var editor = ace.edit(id);
					return editor.getFirstVisibleRow();
				}
				]]></xml>;
				var results:int = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.getFirstVisibleRow();
			}
			
		}
		
		/**
		 * Get last visible row
		 * */
		public function getLastVisibleRow():int {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getLastVisibleRow();
				}
				]]></xml>;
				var results:int = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.getLastVisibleRow();
			}
			
		}
		
		/**
		 * Gets editor options
		 * */
		public function getOptions():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getOptions();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.getOptions();
			}
			
		}
		
		/**
		 * Get selection 
		 * */
		public function getSelection():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getSelection();
				}
				]]></xml>;
				var results:Object  = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.getSelection();
			}
			
		}
		
		/**
		 * Get selected text
		 * */
		public function getTextRange():String {
			var text:String;
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					var text = editor.session.getTextRange(editor.getSelectionRange());
					return text;
				}
				]]></xml>;
				text = ExternalInterface.call(string, editorIdentity);
			}
			else {
				text = editor.session.getTextRange(editor.getSelectionRange());
			}
			
			return text;
		}
		
		/**
		 * Get editor text
		 * */
		public function getValue():String {
			var text:String;
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getValue();
				}
				]]></xml>;
				text = ExternalInterface.call(string, editorIdentity);
			}
			else {
				text = editor.text;
			}
			
			return text;
		}
		
		/**
		 * Get editor text
		 * @see #getValue()
		 * */
		public function getText():String {
			var text:String = getValue();
			
			return text;
		}
		
		/**
		 * Get selection range
		 * */
		public function getSelectionRange():Object {
			var selection:Object;
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getSelectionRange();
				}
				]]></xml>;
				selection = ExternalInterface.call(string, editorIdentity);
			}
			else {
				selection = editor.getSelectionRange();
			}
			
			return selection;
		}
		
		/**
		 * Go to line 
		 * */
		public function gotoLine(line:int, column:int = 0, animate:Boolean = true):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, line, column, animate) {
					var editor = ace.edit(id);
					editor.gotoLine(line, column, animate);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, line, column, animate);
			}
			else {
				editor.gotoLine(line, column, animate);
			}
			
		}
		
		/**
		 * Shifts the document to wherever "page down" is, as well as moving the cursor position.
		 * */
		public function gotoPageDown():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.gotoPageDown();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.gotoPageDown();
			}
		}
		
		/**
		 * Shifts the document to wherever "page up" is, as well as moving the cursor position.
		 * */
		public function gotoPageUp():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.gotoPageUp();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.gotoPageUp();
			}
			
		}
		
		/**
		 * Indents the current line
		 * */
		public function indent():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.indent();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.indent();
			}
			
		}
		
		/**
		 * Returns true if the text input is currently focused.
		 * Not sure if this is working.
		 * */
		public function isFocused():Boolean {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.isFocused();
				}
				]]></xml>;
				var results:Boolean = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.isFocused();
			}
			
		}
		
		/**
		 * Indicates if the entire row is fully visible
		 * */
		public function isRowFullyVisible(row:uint):Boolean {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					return editor.isRowFullyVisible(row);
				}
				]]></xml>;
				var results:Boolean = ExternalInterface.call(string, editorIdentity, row);
				return results;
			}
			else {
				return editor.isRowFullyVisible(row);
			}
			
		}
		
		/**
		 * Is row visible
		 * */
		public function isRowVisible(row:uint):Boolean {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					return editor.isRowVisible(row);
				}
				]]></xml>;
				var results:Boolean = ExternalInterface.call(string, editorIdentity, row);
				return results;
			}
			else {
				return editor.isRowVisible(row);
			}
			
		}
		
		/**
		 * Jumps to the matching brace or tag. 
		 * */
		public function jumpToMatching(select:Boolean = true, expand:Boolean = true):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, select, expand) {
					var editor = ace.edit(id);
					editor.jumpToMatching(select, expand)
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, select, expand);
			}
			else {
				editor.jumpToMatching(select, expand);
			}
		}
		
		/**
		 * If the character before the cursor is a number, this functions changes its value by the 
		 * amount specified
		 * */
		public function modifyNumber(amount:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, amount) {
					var editor = ace.edit(id);
					editor.modifyNumber(amount);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, amount);
			}
			else {
				editor.modifyNumber(amount);
			}
			
		}
		
		/**
		 * Shifts all the selected lines down one row.
		 * */
		public function moveLinesDown():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.moveLinesDown();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.moveLinesDown();
			}
		}
		
		/**
		 * Shifts all the selected lines up one row.
		 * */
		public function moveLinesUp():void { 
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.moveLinesUp();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.moveLinesUp();
			}
		}
		
		/**
		 * Moves a range of text from the specified range to the specified position. 
		 * */
		public function moveText(range:Object, toPosition:Object, copy:Boolean = false):void { 
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range, toPosition, copy) {
					var editor = ace.edit(id);
					editor.moveText(range, toPosition, copy);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, range, toPosition, copy);
			}
			else {
				editor.moveText(range, toPosition, copy);
			}
		}
		
		/**
		 * Moves the cursor down a specified number of times.
		 * */
		public function navigateDown(count:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, count) {
					var editor = ace.edit(id);
					editor.navigateDown(count);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, count);
			}
			else {
				editor.navigateDown(count);
			}
		}
		
		/**
		 * Moves the cursor to the end of the current file. 
		 * This deselects the current selection.
		 * */
		public function navigateFileEnd():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateFileEnd();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateFileEnd();
			}
		}
		
		/**
		 * Moves the cursor to the start of the current file. 
		 * This deselects the current selection.
		 * */
		public function navigateFileStart():void {

			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateFileStart();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateFileStart();
			}
		}
		
		/**
		 * Moves the cursor left a specified number of times. 
		 * */
		public function navigateLeft(count:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, count) {
					var editor = ace.edit(id);
					editor.navigateLeft(count);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, count);
			}
			else {
				editor.navigateLeft(count);
			}
		}
		
		/**
		 * 
		 * */
		public function navigateLineEnd():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateLineEnd();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateLineEnd();
			}
		}
		
		/**
		 * 
		 * */
		public function navigateLineStart():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateLineStart();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateLineStart();
			}
		}
		
		/**
		 * Moves the cursor right a specified number of times. 
		 * */
		public function navigateRight(count:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, count) {
					var editor = ace.edit(id);
					editor.navigateRight(count);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, count);
			}
			else {
				editor.navigateRight(count);
			}
		}
		
		/**
		 * Moves the cursor to the specified row and column.
		 * */
		public function navigateTo(row:int, column:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					editor.navigateTo(row, column);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, row, column);
			}
			else {
				editor.navigateTo(row, column);
			}
		}
		
		/**
		 * Moves the cursor up a specified number of times. 
		 * */
		public function navigateUp(count:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, count) {
					var editor = ace.edit(id);
					editor.navigateUp(count);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, count);
			}
			else {
				editor.navigateUp(count);
			}
		}
		
		/**
		 * 
		 * */
		public function navigateWordLeft():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateWordLeft();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateWordLeft();
			}
		}
		
		/**
		 * 
		 * */
		public function navigateWordRight():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.navigateWordRight();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.navigateWordRight();
			}
		}
		
		/**
		 * Scrolls the document to wherever "page down" is, without changing the cursor position.
		 * */
		public function scrollPageDown():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.scrollPageDown();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.scrollPageDown();
			}
		}
		
		/**
		 * Scrolls the document to wherever "page up" is, without changing the cursor position.
		 * */
		public function scrollPageUp():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.scrollPageUp();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.scrollPageUp();
			}
		}
		
		/**
		 * Scrolls to a line. If center is true, it puts the line in middle of screen (or attempts to).
		 * */
		public function scrollToLine(line:int, center:Boolean = false, animate:Boolean = true, callBack:Function = null):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, line, center, animate, callBack) {
					var editor = ace.edit(id);
					editor.scrollToLine(line, center, animate, callBack);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, line, center, animate, callBack);
			}
			else {
				editor.scrollToLine(line, center, animate, callBack);
			}
		}
		
		/**
		 * Scrolls to a specific row
		 * */
		public function scrollToRow(row:Object = null):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					editor.scrollToRow(row);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, row);
			}
			else {
				editor.scrollToRow(row);
			}
		}
		
		/**
		 * Scrolls to the last row
		 * */
		public function scrollToEnd():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					var lastRow = editor.session.getLength();
					editor.scrollToRow(lastRow);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				var lastRow:int = editor.session.getLength();
				editor.scrollToRow(lastRow);
			}
		}
		
		/**
		 * Adds an event listener to the editor
		 * */
		public function on(name:String, handler:Function, dispatcher:String = null, functionValue:String = null):void {
			
			if (isBrowser && useExternalInterface) {
				var callbackName:String;
				var results:Object;
				var string:String;
				
				if (dispatcher==null) {
					dispatcher = EDITOR;
				}
				
				callbackName = editorIdentity + "_" + name;
				ExternalInterface.addCallback(callbackName, handler);
				
				if (functionValue) {
					string = functionValue;
				}
				else {
					// if the application has issues it's because you are trying to pass
					// back an object with too many cyclic references
					// pass back simple objects
					string = <xml><![CDATA[
					function (id, objectId, dispatcherType, eventName, callbackName) {
						var application = this[objectId];
						var editor = ace.edit(id);
						var dispatcher;
	
						if (dispatcherType=="editor") dispatcher = editor;
						else if (dispatcherType=="session") dispatcher = editor.session; 
						else if (dispatcherType=="selection") dispatcher = editor.session.selection;
	
						if (application.methodHandlers==null) { application.methodHandlers = {}; }
	
						application.methodHandlers[callbackName] = function(event, instance) {
							//console.log(event);

							// only return objects one level deep to prevent recursion
						    for (var key in event) {
						      	if (event.hasOwnProperty(key) && (typeof key == 'object')) {
									for (var subkey in key) {
										if (key.hasOwnProperty(subkey) && (typeof subkey == 'object')) {
											event[key][subkey] = null;
										}
						        	}
						    	}
						    }

							application[callbackName](event, instance.container.id);
						}
						dispatcher.on(eventName, application.methodHandlers[callbackName]);
						return true;
					}
					]]></xml>;
				}
				
				results = ExternalInterface.call(string, editorIdentity, ExternalInterface.objectID, dispatcher, name, callbackName);
			}
			else {
				editor.on(name, handler);
			}
		}
		
		/**
		 * Removes event listener to the editor
		 * */
		public function off(name:String, handler:Function, dispatcher:String = "editor", functionValue:String = null):void {
			
			if (isBrowser && useExternalInterface) {
				
				var string:String = <xml><![CDATA[
				function (id, name, handler) {
					var editor = ace.edit(id);
					editor.off(name, handler);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, name, handler);
			}
			else {
				editor.off(name, handler);
			}
		}
		
		/**
		 * Adds an event listener to the editor for one occurance of an event
		 * */
		public function once(name:String, handler:Function):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, name, handler) {
					var editor = ace.edit(id);
					editor.once(name, handler);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, name, handler);
			}
			else {
				editor.once(name, handler);
			}
		}
		
		/**
		 * Redos the last operation 
		 * */
		public function redo():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.session.getUndoManager().redo();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.session.getUndoManager().redo();
			}
		}
		
		/**
		 * Undo the last operation
		 * */
		public function undo():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.session.getUndoManager().undo();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.session.getUndoManager().undo();
			}
		}
		
		/**
		 * Indents all the rows, from the start row to the end row (inclusive)
		 * by prefixing each row with the token in indentString.
		 * */
		public function indentRows(start:int, end:int, indentString:String = null):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, start, end, indentString) {
					var editor = ace.edit(id);
					editor.session.indentRows(start, end, indentString);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, start, end, indentString);
			}
			else {
				editor.session.indentRows(start, end, indentString);
			}
		}
		
		/**
		 * Outdents rows. Object containing start and end row numbers.
		 * */
		public function outdentRows(range:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range) {
					var editor = ace.edit(id);
					editor.session.outdentRows(range);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, range);
			}
			else {
				editor.session.outdentRows(range);
			}
		}
		
		/**
		 * Returns true if the character at the position is a soft tab.
		 * */
		public function isTabStop(position:Object):Boolean {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, position) {
					var editor = ace.edit(id);
					return editor.session.isTabStop(position);
				}
				]]></xml>;
				var results:Boolean = ExternalInterface.call(string, editorIdentity, position);
				return results;
			}
			else {
				return session.isTabStop(position);
			}
		}
		
		/**
		 * Removes the range from the document
		 * */
		public function remove(range:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range) {
					var editor = ace.edit(id);
					editor.session.remove(range);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, range);
			}
			else {
				editor.session.remove(range);
			}
		}
		
		/**
		 * Removes marker. Removes the marker with the specified ID. 
		 * If this marker was in front, the 'changeFrontMarker' event is emitted. 
		 * If the marker was in the back, the 'changeBackMarker' event is emitted.
		 * */
		public function removeMarker(markerId:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, markerId) {
					var editor = ace.edit(id);
					editor.session.removeMarker(markerId);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, markerId);
			}
			else {
				editor.session.removeMarker(markerId);
			}
		}
		
		/**
		 * Removes CSS className from the row.
		 * */
		public function removeGutterDecoration(row:int, cssClassName:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, cssClassName) {
					var editor = ace.edit(id);
					editor.session.removeGutterDecoration(row, cssClassName);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, row, cssClassName);
			}
			else {
				editor.session.removeGutterDecoration(row, cssClassName);
			}
		}
		
		/**
		 * Performs a replace on a previous call to find(). <br/><br/>
		 * 
		 * To perform a replace: 
		 <pre>
		 ace.find("needle");
		 ace.replace("bar");
		 </pre>
		 *
		 * @see #find()
		 * @see #replaceAll()
		 * */
		public function replace(value:String = ""):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.replace(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.replace(value);
			}
		}
		
		/**
		 * Performs a replace all occurances on a previous call to find(). <br/><br/>
		 * 
		 * To perform a replace: 
		 <pre>
		 ace.find("needle");
		 ace.replaceAll("bar");
		 </pre>
		 *
		 * @see #replace()
		 * @see #find()
		 * */
		public function replaceAll(value:String = ""):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.replaceAll(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.replaceAll(value);
			}
		}
		
		/**
		 * Ace resizes itself on window events. If you resize the editor 
		 * div in another manner use may need to call resize().
		 * */
		public function resize():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.resize();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.resize();
			}
		}
		
		/**
		 * Reveals the range
		 * */
		public function revealRange(range:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range) {
					var editor = ace.edit(id);
					editor.revealRange(range);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, range);
			}
			else {
				editor.revealRange(range);
			}
		}
		
		/**
		 * Selects all the text in the document
		 * */
		public function selectAll():void{
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.selectAll();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.selectAll();
			}
		}
		
		public function selectMore():void{};
		public function selectMoreLines():void{};
		public function selectPageDown():void{};
		public function selectPageUp():void{};
		
		/**
		 * Set the highlight of the gutter line
		 * */
		public function setHighlightGutterLine(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setHighlightGutterLine(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setHighlightGutterLine(value);
			}
			
			_highlightGutterLine = value;
		}
		
		/**
		 * Set the tab size
		 * */
		public function setTabSize(value:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.session.setTabSize(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				session.setTabSize(value);
			}
			
			_tabSize = value;
		}
		
		/**
		 * Set use soft tabs 
		 * */
		public function setUseSoftTabs(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.session.setUseSoftTabs(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				session.setUseSoftTabs(value);
			}
			
			_useSoftTabs = value;
		}
		
		/**
		 * Set use worker
		 * */
		public function setUseWorker(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.getSession().setUseWorker(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.getSession().setUseWorker(value);
			}
			
			_useWorker = value;
		}
		
		/**
		 * Set enableBehaviors
		 * */
		public function setBehavioursEnabled(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setBehavioursEnabled(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setBehavioursEnabled(value);
			}
			
			_enableBehaviors = value;
		}
		
		/**
		 * Set wrapBehaviors
		 * */
		public function setWrapBehavioursEnabled(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setWrapBehavioursEnabled(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setWrapBehavioursEnabled(value);
			}
			
			_enableWrapBehaviors = value;
		}
		
		/**
		 * Set scroll speed
		 * */
		public function setScrollSpeed(value:Number):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setScrollSpeed(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setScrollSpeed(value);
			}
			
			_scrollSpeed = value;
		}
		
		/**
		 * Set the highlight of the selected word
		 * */
		public function setHighlightSelectedWord(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setHighlightSelectedWord(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setHighlightSelectedWord(value);
			}
			
			_highlightSelectedWord = value;
		}
		
		/**
		 * Set the mode of the editor
		 * @see #mode
		 * */
		public function setMode(value:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.getSession().setMode(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				session.setMode(value);
			}
			
			_mode = value;
		}
		
		/**
		 * Set the show fold widgets on the editor
		 * @see #showFoldWidgets
		 * */
		public function setShowFoldWidgets(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setShowFoldWidgets(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setShowFoldWidgets(value);
			}
			
			_showFoldWidgets = value;
		}
		
		/**
		 * Set the show gutter on the editor
		 * @see #showGutter
		 * */
		public function setShowGutter(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.renderer.setShowGutter(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.renderer.setShowGutter(value);
			}
			
			_showGutter = value;
		}
		
		/**
		 * Set the show line numbers on the editor
		 * @see #showLineNumbers
		 * */
		public function setShowLineNumbers(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.renderer.setOption("showLineNumbers", value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.renderer.setOption("showLineNumbers", value);
			}
			
			_showLineNumbers = value;
		}
		
		/**
		 * Set the show cursor on the editor
		 * @see #showCursor
		 * */
		public function setShowCursor(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					var cursorDisplay = value ? "visible" : "none";
					editor.renderer.$cursorLayer.element.style.display = cursorDisplay;
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				var cursorDisplay:String = value ? "visible" : "none";
				editor.renderer.$cursorLayer.element.style.display = cursorDisplay;
			}
			
			_showCursor = value;
		}
		
		/**
		 * Set the show cursor on the editor
		 * @see #useWordWrap
		 * */
		public function setUseWrapMode(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.getSession().setUseWrapMode(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.getSession().setUseWrapMode(value);
			}
			
			_useWordWrap = value;
		}
		
		/**
		 * Set the editor to read only
		 * @see #isReadOnly
		 * */
		public function setReadOnly(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setReadOnly(value);
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setReadOnly(value);
			}
			
			_isReadOnly = value;
		}
		
		/**
		 * Set the editor to show invisibles
		 * @see #showInvisibles
		 * */
		public function setShowInvisibles(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setShowInvisibles(value);
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setShowInvisibles(value);
			}
			
			_showInvisibles = value;
		}
		
		/**
		 * Set the editor to font size
		 * @see #fontSize
		 * */
		public function setFontSize(value:Number):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setFontSize(value);
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setFontSize(value);
			}
			
			setStyle("fontSize", value);
		}
		
		/**
		 * Set the editor to showIndentGuides
		 * @see #showIndentGuides
		 * */
		public function setDisplayIndentGuides(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setDisplayIndentGuides(value);
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				
				editor.setDisplayIndentGuides(value);
			}
			
			_showIndentGuides = value;
		}
		
		/**
		 * Set the editor to enable find command
		 * @see #enableFind
		 * */
		public function setEnableFindCommand(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);

					if (value) {
						editor.commands.removeCommand("find");
					}
					else {
						editor.commands.addCommand("find");
					}
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				if (value) {
					editor.commands.removeCommand(FIND);
				}
				else {
					editor.commands.addCommand(FIND);
				}
			}
			
			_enableFind = value;
		}
		
		/**
		 * Set the editor to enable replace command
		 * @see #enableReplace
		 * */
		public function setEnableReplaceCommand(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);

					if (value) {
						editor.commands.removeCommand("replace");
					}
					else {
						editor.commands.addCommand("replace");
					}
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				if (value) {
					editor.commands.removeCommand(REPLACE);
				}
				else {
					editor.commands.addCommand(REPLACE);
				}
			}
			
			_enableReplace = value;
		}
		
		/**
		 * Set the editor highlightActiveLine
		 * @see #highlightActiveLine
		 * */
		public function setHighlightActiveLine(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setHighlightActiveLine(value);
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setHighlightActiveLine(value);
			}
			
			_highlightActiveLine = value;
		}
		
		/**
		 * Set the editor enableBasicAutoCompletion
		 * @see #enableBasicAutoCompletion
		 * */
		public function setEnableBasicAutoCompletion(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setOption("enableBasicAutocompletion", value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setOption("enableBasicAutocompletion", value);
			}
			
			_enableBasicAutoCompletion = value;
		}
		
		/**
		 * Set the editor enableLiveAutoCompletion
		 * @see #enableLiveAutoCompletion
		 * */
		public function setEnableLiveAutocompletion(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setOption("enableLiveAutocompletion", value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setOption("enableLiveAutocompletion", value);
			}
			
			_enableLiveAutoCompletion = value;
		}
		
		/**
		 * Set the editor auto complete pop up size
		 * @see #autoCompleterPopUpSize
		 * */
		public function setAutoCompletePopUpSize(value:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					var popup;
					
					if (editor.completer) {
						popup = editor.completer.popup;
						
						if (popup) {
							popup.container.style.width = autoCompleterPopUpSize + "px";
							popup.resize();
						}
					}
					return true;
				}	
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				var popup:Object;
				
				if (editor.completer) {
					popup = editor.completer.popup;
					
					if (popup) {
						popup.container.style.width = value + "px";
						popup.resize();
					}
				}
			}
			
			_autoCompleterPopUpSize = value;
		}
		
		/**
		 * Set the show print margin in the editor
		 * @see #showPrintMargin
		 * */
		public function setShowPrintMargin(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setShowPrintMargin(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setShowPrintMargin(value);
			}
			
			_showPrintMargin = value;
		}
		
		/**
		 * Set the keyboard handler of the editor
		 * @see #keyBinding
		 * */
		public function setKeyboardHandler(value:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setKeyboardHandler(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setKeyboardHandler(value);
			}
			
			_keyBinding = value;
		}
		
		/**
		 * Set theme of the editor
		 * @see #theme
		 * */
		public function setTheme(value:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setTheme(value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setTheme(value);
			}
			
			_theme = value;
		}
		
		/**
		 * Set margin of the editor
		 * @see #margin
		 * */
		public function setMargin(value:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.container.style.margin = value;
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.container.style.margin = value;
			}
			
			_margin = value;
		}
		
		/**
		 * Set enable snippets of the editor
		 * @see #enableSnippets
		 * */
		public function setEnableSnippets(value:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.setOption("enableSnippets", value);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
			else {
				editor.setOption("enableSnippets", value);
			}
			
			_enableSnippets = value;
		}
		
		private var _isReadOnly:Boolean;
		
		/**
		 * Uses word wrap if true
		 * Default is true.
		 * */
		public function get isReadOnly():Boolean {
			return _isReadOnly;
		}
		
		/**
		 * @private
		 */
		public function set isReadOnly(value:Boolean):void {
			if (_isReadOnly!=value) isReadOnlyChanged = true;
			_isReadOnly = value;
			invalidateProperties();
		}
		
		
		private var _enableFind:Boolean = true;
		
		/**
		 * Enable find
		 * Default is true.
		 * */
		public function get enableFind():Boolean {
			return _enableFind;
		}
		
		/**
		 * @private
		 */
		public function set enableFind(value:Boolean):void {
			if (_enableFind!=value) enableFindChanged = true;
			_enableFind = value;
			invalidateProperties();
		}
		
		
		private var _enableReplace:Boolean = true;
		
		/**
		 * Enable replace
		 * Default is true.
		 * */
		public function get enableReplace():Boolean {
			return _enableReplace;
		}
		
		/**
		 * @private
		 */
		public function set enableReplace(value:Boolean):void {
			if (_enableFind!=value) enableFindChanged = true;
			_enableReplace = value;
			invalidateProperties();
		}
		
		
		/**
		 * Listen for change events. The editor may be faster if we 
		 * aren't listening for change events and transporting values back and forth. 
		 * Setting this to false is good for situations like read only mode.
		 * Default is true.
		 * */
		public function get listenForChanges():Boolean {
			return _listenForChanges;
		}
		
		/**
		 * @private
		 */
		public function set listenForChanges(value:Boolean):void {
			if (_listenForChanges!=value) listenForChangesChanged = true;
			_listenForChanges = value;
			
			invalidateProperties();
		}
		
		private var _listenForChanges:Boolean = true;
		private var listenForChangesChanged:Boolean;
		
		
		public static const FIND:String = "find";
		public static const REPLACE:String = "replace";
		public static const EDITOR:String = "editor";
		public static const SESSION:String = "session";
		public static const SELECTION:String = "selection";
		
		override protected function commitProperties():void {
			super.commitProperties();
			var options:Object;
			
			if (isBrowser && useExternalInterface && aceFound) {
				// continue
			}
			else if (!editor) {
				// maybe call commitproperties later
				return;
			}
			
			
			// this is good to turn off listeners for read only mode as it will save CPU cycles
			if (listenForChangesChanged) {
				// should we use session here instead of getSession() - not unless handler is always added
				if (listenForChanges && !callBackAdded) {
					//addEditorListener(EDITOR, SESSION_MOUSE_MOVE, mouseMoveHandler);
					addEditorListener(EDITOR, Event.COPY, copyHandler);
					addEditorListener(EDITOR, Event.PASTE, pasteHandler);
					addEditorListener(SESSION, EDITOR_CHANGE, changeHandler);
					addEditorListener(SESSION, SESSION_CHANGE_SESSION, sessionChangeHandler);
					addEditorListener(SESSION, BLUR, blurHandler);
					addEditorListener(SESSION, FOCUS, focusHandler);
					addEditorListener(SELECTION, SESSION_CHANGE_SELECTION, selectionChangeHandler);
					addEditorListener(SELECTION, SESSION_CHANGE_CURSOR, cursorChangeHandler);
					/* ...too busy
					session.on("changeSelectionStyle", changeHandler);
					*/
					callBackAdded = true;
				}
				else if (!listenForChanges) {
					
					removeEditorListener(EDITOR, Event.COPY, copyHandler);
					removeEditorListener(EDITOR, Event.PASTE, pasteHandler);
					removeEditorListener(EDITOR, SESSION_MOUSE_MOVE, mouseMoveHandler);
					removeEditorListener(SESSION, EDITOR_CHANGE, changeHandler);
					removeEditorListener(SESSION, SESSION_CHANGE_SESSION, sessionChangeHandler);
					removeEditorListener(SESSION, BLUR, blurHandler);
					removeEditorListener(SESSION, FOCUS, focusHandler);
					removeEditorListener(SELECTION, SESSION_CHANGE_SELECTION, selectionChangeHandler);
					removeEditorListener(SELECTION, SESSION_CHANGE_CURSOR, cursorChangeHandler);
					callBackAdded = false;
				}
				
				listenForChangesChanged = false;
			}
			
			if (marginChanged) {
				setMargin(_margin);
				marginChanged = false;
			}
			
			if (themeChanged) {
				setTheme(_theme);
				themeChanged = false;
			}
			
			// there might be a bug where the snippets are not for the correct language if we enable
			// snippets at a later time than at startup so we mark mode as changed
			if (enableSnippetsChanged) {
				setEnableSnippets(_enableSnippets);
				//options = aceEditor.getOptions();
				enableSnippetsChanged = false;
			}
			
			if (modeChanged) {
				setMode(_mode);
				modeChanged = false;
			}
			
			if (keyBindingChanged) {
				setKeyboardHandler(_keyBinding)
				keyBindingChanged = false;
			}
			
			if (showFoldWidgetsChanged) {
				setShowFoldWidgets(_showFoldWidgets);
				showFoldWidgetsChanged = false;
			}
			
			if (showPrintMarginsChanged) {
				setShowPrintMargin(_showPrintMargin);
				showPrintMarginsChanged = false;
			}
			
			if (showGutterChanged) {
				setShowGutter(_showGutter);
				showGutterChanged = false;
			}
			
			if (showLineNumbersChanged) {
				setShowLineNumbers(_showLineNumbers);
				showLineNumbersChanged = false;
			}
			
			if (showCursorChanged) {
				setShowCursor(_showCursor);
				showCursorChanged = false;
			}
			
			if (useWordWrapChanged) {
				setUseWrapMode(_useWordWrap);
				useWordWrapChanged = false;
			}
			
			if (isReadOnlyChanged) {
				setReadOnly(_isReadOnly);
				isReadOnlyChanged = false;
			}
			
			if (showInvisiblesChanged) {
				setShowInvisibles(_showInvisibles);
				showInvisiblesChanged = false;
			}
			
			if (autoCompleterPopUpSizeChanged) {
				setAutoCompletePopUpSize(_autoCompleterPopUpSize);
				autoCompleterPopUpSizeChanged = false;
			}
			
			if (fontSizeChanged) {
				setFontSize(getStyle("fontSize"));
				fontSizeChanged = false;
			}
			
			if (showIndentGuidesChanged) {
				setDisplayIndentGuides(_showIndentGuides);
				showIndentGuidesChanged = false;
			}
			
			if (enableFindChanged) {
				setEnableFindCommand(_enableFind);
				enableFindChanged = false;
			}
			
			if (enableReplaceChanged) {
				setEnableReplaceCommand(_enableReplace);
				enableReplaceChanged = false;
			}
			
			if (enableBasicAutoCompletionChanged) {
				setEnableBasicAutoCompletion(_enableBasicAutoCompletion);
				enableBasicAutoCompletionChanged = false;
			}
			
			if (enableLiveAutoCompletionChanged) {
				setEnableLiveAutocompletion(_enableLiveAutoCompletion);
				enableLiveAutoCompletionChanged = false;
			}
			
			if (highlightActiveLineChanged) {
				setHighlightActiveLine(_highlightActiveLine);
				highlightActiveLineChanged = false;
			}
			
			if (highlightGutterLineChanged) {
				setHighlightGutterLine(_highlightGutterLine);
				highlightGutterLineChanged = false;
			}
			
			if (highlightSelectedWordChanged) {
				setHighlightSelectedWord(_highlightSelectedWord);
				highlightSelectedWordChanged = false;
			}
			
			if (tabSizeChanged) {
				setTabSize(_tabSize);
				tabSizeChanged = false;
			}
			
			if (useSoftTabsChanged) {
				setUseSoftTabs(_useSoftTabs);
				useSoftTabsChanged = false;
			}
			
			if (useWorkerChanged) {
				setUseWorker(_useWorker);
				useWorkerChanged = false;
			}
			
			if (enableBehaviorsChanged) {
				setBehavioursEnabled(_enableBehaviors);
				enableBehaviorsChanged = false;
			}
			
			if (enableWrapBehaviorsChanged) {
				setWrapBehavioursEnabled(_enableWrapBehaviors);
				enableWrapBehaviorsChanged = false;
			}
			
			if (scrollSpeedChanged) {
				setScrollSpeed(_scrollSpeed);
				scrollSpeedChanged = false;
			}
			
			if (textChanged) {
				setValue(_text); // use _text not text // causes selectionChange changeSelection events
				textChanged = false;
			}
			
		}
		
		/**
		 * Adds a listener to a specific event 
		 * @param eventDispatcherType is dispatcher object. Valid values are "editor", "session" and "selection".
		 * */
		public function addEditorListener(eventDispatcherType:String, eventName:String, methodHandler:Function):void {
			
			if (isBrowser && useExternalInterface) {
				var callbackName:String;
				callbackName = editorIdentity + "_" + eventName;
				ExternalInterface.addCallback(callbackName, methodHandler);
				
				
				// if the application has issues it's because you are trying to pass
				// back an object with too many cyclic references
				// pass back simple objects
				var string:String = <xml><![CDATA[
				function (id, objectId, dispatcherType, eventName, callbackName) {
					var application = this[objectId];
					var editor = ace.edit(id);
					var dispatcher;

					if (dispatcherType=="editor") dispatcher = editor;
					else if (dispatcherType=="session") dispatcher = editor.session; 
					else if (dispatcherType=="selection") dispatcher = editor.session.selection;

					if (application.methodHandlers==null) { application.methodHandlers = {}; }

					application.methodHandlers[callbackName] = function(event, editorInstance) {
						//console.log(event);
						var object;
						var lead;
						var anchor;
						var type = event.type;

						if (type==null && event.event!=null) {
							type = event.event.type;
						}
						else if (type==null && event.action) {
							type = "change";
						}
						
						if (type=="mousemove") {
							event.$inSelection = event.inSelection();
							event.$pos = event.getDocumentPosition();
							event.domEvent = null;
							event.editor = null;
							application[callbackName](event, null);
						}
						else if (type=="changeCursor") {
							object = {};
							object.anchor = editorInstance.anchor;
							object.lead = editorInstance.lead;
							application[callbackName](event, object);
						}
						else if (type=="changeSelection") {
							object = {};
							object.anchor = editorInstance.anchor;
							object.lead = editorInstance.lead;
							application[callbackName](event, object);
						}
						else if (type=="change") {
							//object = {};
							application[callbackName](event, object);
						}
						else if (type=="paste") {
							object = {};
							object.text = event.text;
							object.anchor = editorInstance.anchor;
							object.lead = editorInstance.lead;
							application[callbackName](object, object);
						}
						else {

							// only return objects one level deep to prevent recursion
							for (var key in event) {
								value = event[key];

							    if (event.hasOwnProperty(key) && (typeof value == 'object')) {
							      for (var subkey in value) {
							        if (value.hasOwnProperty(subkey) && (typeof value[subkey] == 'object')) {
							          value[subkey] = null;
							          delete value[subkey];
							        }
							      }
							    }
							}

							application[callbackName](event, editorInstance.container.id);
						}
					}
					dispatcher.on(eventName, application.methodHandlers[callbackName]);
					return true;
				}
				]]></xml>;
				
				var results:Object = ExternalInterface.call(string, editorIdentity, ExternalInterface.objectID, 
															eventDispatcherType, eventName, callbackName);
			}
			else {
				var dispatcher:Object;
				
				if (eventDispatcherType==EDITOR) {
					dispatcher = editor; 
				} 
				else if (eventDispatcherType==SESSION) {
					dispatcher = editor.session; 
				} 
				else if (eventDispatcherType==SELECTION) {
					dispatcher = editor.session.selection;
				}
				
				dispatcher.on(eventName, methodHandler);
			}
			
		}
		
		/**
		 * Removes a listener to a specific event 
		 * @param eventDispatcherType is dispatcher object. Valid values are "editor", "session" and "selection".
		 * @param eventName event name to listen for
		 * @param methodHandler function to handle the event
		 * */
		public function removeEditorListener(eventDispatcherType:String, eventName:String, methodHandler:Function):void {
			
			if (isBrowser && useExternalInterface) {
				var callbackName:String;
				callbackName = editorIdentity + "_" + eventName;
				//ExternalInterface.addCallback(callbackName, methodHandler);
				
				var string:String = <xml><![CDATA[
				function (id, objectId, dispatcherType, eventName, callbackName) {
					var application = this[objectId];
					var editor;
					var dispatcher;

					if (application.methodHandlers==null) { return; }

					editor = ace.edit(id);
					if (dispatcherType=="editor") dispatcher = editor; else 
					if (dispatcherType=="session") dispatcher = editor.session; else 
					if (dispatcherType=="selection") dispatcher = editor.session.selection;
					dispatcher.off(eventName, application.methodHandlers[callbackName]);
					application.methodHandlers[callbackName] = null;
					delete application.methodHandlers[callbackName];
					return true;
				}
				]]></xml>;
				
				var results:Object = ExternalInterface.call(string, editorIdentity, ExternalInterface.objectID, 
															eventDispatcherType, eventName, callbackName);
			}
			else {
				var dispatcher:Object;
				
				if (eventDispatcherType==EDITOR) {
					dispatcher = editor; 
				} 
				else if (eventDispatcherType==SESSION) {
					dispatcher = editor.session; 
				} 
				else if (eventDispatcherType==SELECTION) {
					dispatcher = editor.session.selection;
				}
				
				dispatcher.off(eventName, methodHandler);
			}
			
		}
		
		
		/**
		 * Set focus to the editor. Not really working now. Problem with AIR?
		 * */
		override public function setFocus():void {
			super.setFocus();
			
			if (editor) {
				var textInput:Object = editor.textInput;
				var container:Object = editor.container;
				var textAreas:Object = container.getElementsByTagName("textarea");
				var textArea:Object = textAreas[0];
				textInput.focus(); // doesn't seem to work
				textArea.focus();
				
			}
		}
		
		/**
		 *  @private
		 */
		override public function styleChanged(styleProp:String):void {
			var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
			
			super.styleChanged(styleProp);
			
			if (allStyles || styleProp == "fontSize") {
				fontSizeChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * Maps to the session reset cache method
		 * */
		public function reset():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.session.reset();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				session.reset();
			}
		}
		
		/**
		 * Maps to the session reset cache method
		 * */
		public function resetCaches():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.session.resetCaches();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				session.resetCaches();
			}
			
		}
		
		/**
		 * Resets the cache 
		 * */
		public function resetCache():void {
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					editor.session.bgTokenizer.lines.length = editor.session.bgTokenizer.states.length = 0;
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				session.bgTokenizer.lines.length = session.bgTokenizer.states.length = 0;
			}
			
		}
		
		/**
		 * Maps to the session beautify method. Doesn't work well. 
		 * */
		public function beautifyMarkup():void {
			if (beautify) {
				beautify.beautify(session);
			}
			else {
				throw new Error("Beautify extension is not installed. Add an include on the page template");
			}
		}
		
		/**
		 * Inserts a block of text at the indicated position.
		 * */
		public function insert(position:Object, text:String):Object {
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, position, text) {
					var editor = ace.edit(id);
					return editor.insert(position, text);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, position, text);
				return results;
			}
			else {
				return editor.insert(position, text);
			}
		}
		
		/**
		 * Appends text after
		 * */
		public function appendText(text:String):void {
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, text) {
					var editor = ace.edit(id);
					var session = editor.session;
					var object = {row: session.getLength(), column: 0},
					editor.insert(position, text);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, "\n" + text);
			}
			else {
				editor.session.insert({row: session.getLength(), column: 0}, "\n" + text);
			}
		}
		
		/**
		 * Set breakpoint
		 * Sets a breakpoint on the row number given by rows. This function also emites the 'changeBreakpoint' event.
		 * */
		public function setBreakpoint(row:int, cssClassName:String):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, cssClassName) {
					var editor = ace.edit(id);
					editor.getSession().setBreakpoint(row, cssClassName);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, row, cssClassName);
			}
			else {
				editor.getSession().setBreakpoint(row, cssClassName);
			}
			
		}
		
		/**
		 * Set breakpoints
		 * Sets a breakpoint on every row number given by rows. 
		 * This function also emites the 'changeBreakpoint' event.
		 * */
		public function setBreakpoints(rows:Array):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, rows) {
					var editor = ace.edit(id);
					editor.getSession().setBreakpoints(rows);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, rows);
			}
			else {
				session.setBreakpoints(rows);
			}
			
		}
		
		/**
		 * Set annotation
		 * @param row row for annotation
		 * @param column column of annotation
		 * @param text text to display for annotation
		 * @param type - type can be error, warning and information
		 * */
		public function setAnnotation(row:int, column:int = 0, text:String = null, type:String = null):void {
			var object:Object = {row: row, column: column, text: text, type: type};
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, object) {
					var editor = ace.edit(id);
					editor.getSession().setAnnotations([object]);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, object);
			}
			else {
				editor.getSession().setAnnotations([object]);
			}
			
		}
		
		/**
		 * Sets one or more annotations. See setAnnotation for object name value pairs.
		 * Sets annotations for the EditSession. This functions emits the 'changeAnnotation' event.
		 * @see setAnnotation
		 * @param row row for annotation
		 * @param column column of annotation
		 * @param text text to display for annotation
		 * @param type - type can be error, warning and information
		 * */
		public function setAnnotations(annotations:Array):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, annotations) {
					var editor = ace.edit(id);
					editor.getSession().setAnnotations(annotations);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, annotations);
			}
			else {
				editor.getSession().setAnnotations(annotations);
			}
		}
		
		/**
		 * Clears all annotations
		 * */
		public function clearAnnotations():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.getSession().setAnnotations([]);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.getSession().setAnnotations([]);
			}
			
		}
		
		/**
		 * Clears breakpoint
		 * */
		public function clearBreakpoint(row:int):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					editor.getSession().clearBreakpoint(row);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, row);
			}
			else {
				editor.getSession().clearBreakpoint(row);
			}
			
		}
		
		/**
		 * Clears all breakpoint
		 * */
		public function clearBreakpoints():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.getSession().clearBreakpoints();
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.getSession().clearBreakpoints();
			}
			
		}
		
		/**
		 * Set the selection range
		 * */
		public function setSelectionRange(range:Object, reverse:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range, reverse) {
					var editor = ace.edit(id);
					editor.setSelectionRange(range, reverse);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, range, reverse);
			}
			else {
				editor.setSelectionRange(range, reverse);
			}
			
		}
		
		/**
		 * Moves the selection cursor to the indicated row and column.
		 * */
		public function setSelectionTo(row:Number, column:Number):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					editor.setSelectionTo(row, column);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, row, column);
			}
			else {
				editor.setSelectionTo(row, column);
			}
		}
		
		/**
		 * Moves the selection cursor to the row and column indicated
		 * */
		public function selectToPosition(position:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					editor.selectToPosition(position);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, position);
			}
			else {
				editor.selectToPosition(position);
			}
			
		}
		
		/**
		 * Adds a range to a selection by entering multiselect mode, if necessary.
		 * */
		public function addRange(range:Object, blockChangeEvents:Boolean):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, range, blockChangeEvents) {
					var editor = ace.edit(id);
					editor.addRange(range, blockChangeEvents);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, range, blockChangeEvents);
			}
			else {
				editor.addRange(range, blockChangeEvents);
			}
		}
		
		/**
		 * Gets the selection anchor
		 * */
		public function getSelectionAnchor():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.selection.getSelectionAnchor();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.selection.getSelectionAnchor();
			}
		}
		
		/**
		 * Gets the selection lead
		 * */
		public function getSelectionLead():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.selection.getSelectionLead();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.selection.getSelectionLead();
			}
			
		}
		
		/**
		 * Gets the cursor
		 * */
		public function getCursor():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.selection.getCursor();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.selection.getCursor();
			}
			
		}
		
		/**
		 * Gets the range
		 * */
		public function getRange():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.getRange();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.getRange();
			}
		}
		
		/**
		 * Gets line
		 * */
		public function getLine(row:uint):String {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					return editor.session.getLine(row);
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, row);
				return results;
			}
			else {
				return editor.session.getLine(row);
			}
		}
		
		/**
		 * Gets lines
		 * */
		public function getLines(start:uint, end:uint):Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, start, end) {
					var editor = ace.edit(id);
					return editor.session.getLines(start, end);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, start, end);
				return results;
			}
			else {
				return editor.session.getLines(start, end);
			}
		}
		
		/**
		 * Gets markers
		 * */
		public function getMarkers(inFront:Boolean):Array {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, inFront) {
					var editor = ace.edit(id);
					return editor.session.getMarkers(inFront);
				}
				]]></xml>;
				var results:Array = ExternalInterface.call(string, editorIdentity, inFront);
				return results;
			}
			else {
				return editor.session.getMarkers(inFront);
			}
		}
		
		/**
		 * Gets the current text mode
		 * @return returns TextMode
		 * */
		public function getMode():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getMode();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getMode();
			}
		}
		
		/**
		 * Gets new line mode
		 * */
		public function getNewLineMode():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getNewLineMode();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getNewLineMode();
			}
		}
		
		/**
		 * Gets row length. Returns number of screenrows in a wrapped line
		 * */
		public function getRowLength(row:int):int {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row) {
					var editor = ace.edit(id);
					return editor.session.getRowLength(row);
				}
				]]></xml>;
				var results:int = ExternalInterface.call(string, editorIdentity, row);
				return results;
			}
			else {
				return editor.session.getRowLength(row);
			}
		}
		
		/**
		 * Gets overwrite. Returns true if overwrites are enabled
		 * */
		public function getOverwrite():Boolean {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getOverwrite();
				}
				]]></xml>;
				var results:Boolean = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getOverwrite();
			}
		}
		
		/**
		 * Gets the total lines. Same as getLength()
		 * */
		public function getTotalLines():int {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getLength();
				}
				]]></xml>;
				var results:int = parseInt(ExternalInterface.call(string, editorIdentity));
				return results;
			}
			else {
				return editor.session.getLength();
			}
			
			return 0;
		}
		
		/**
		 * Gets the token at the row and column specified
		 * */
		public function getTokenAt(row:uint, column:uint):Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					return editor.session.getTokenAt(row, column);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, row, column);
				return results;
			}
			else {
				return editor.session.getTokenAt(row, column);
			}
		}
		
		/**
		 * Gets the annotations
		 * */
		public function getAnnotations():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getAnnotations();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getAnnotations();
			}
		}
		
		/**
		 * Gets breakpoints
		 * */
		public function getBreakpoints():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getBreakpoints();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getBreakpoints();
			}
		}
		
		/**
		 * Gets document
		 * */
		public function getDocument():Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					return editor.session.getDocument();
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
				return results;
			}
			else {
				return editor.session.getDocument();
			}
		}
		
		/**
		 * Gets the range of a word including its right whitespace
		 * @return returns a range
		 * */
		public function getAWordRange(row:int, column:int):Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column) {
					var editor = ace.edit(id);
					return editor.session.getAWordRange(row, column);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, row, column);
				return results;
			}
			else {
				return editor.session.getAWordRange(row, column);
			}
		}
		
		/**
		 * Moves the cursor to the position provided.
		 * */
		public function moveCursorToPosition(position:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, position) {
					var editor = ace.edit(id);
					editor.moveCursorToPosition(position);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, position);
			}
			else {
				editor.moveCursorToPosition(position);
			}
		}
		
		/**
		 * Moves the cursor to the row and column provided. If preventUpdateDesiredColumn 
		 * is true, then the cursor stays in the same column position as its original point.
		 * */
		public function moveCursorTo(row:Number, column:Number, keepDesiredColumn:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column, keepDesiredColumn) {
					var editor = ace.edit(id);
					editor.moveCursorTo(row, column, keepDesiredColumn);
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity, row, column, keepDesiredColumn);
			}
			else {
				editor.moveCursorTo(row, column, keepDesiredColumn);
			}
		}
		
		/**
		 * Moves the cursor to the row and column provided. If preventUpdateDesiredColumn 
		 * is true, then the cursor stays in the same column position as its original point.
		 * */
		public function moveCursorToScreen(row:Number, column:Number, keepDesiredColumn:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column, keepDesiredColumn) {
					var editor = ace.edit(id);
					editor.moveCursorToScreen(row, column, keepDesiredColumn);
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity, row, column, keepDesiredColumn);
			}
			else {
				editor.moveCursorToScreen(row, column, keepDesiredColumn);
			}
		}
		
		/**
		 * Reference to the range
		 * */
		public var range:Object;
		
		public function get showIndentGuides():Boolean {
			return _showIndentGuides;
		}
		
		/**
		 * Shows indent guides
		 * */
		public function set showIndentGuides(value:Boolean):void {
			if (_showIndentGuides!=value) showIndentGuidesChanged = true;
			_showIndentGuides = value;
			invalidateProperties();
		}
		private var _showIndentGuides:Boolean;
		
		
		/**
		 * Text to show or is shown in the editor.
		 * Use _text to get the value that was set programmatically. 
		 * */
		public function get text():String {
			
			if (editor) {
				return editor.getValue();
			}
			return _text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void {
			if (text!=value) textChanged = true; // have to compare to text not _text
			_text = value;
			invalidateProperties();
		}
		public var _text:String = "";
		
		/**
		 * Method to satisfy IDisplayText. Returns false.
		 * */
		public function get isTruncated():Boolean {
			return false;
		}
		
		private var _margin:String;
		
		public function get margin():String {
			return _margin;
		}
		
		/**
		 * Sets the margin around the editor. This is useful for scrolling
		 * beyond the boundries of the editor. Also works around some mouse issues
		 * Set to values such as "20px 0". This will add 20px of space around the 
		 * top and bottom of the editor. Default is 0.  
		 * */
		public function set margin(value:String):void {
			if (_margin!=value) marginChanged = true;
			_margin = value;
			invalidateProperties();
		}
		
		
		public var errorMessage:String;
		
		/**
		 * Returns an editor that has an id. This will error out here if the div
		 * cannot be found on the page template. 
		 * 
		 * You should have a div on your page with an identity like this:
<pre>
 &lt;div id='editor'>&lt;/div>
</pre>
		 * @see #editorIdentity
		 * */
		public function getEditor(id:String):Object {
			return window.ace.edit(id);
		}
		
		public var searchModule:Object;
		
		private function addSearchBox():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, row, column, keepDesiredColumn) {
					ace.config.loadModule("ace/ext/searchbox", function(m:Object):void {
						searchModule = m;
						searchModule.Search(editor);
						editor.searchBox.hide();
					});
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity);
			}
			else {
				config.loadModule("ace/ext/searchbox", function(m:Object):void {
					searchModule = m;
					searchModule.Search(editor);
					editor.searchBox.hide();
				});
			}
			
		}
		
		/**
		 * Shows the native search text input. 
		 * @param value value to place in search input
		 * @param show if set to true then show if set to false then hide
		 * @param isReplace if set to true show search and replace field
		 * */
		public function showSearchInput(value:String = null, show:Boolean = true, isReplace:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value, show, isReplace) {
					var editor = ace.edit(id);

					if (editor.searchBox==null) {
						searchModule.Search(editor);
						editor.searchBox.hide();
					}
					
					if (show) {
						editor.searchBox.show(value, isReplace);
					}
					else {
						editor.searchBox.hide();
					}
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity, value, show, isReplace);
			}
			else {
				// create search box if not created
				if (editor.searchBox==null) {
					searchModule.Search(editor);
					editor.searchBox.hide();
				}
				
				if (show) {
					editor.searchBox.show(value, isReplace);
				}
				else {
					editor.searchBox.hide();
				}
			}
		}
		
		/**
		 * Hide native search input
		 * */
		public function hideSearchInput():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);

					if (editor.searchBox==null) {
						searchModule.Search(editor);
					}
					
					editor.searchBox.hide();
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity);
			}
			else {
				
				if (editor.searchBox==null) {
					searchModule.Search(editor);
				}
				
				editor.searchBox.hide();
			}
			
		}
		
		/**
		 * Toggles between showing and hiding native search input field
		 * @return returns true if visible and false if not
		 * */
		public function toggleSearchField(fillWithSelection:Boolean = true):Boolean {
			var isVisible:Boolean;
			var selection:String;
			
			if (editor.searchBox==null) {
				searchModule.Search(editor);
				isVisible = true;
				editor.searchBox.hide();
			}
			
			
			isVisible = editor.searchBox.element.style.display != "none";
			
			if (isVisible) {
				hideSearchInput();
			}
			else {
				if (fillWithSelection) {
					selection = session.getTextRange(editor.getSelectionRange());
				}
				
				showSearchInput(selection);
			}
			
			return !isVisible;
		}
	
		/**
		 * Show native finder
		 * */
		public function searchInputHandler(editor:Object, event:Object):void {
			showSearchInput();
		}
		
		/**
		 * Use to add commands to the editor<br ><br >
		 * 
		 * Example: 
<pre>
editor.addCommand({
	name: 'find',
	bindKey: {win: "Ctrl-F", "mac": "Cmd-F"},
	exec: findKeyboardHandler});
</pre>
		 * */
		public function addCommand(command:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, command) {
					var editor = ace.edit(id);
					editor.commands.addCommand(command);
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity, command);
			}
			else {
				editor.commands.addCommand(command);
			}
			
		}
		
		/**
		 * Used to remove commands from the editor<br ><br >
		 * 
		 * Example (not tested): 
<pre>
editor.removeCommand({name: 'find'});
</pre>
		 * */
		public function removeCommand(command:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, command) {
					var editor = ace.edit(id);
					editor.commands.removeCommand(command);
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity, command);
			}
			else {
				editor.commands.removeCommand(command);
			}
		}
		
		/**
		 * Handler for block comment keyboard shortcut
		 * */
		public function blockCommentHandler(editor:Object, event:Object):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.toggleBlockComment();
				}
				]]></xml>;
				ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.toggleBlockComment();
			}
			
		}
		
		/**
		 * Handler for save keyboard shortcut
		 * */
		public function saveKeyboardHandler(editor:Object, event:Object):void {
			//console.log("saving", editor.session.getValue())
			if (hasEventListener(SAVE)) {
				dispatchEvent(new Event(SAVE));
			}
		}
		
		/**
		 * Handler for find keyboard shortcut
		 * */
		public function findKeyboardHandler(editor:Object, event:Object):void {
			if (hasEventListener(FIND)) {
				dispatchEvent(new Event(FIND));
			}
		}
		
		/**
		 * Sets the text of the editor. You can also set the text property.
		 * Required. If position is 0 then all text is selected and cursor is at the end of the document, 
		 * if -1 then the cursor is placed at the start of the document and 
		 * if 1 then the cursor is placed at the end. 
		 * Default is -1. 
		 * */
		public function setValue(value:String="", position:int = -1):void {
			isValueCommit = true;
			if (value==null) value = "";
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value, position) {
					var editor = ace.edit(id);
					editor.setValue(value, position);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value, position);
			}
			else {
				editor.setValue(value, position);
			}
			
			_text = value;
			isValueCommit = false;
		}
		
		/**
		 * Indicates that the changes being dispatched from the ace editor
		 * are not changes from the user typing but from us setting the 
		 * contents programmatically.
		 * */
		public var isValueCommit:Boolean;
		private var themeChanged:Boolean;
		private var scrollSpeedChanged:Boolean;
		private var modeChanged:Boolean;
		private var showFoldWidgetsChanged:Boolean;
		private var showPrintMarginsChanged:Boolean;
		private var showGutterChanged:Boolean;
		private var showLineNumbersChanged:Boolean;
		private var showCursorChanged:Boolean;
		private var useWordWrapChanged:Boolean;
		private var isReadOnlyChanged:Boolean;
		private var enableFindChanged:Boolean;
		private var enableReplaceChanged:Boolean;
		private var showInvisiblesChanged:Boolean;
		private var fontSizeChanged:Boolean;
		private var textChanged:Boolean;
		private var showIndentGuidesChanged:Boolean;
		private var enableBasicAutoCompletionChanged:Boolean;
		private var enableLiveAutoCompletionChanged:Boolean;
		private var highlightActiveLineChanged:Boolean;
		private var highlightGutterLineChanged:Boolean;
		private var highlightSelectedWordChanged:Boolean;
		private var tabSizeChanged:Boolean;
		private var useSoftTabsChanged:Boolean;
		private var useWorkerChanged:Boolean;
		private var enableWrapBehaviorsChanged:Boolean;
		private var enableSnippetsChanged:Boolean;
		private var marginChanged:Boolean;
		
		/**
		 * Reference to the anchor of the last changeSelection event
		 * */
		public var anchor:Object;
		
		/**
		 * Reference to the lead of the last changeSelection event
		 * */
		public var lead:Object;
		
		/**
		 * Reference to current row. Must have listenForChanges enabled
		 * */
		public var row:int;
		
		/**
		 * Reference to current column.
		 * */
		public var column:int;
		private var enableBehaviorsChanged:Boolean;
		private var keyBindingChanged:Boolean;
		public var mouseMoveEvent:Object;
		
		/**
		 * Text copied on copy. Only available through a copy event dispatch. 
		 * */
		public var copiedText:String;
		
		/**
		 * Text pasted into the editor. Only available through a paste event dispatch. 
		 * */
		public var pastedText:String;
		
		/**
		 * Console object. 
		 * This is a workaround because somewhere in the ace javascript someone is calling console.log
		 * and there is no console in the AIR HTML component dom window
		 * however you can create your own and assign it to the console property. 
		 * Add at least log and error methods.
		 * 
<pre>
editor.console = {log:trace, error:trace};
</pre>
		 */
		public var console:Object;
		
		/**
		 * Set this to true to report errors to the console
		 * such as missing template file and missing JavaScript ace global variable
		 */
		public var validateSources:Boolean = true;
		
		/**
		 * Indicates if the window.ace instance is found. If it's false and the complete event
		 * has been dispatched check that you have a script on the page template and that
		 * it is pointing to the location of the ace editor src files. 
		 * 
		 * It should look like this:
		 <pre>
		 &lt;script src="src-min-noconflict/ace.js" type="text/javascript" charset="utf-8">&lt;/script>
		 </pre>
		 * */
		public var aceFound:Boolean;
		public var aceEditorContainerFound:Boolean;
		
		/**
		 * This is set to true when the editor is found and ready to use
		 * */
		[Bindable]
		public var isEditorReady:Boolean;
		
		/**
		 * Errors occur on exit possibly because of an on unload event. 
		 * This is set to true to ignore errors which are causing the application to crash
		 * because of runtime errors. 
		 * */
		public var ignoreCloseErrors:Boolean = true;
		
		/**
		 * Indicates if the window.ace editor instance is found. If it's false, the complete event
		 * has been dispatched and the property aceFound is true then check that you have a div 
		 * on the page template that has an id that matches the value in editorIdentity 
		 * (default is "editor").  
		 * 
		 * It should look like this:
		 <pre>
		 &lt;div id='editor'>&lt;/div>
		 </pre>
		 * */
		public var aceEditorFound:Boolean;
		
		/**
		 * Handles session change events from the editor. Not tested.
		 * */
		public function sessionChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeSelection
			
			if (isAIR) {
				session = editor.getSession();
			}
			
			if (hasEventListener(SESSION_CHANGE)) {
				
				dispatchEvent(new Event(SESSION_CHANGE));
			}
		}
		
		/**
		 * Handles selection change events from the editor
		 * */
		public function selectionChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeSelection

			
			if (isAIR) {
				anchor = editor.anchor;
				lead = editor.lead;
			}
			else if (isBrowser && useExternalInterface) {
				anchor = editor.anchor;
				lead = editor.lead;
			}
			
			if (hasEventListener(SELECTION_CHANGE)) {
				
				dispatchEvent(new Event(SELECTION_CHANGE));
			}
		}
		
		/**
		 * Handles cursor change events from the editor
		 * */
		public function cursorChangeHandler(event:Object, editor:Object):void {
			var type:String = event.type; // changeCursor
			
			if (isAIR) {
				//var leadPosition:Object = lead.getPosition();
				anchor = editor.anchor;
				lead = editor.lead;
				row = lead.row;
				column = lead.column;
			}
			else if (isBrowser && useExternalInterface) {
				anchor = editor.anchor;
				lead = editor.lead;
				
				if (lead) {
					row = lead.row;
					column = lead.column;
				}
			}
			
			if (hasEventListener(CURSOR_CHANGE)) {
				dispatchEvent(new Event(CURSOR_CHANGE));
			}
		}
		
		/**
		 * Handles mouse move events from the editor. Named as it is because UIComponent already 
		 * has a mouseMove event.
		 * 
		 * You can use this event to get token info:
<pre>
 var position = ace.mouseMoveEvent.$pos!=null ? ace.mouseMoveEvent.$pos : ace.mouseMoveEvent.getDocumentPosition();
 var token:Object = session.getTokenAt(position.row, position.column);
 trace(token);
 
 token = {
	 type: "paren.paren",
	 value: "}",
	 index: 0,
	 start: 0
 } 
 </pre>
		 * */
		public function mouseMoveHandler(event:Object, editor:Object):void {
			//var token:Object = session.getTokenAt(position.row, position.column);
			
			if (hasEventListener(MOUSE_MOVE_OVER_EDITOR)) {
				mouseMoveEvent = event;
				dispatchEvent(new Event(MOUSE_MOVE_OVER_EDITOR));
			}
		}
		
		public var lastChangeOperation:Object;
		
		/**
		 * Handles change events from the editor. Check userData property on event.
		 * */
		public function changeHandler(event:Object, editor:Object):void {
			var action:String = event ? event.action : null;
			var operation:FlowOperation;
			
			lastChangeOperation = event;
			
			//trace("action:" + action);
			
			if (hasEventListener(Event.CHANGE)) {
				operation = new FlowOperation(null); // thought I could use this but doesn't look like I can set certain properties
				operation.userData = event;
				
				// POSSIBLE SOLUTION TO MULTIPLE EVENTS BEING DISPATCHED IS TO 
				// CHECK OUT METHOD TLF DOES IT IN RICH EDITABLE TEXT 
				if (action==INSERT_ACTION) {
					
				}
				else if (action==INSERT_TEXT_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				else if (action==INSERT_LINES_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				else if (action==REMOVE_LINES_ACTION) {
					//dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
				}
				
				dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE, false, false, operation));
			}
			
		}
		
		/**
		 * Handles paste events from the editor
		 * Pasted value is copied to the pastedText property 
		 * and then removed after paste event has been dispatched
		 * */
		public function pasteHandler(event:Object, editor:Object):void {
			pastedText = text;
			
			if (hasEventListener(Event.PASTE)) {
				dispatchEvent(new Event(Event.PASTE));
			}
			
			pastedText = text;
		}
		
		/**
		 * Handles copy events from the editor. 
		 * Copied value is copied to the copiedText property 
		 * and then removed after copy event has been dispatched.
		 * */
		public function copyHandler(text:String, editor:Object):void {
			copiedText = text;
			
			if (hasEventListener(Event.COPY)) {
				dispatchEvent(new Event(Event.COPY));
			}
			
			copiedText = ""; // removed after event is dispatched
		}
		
		/**
		 * Handles blur events from the editor
		 * */
		public function blurHandler(event:Object, editor:Object):void {
			var action:String = event.action;
			
			//trace("action:" + action);
			
			if (hasEventListener(FocusEvent.FOCUS_OUT)) {
				
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			}
			
		}
		
		/**
		 * Handles focus in events from the editor
		 * */
		public function focusHandler(event:Object, editor:Object):void {
			var action:String = event.action;
			
			if (hasEventListener(FocusEvent.FOCUS_IN)) {
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
			}
			
		}
		
		/**
		 * Forces a blur
		 * */
		public function blur():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.blur();
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.blur();
			}
			
		}
		
		/**
		 * Performs another search for the word previously specified.
		 * */
		public function findPrevious(options:Object = null, animate:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, options, animate) {
					var editor = ace.edit(id);
					editor.findPrevious(options, animate);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, options, animate);
			}
			else {
				editor.findPrevious(options, animate);
			}
		}
		
		/**
		 * Performs another search for the word previously specified.
		 * */
		public function findNext(options:Object = null, animate:Boolean = false):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, options, animate) {
					var editor = ace.edit(id);
					editor.findNext(options, animate);
					return true;
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, options, animate);
			}
			else {
				editor.findNext(options, animate);
			}
		}
		
		/**
		 * Performs a search for the word specified.<br/><br/>
		 * 
		 * To perform a find: 
 <pre>
	 ace.find("needle",{
	 backwards: false,
	 wrap: false,
	 caseSensitive: false,
	 wholeWord: false,
	 regExp: false,
	 start: {row:"0",column:"0"}
	 });
	 ace.findNext();
	 ace.findPrevious();
 </pre>
 To perform a replace: 
 <pre>
	 ace.find("needle");
	 ace.replace('bar');
 </pre>
 To perform a search from the current selection: 
 <pre>
	 var position:Object = ace.getSelectionAnchor();
	 ace.find("needle", {row:position.row,column:position.column});
	 // or
	 var options:Object = {skipCurrent:false};
	 ace.find("needle", options);
 </pre>
		 * @param needle: The string or regular expression you're looking for
		 * @param backwards: Whether to search backwards from where cursor currently is. Defaults to false.
		 * @param wrap: Whether to wrap the search back to the beginning when it hits the end. Defaults to false.
		 * @param caseSensitive: Whether the search ought to be case-sensitive. Defaults to false.
		 * @param wholeWord: Whether the search matches only on whole words. Defaults to false.
		 * @param range: The Range to search within. Set this to null for the whole document
		 * @param regExp: Whether the search is a regular expression or not. Defaults to false.
		 * @param start: The starting Range or cursor position to begin the search
		 * @param skipCurrent: Whether or not to include the current line in the search. Default to false
		 * @param animate: Whether or not to animate. Default to false
		 * */
		public function find(value:String, options:Object = null, animate:Boolean = false):Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value, options, animate) {
					var editor = ace.edit(id);
					return editor.find(value, options, animate);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, value, options, animate);
				return results;
			}
			else {
				return editor.find(value, options, animate);
			}
			
			return null;
		}
		
		/**
		 * Performs a search for the word specified.
		 * */
		public function findAll(value:String, options:Object = null, keeps:Boolean = false):Object {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value, options, keeps) {
					var editor = ace.edit(id);
					return editor.findAll(value, options, keeps);
				}
				]]></xml>;
				var results:Object = ExternalInterface.call(string, editorIdentity, value, options, keeps);
				return results;
			}
			else {
				return editor.findAll(value, options, keeps);
			}
			
			return null;
		}
		
		/**
		 * Clears the selection highlight
		 * */
		public function clearSelection():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.clearSelection();
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.clearSelection();
			}
		}
		
		/**
		 * Resets the undo history
		 * */
		public function resetUndoHistory():void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id) {
					var editor = ace.edit(id);
					editor.session.getUndoManager().reset()
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity);
			}
			else {
				editor.session.getUndoManager().reset();
			}
		}
		
		/**
		 * Attempts to center the selection on the screen
		 * */
		public function centerSelection():void {
			editor.centerSelection();
		}
		
		/**
		 * Measures the performance of the editor.
		 * Returns how fast a mode can tokenize the whole document. 
		 * */
		public function measureTokenizePerformance():int {
			// reset cache
			var linesCount:uint = session ? session.getLength() : 0;
			var time:uint = getTimer();
			
			for (var i:int; i < linesCount; i++) {
				session.getTokens(i);
			}
			
			/*
			if (editor.$highlightTagPending == true) {
				editor.$highlightTagPending = false;
				editor.$highlightPending = false;
			}
			else {
				session.removeMarker(session.$tagHighlight);
				session.$tagHighlight = null;
				session.removeMarker(session.$bracketHighlight);
				session.$bracketHighlight = null;
				editor.$highlightTagPending = true;
				editor.$highlightPending = true;
			}*/
			
			
			
			return getTimer() - time;
		}
		
		/**
		 * Sets the location to the html page that has ace editor in it. 
		 * You should include this file in your application
		 * @see loadOnCreationComplete
		 * @see pathToTemplate
		 * */
		public function initializeEditor():void {
			location = pathToTemplate;
		}
		
		/**
		 * Adds a function to help handle auto completion
		 * 
<pre>
public function codeCompleter(editor, session, position, prefix, callback):void {
	var row:int = position.row;
	var column:int = position.column;
	
	if (prefix.length === 0) { 
		callback(null, []);
	}
	
	var suggestion:Object = {value:"TheWord", caption:"What user sees as they type", meta:"Suggestion", score:"100"};
	callback(null, [suggestion]);
}
</pre>                
         *
		 * */
		public function addCompleter(completerFunction:Function, toolTipFunction:Function = null):void {
			var completer:Object = {};
			
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, completer, toolTipFunction) {
					completer = {};
					completer.getCompletions = completerFunction;
					
					if (toolTipFunction!=null) {
						completer.getDocTooltip = toolTipFunction;
					}

					languageTools.addCompleter(completer);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, completer, toolTipFunction);
			}
			else {
				completer.getCompletions = completerFunction;
				
				if (toolTipFunction!=null) {
					completer.getDocTooltip = toolTipFunction;
				}
				
				languageTools.addCompleter(completer);
			}
			
			
		}
		
		/**
		 * Sets a list of auto complete functions
		 * 
<pre>
var completers = [snippetCompleter, textCompleter, keyWordCompleter];
editor.setCompleters(completers);
</pre>
		 * @see https://github.com/ajaxorg/ace/blob/4c7e5eb3f5d5ca9434847be51834a4e41661b852/lib/ace/ext/language_tools.js
		 * @see #addCompleter()
		 * */
		public function setCompleters(completers:Array):void {
			
			if (isBrowser && useExternalInterface) {
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace.edit(id);
					languageTools.setCompleters(completers);
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, completers);
			}
			else {
				languageTools.setCompleters(completers);
			}
			
		}
		
		private var autoCompleterPopUpSizeChanged:Boolean;
		private var _autoCompleterPopUpSize:int = 320;

		public function get autoCompleterPopUpSize():int {
			return _autoCompleterPopUpSize;
		}

		public function set autoCompleterPopUpSize(value:int):void {
			if (autoCompleterPopUpSizeChanged!=value) autoCompleterPopUpSizeChanged = true;
			_autoCompleterPopUpSize = value;
			invalidateProperties();
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (isAIR) {
				airInstance.width = unscaledWidth;
				airInstance.height = unscaledHeight;
				if (airInstance is UIComponent) {
					UIComponent(airInstance).invalidateDisplayList();
				}
				
			}
			else if (isBrowser) {
				if (useExternalInterface) {
					
					var string:String = <xml><![CDATA[
					function (id, top, left, width, height) {
						var element = document.getElementById(id);
						var style = element.style;
						style.top = top + "px";
						style.left = left + "px";
						style.width = width + "px";
						style.height = height + "px";
						ace.edit(id).resize();
						return true;
					}
					]]></xml>;
					var point:Point = localToGlobal(zeroPoint);
					var results:String = ExternalInterface.call(string, editorIdentity, point.y, point.x, unscaledWidth, unscaledHeight);
				}
				else {
					browserInstance.width = unscaledWidth;
					browserInstance.height = unscaledHeight;
				}
			}
			else if (isMobile) {
				mobileInstance.width = unscaledWidth;
				mobileInstance.height = unscaledHeight;
			}
			
			if (drawBackground) {
				var cornerRadius:int = parseInt(getStyle("cornerRadius"));
				var backgroundAlpha:Number = 0;
				var backgroundColor:int;
				
				if (getStyle("backgroundColor")!==undefined) {
					backgroundColor = getStyle("backgroundColor")!==undefined ? parseInt(getStyle("backgroundColor")) : 0xFFFFFF;
					backgroundAlpha = parseFloat(getStyle("backgroundAlpha"));
				}
				
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius);
			}
		}
		
		public const zeroPoint:Point = new Point();
		public var drawBackground:Boolean;
		
		override public function setVisible(value:Boolean, noEvent:Boolean = false):void {
			super.setVisible(value, noEvent);
			
			if (!initialized) {
				return;
			}
			
			if (isBrowser && useExternalInterface) {
				
				var string:String = <xml><![CDATA[
				function (id, value) {
					var editor = ace ? ace.edit(id) : null;
					var element = editor ? editor.container : null;
					var style = element ? element.style : null;
					if (editor==null || editor==null) return false;
					//style.display = value ? "block" : "none";
					style.visibility = value ? "visible" : "hidden";
					return true;
				}
				]]></xml>;
				var results:String = ExternalInterface.call(string, editorIdentity, value);
			}
		}
		
		public static var events:Array;
		public static var eventsDictionary:Dictionary;
		public static var eventHandlerFunction:String;
		
		/**
		 * Adds an event listener to the editor
		 * */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			var editorEvent:Boolean;
			var dispatcher:String;
			
			if (!initialized) {
				//return;
			}
			
			if (events==null) {
				events = ClassUtils.getEventNames(this, true, UIComponent);
				events.splice(events.indexOf("editorReady"), 1);
				events.splice(events.indexOf("complete"), 1);
				events.push("copy");
				events.push("paste");
			}
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if (events.indexOf(type)==-1) {
				editorEvent = false;
				return;
			}
			
			dispatcher = eventsDictionary[type];
			
			if (dispatcher == null) {
				dispatcher = EDITOR;
			}
			
			if (isBrowser && useExternalInterface) {
				
				if (!aceEditorFound) {
					deferredEventHandlers[type] = listener;
					return;
				}
				//else {
				//	eventHandlers[type] = listener;
				//}
				
				var callbackName:String;
				var results:Object;
				var string:String;
				
				callbackName = editorIdentity + "_" + type;
				ExternalInterface.addCallback(callbackName, browserCallbackHandler);
				
				if (eventHandlerFunction) {
					string = eventHandlerFunction;
				}
				else {
					// if the application has issues it's because you are trying to pass
					// back an object with a circular reference
					// pass back simple objects
					// we use a basic circular reference function
					// to write your own define your own eventHandlerFunction
					string = <xml><![CDATA[
					function (id, objectId, dispatcherType, eventName, callbackName, debug) {
						var application = this[objectId];
						var editor = ace.edit(id);
						var dispatcher;
	
						if (dispatcherType=="editor") dispatcher = editor;
						else if (dispatcherType=="session") dispatcher = editor.session; 
						else if (dispatcherType=="selection") dispatcher = editor.session.selection;
	
						if (application.methodHandlers==null) { application.methodHandlers = {}; }
	
						application.methodHandlers[callbackName] = function(event, instance) {
							//console.log(event);                 (object, maxDepth, depth, objects, clone, debug)
							var clonedEvent;
							if (event.type!="mousemove") {
								clonedEvent = document.removeReferences(event, 1, null, null, true, debug);
							}
							else {
								clonedEvent = document.removeReferences(event, 0, null, null, true, debug);
							}

							try {
								//var isMethod = application[callbackName];
								application[callbackName](callbackName, clonedEvent);
							}
							catch (error) {
								console.log(error);
							}
						}

						dispatcher.on(eventName, application.methodHandlers[callbackName]);
						return true;
					}
					]]></xml>;
				}
				var jsDebug:Boolean = false;
				results = ExternalInterface.call(string, editorIdentity, ExternalInterface.objectID, dispatcher, type, callbackName, jsDebug);
			}
			else {
				if (editor==null) {
					deferredEventHandlers[type] = listener;
				}
				else {
					if (dispatcher==EDITOR) {
						editor.on(name, airCallbackHandler);
					}
					else if (dispatcher==SESSION) {
						editor.session.on(name, airCallbackHandler);
					}
					else if (dispatcher==SELECTION) {
						editor.session.selection.on(name, airCallbackHandler);
					}
				}
			}
		}
		
		/**
		 * Helper method for handling browser events 
		 * */
		public function airCallbackHandler(event:Object, editor:Object):void {
			var type:String = event.type;
			
			if (type==null && event.event!=null) {
				type = event.event.type;
			}
			else if (type==null && event.action) {
				type = "change";
			}
			
			//if (hasEventListener(type)) {
				var aceEvent:AceEvent = new AceEvent(type);
				aceEvent.data = event;
				dispatchEvent(aceEvent);
			//}
		}
		
		/**
		 * Helper method for handling browser events 
		 * */
		public function browserCallbackHandler(callbackName:String, event:Object):void {
			var type:String = callbackName.split("_")[1];
			
			//if (hasEventListener(type)) {
				var aceEvent:AceEvent = new AceEvent(type);
				aceEvent.data = event;
				dispatchEvent(aceEvent);
			//}
		}
		
		public static var scriptAdded:Boolean;
		public static var removeReferences:String = <xml><![CDATA[
function () {
				"use strict";
				
				// returns an object that removes circular references
				document.removeReferences = function (object, maxDepth, depth, objects, clone, debug) {
				  if (objects==null) { objects = []; }
				  if (clone==true) { clone = {}; }
				  maxDepth = maxDepth==null ? 10 : maxDepth;
				  depth = depth==null ? 0 : depth;
				  var padding = "";
                  var value;
				  
				  if (debug) { for (var i=0;i<depth;i++) { padding += "  "; } };
				
				  if (debug && typeof object != 'function') {
				    console.log(padding + "\nDepth:" + depth + " max depth:" + maxDepth);
				  }
				
				  if (typeof object == 'object') {
				    if (object!=null && objects.indexOf(object)==-1) {
				      if (debug) console.log(padding+"caching object:"+object);
				      objects.push(object);
				    }
				    else {
				      if (debug) console.log(padding+"object found. skipping");
				      return clone;
				    }
				
				    for (var key in object) {
				      value = object[key];
				
				      if (debug && typeof value!="function") {
				        console.log(padding+""+key + ":" + typeof value);
				      }
				
				      if (object.hasOwnProperty(key) && (typeof value == 'object')) {
				
				        // remove circular references
				        if (objects.indexOf(value)!=-1) {
				          if (debug) console.log(padding+"recursive object found. deleting:"+key);
				
				          if (clone==null) {
				            delete object[key];
				          }
				          else {
				            delete clone[key];
				          }
				          
				          continue;
				        }
				
				        if (depth>=maxDepth) {
				          //object[key] = null;
				
				          if (clone==null) {
				            if (debug) console.log(padding+"max object limit - deleting:"+key);
				            delete object[key];
				          }
				          else {
				
				            if (typeof value=="array") {
				              clone[key] = null;
				            }
				            else {
				              clone[key] = null;
				            }
				            delete clone[key];
				            if (debug) console.log(padding+"max object limit - not adding:"+key); 
				          }
				
				        }
				        else {
				
				          if (clone==null) {
				            if (value!=null) {
				              if (debug) console.log(padding+"diving into:"+key);
				              document.removeReferences(value, maxDepth, depth+1, objects, null, debug);
				            }
				          }
				          else {
				            if (typeof value=="array") {
				              clone[key] = value.slice();
				            }
				            else {
				              clone[key] = value!=null ? {} : null;
				            }
				
				            if (value!=null) {
				              if (debug) console.log(padding+"diving into:"+key);
				              document.removeReferences(value, maxDepth, depth+1, objects, clone[key], debug);
				            }
				          }
				        }
				      }
				      else if (typeof value == 'function') {
				          //object[key] = null;
				          if (clone==null) {
				            delete object[key];
				          }
				          else {
				            
				          }
				      }
				      else {
				
				        if (clone!=null) {
				          if (debug) console.log(padding+" cloning key :"+key);
				
				          if (typeof value=="array") {
				            clone[key] = value.slice();
				          }
				          else {
				            clone[key] = value!=null ? value : null;
				          }
				        }
				      }
				    }
				  }
				
				  if (clone!=null) {
				    if (debug) console.log(padding+"return clone");
				    return clone;
				  }
				
				  if (debug) console.log(padding+"return object");
				  return object;
				}
	return true;
}
				]]></xml>;
	}
}
