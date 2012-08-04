/**
 * License is free for commercial use. 
 * Charities must pay 1 billion dollars. 
 * License is WTFYW 2.0
 * */
package com.flexcapacitor.controls  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.LocationChangeEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	/**
	 * @copy flash.media.StageWebView#ErrorEvent.ERROR
	 * */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * @copy flash.media.StageWebView#Event.COMPLETE
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @copy flash.media.StageWebView#LocationChangeEvent.LOCATION_CHANGING
	 * */
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	
	/**
	 * @copy flash.media.StageWebView#LocationChangeEvent.LOCATION_CHANGE
	 * */
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]
	
	/**
	 * This class wraps the standard StageWebView with a UIComponent. 
	 * This allows it to be sized and positioned in the same way 
	 * any UIComponent would. <br/><br/>
	 * 
	 * It also adds a snap shot mode that takes a snapshot of
	 * the current contents of the StageWebView. This snapshot is non-interactive.
	 * The reason for this is because the StageWebView is an instance 
	 * of the native browser of the device and OS. When visible it will 
	 * cover any other object in the application. Turning on snapshot mode
	 * creates and shows a bitmap of the StageWebView and hides the actual StageWebView. 
	 * This allows it to appear as part of the application where other display objects can cover it.
	 * 
	 * <br/><br/>
	 * It also adds the content property (wraps markup in the required HTML tag if it is not already)
	 * etc<br/><br/>
	 * 
	 * To use,<br/><br/>
	 *
	 * Loading a URL:<br/>
	 * &lt;local:WebView source="http://google.com/" width="400" height="300"/&gt;<br/><br/>
	 *
	 * Loading HTML text:<br/>
	 * &lt;local:WebView content="&lt;html&gt;...&lt;/html&gt;" width="400" height="300"/&gt;<br/>
	 * &lt;local:WebView content="&lt;b&gt;Hello World&lt;/b&gt;" width="400" height="300"/&gt;<br/><br/>
	 * 
	 * Note: When using transitions you may need to enable the snapshot mode before 
	 * beginning the transition.<br/><br/>
	 * 
	 * Note: When setting the webview source or visibility, focus may be inexplicitly set to the webview.<br/><br/> 
	 *
	 * The StageWebView class documentation follows:<br/>
	 * 
	 * @copy flash.media.StageWebView
	 * */
	public class WebView extends UIComponent {
		
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @copy flash.media.StageWebView#assignFocus()
		 * */
		public function assignFocus(direction:String = "none"):void {
			webView.assignFocus(direction);
		}
		
		/**
		 *  @copy flash.media.StageWebView#dispose()
		 * */
		public function dispose():void {
			webView.dispose();
		}
		
		/**
		 * Hides the web view
		 * 
		 *  @see flash.media.StageWebView#stage
		 * */
		public function hideWebView():void {
			webView.stage = null;
		}
		
		/**
		 * Displays the web view
		 * 
		 *  @see flash.media.StageWebView#stage
		 * */
		public function showWebView():void {
			webView.stage = stage;
		}
		
		/**
		 * Load the URL passed in or load the URL specified in the source property
		 * 
		 *  @see flash.media.StageWebView#loadURL()
		 * */
		public function load(URL:String = ""):void {
			
			if (URL) {
				webView.loadURL(URL);
				_source = URL;
			}
			else if (source) {
				webView.loadURL(source);
			}
		}
		
		/**
		 * @copy flash.media.StageWebView#loadString()
		 * */
		public function loadString(value:String, mimeType:String = "text/html"):void {
			content = value;
			
			if (webView) {
				if (value && value.indexOf("<html")>=0) {
					webView.loadString(value, mimeType);
				}
				else {
					wrappedContent = htmlWrapper.replace("[content]", value || "");
					webView.loadString(wrappedContent, mimeType);
				}
			}
			
		}
		
		/**
		 * @copy flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function drawViewPortToBitmapData(bitmap:BitmapData):void {
			webView.drawViewPortToBitmapData(bitmap);
		}
		
		/**
		 * Creates a snapshot of the Stage Web View at the point of this call 
		 * and displays that instead of the actual Stage Web View. 
		 * Use removeSnapshot to dispose of the snapshot and show the web contents again. 
		 * 
		 * @see isSnapshotVisible
		 * @see flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function takeSnapshot():BitmapData {
			destroySnapshot();
			snapshotBitmapData = new BitmapData(unscaledWidth, unscaledHeight);
			webView.drawViewPortToBitmapData(snapshotBitmapData);
			webViewBitmap = new Bitmap(snapshotBitmapData);
			addChild(webViewBitmap);
			hideWebView();
			isSnapshotVisible = true;
			
			return snapshotBitmapData;
		}
		
		/**
		 * Removes the bitmap snapshot of the Stage Web View from the display list 
		 * and displays the actual Stage Web View.
		 * @copy flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function removeSnapshot():void {
			destroySnapshot();
			showWebView();
		}
		
		/**
		 * Removes the web view snapshot from the display list and disposes of the 
		 * bitmap data
		 * */
		private function destroySnapshot():void {
			if (webViewBitmap) {
				if (webViewBitmap.parent) removeChild(webViewBitmap);
				if (webViewBitmap.bitmapData) webViewBitmap.bitmapData.dispose();
				webViewBitmap = null;
			}
			
			if (snapshotBitmapData) {
				snapshotBitmapData.dispose();
				snapshotBitmapData = null;
			}
			
			isSnapshotVisible = false;
		}
		
		
		/**
		 * @copy flash.media.StageWebView#historyBack()
		 * */
		public function historyBack():void {
			webView.historyBack();
		}
		
		/**
		 * @copy flash.media.StageWebView#historyForward()
		 * */
		public function historyForward():void {
			webView.historyForward();
		}
		
		
		/**
		 * @copy flash.media.StageWebView#reload()
		 * */
		public function reload():void {
			webView.reload();
		}
		
		
		/**
		 * @copy flash.media.StageWebView#historyForward()
		 * */
		public function stop():void {
			webView.stop();
		}
		
		/**
		 * Gets the correct path to the local directory. Example code posted by Mike Chambers
		 * If the URL is incorrect (pointing to no page) then neither the location changing nor the 
		 * change event are fired (in my tests).
		 * Example, webView.source = WebView.getLocalPath("app:/welcome.html");
		 * */
		public static function getLocalPath(page:String):String {
			return new File(new File(page).nativePath).url;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Wrapper for StageWebView
		 * 
		 *  @copy flash.media.StageWebView
		 */
		public function WebView() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			focusEnabled = false;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		private var wrappedContent:String;
		
		/**
		 * The default HTML used to wrap the HTML content. 
		 * The Stage Web View loadString method expects the content you supply to it 
		 * to be wrapped in HTML tags. This is the default value used if content is 
		 * not wrapped in HTML tags.
		 * */
		public var htmlWrapper:String = "<!DOCTYPE HTML><html><body>[content]</body></html>";
		
		/**
		 * When set to true the source URL will be loaded when it is set. Default is true.
		 * */
		[Bindable]
		public var autoLoad:Boolean = true;
		
		private var _content:String;
		
		/**
		 * Sets the content of the webview. Default mime type is text/html.
		 * */
		[Bindable]
		public function set content(value:String):void {
	
			_content = value;
			contentChanged = true;
			invalidateProperties();
			invalidateSize();
			
		}
		
		public function get content():String {
			return _content;
		}
		
		/**
		 * Flag indicating if a snapshot is being shown
		 * */
		[Bindable]
		public var isSnapshotVisible:Boolean;
		
		/**
		 * When calling takeSnapshot or setting snapshotMode to true this 
		 * property will contain the bitmap data of the view port. 
		 * */
		public var snapshotBitmapData:BitmapData;
		
		/**
		 * When calling takeSnapshot or setting snapshotMode a snapshot of 
		 * the Stage Web View is taken and added to the stage. This is a
		 * reference to the displayed bitmap. 
		 * */
		public var webViewBitmap:Bitmap;
		
		/**
		 * @private
		 * */
		public function get snapshotMode():Boolean {
			return isSnapshotVisible;
		}
		
		/**
		 * When set to true hides the stage web view and displays a non-interactive 
		 * snapshot of the Stage Web View when the property was set to true.  
		 * */
		public function set snapshotMode(value:Boolean):void {
			value ? takeSnapshot() : removeSnapshot();
		}
		
		private var _webView:StageWebView;
		
		/**
		 * @private
		 * */
		public function get webView():StageWebView {
			return _webView;
		}
		
		/**
		 * @copy flash.media.StageWebView
		 * */
		[Bindable]
		public function set webView(value:StageWebView):void {
			_webView = value;
			
			if (!_webView.stage && stage) {
				_webView.stage = stage;
			}
		}
		
		
		private var _source:String;
		
		/**
		 * @private
		 * */
		public function get source():String {
			return _source;
		}
		
		/**
		 * Source URL for stage web view. If autoLoad is set to true then the URL is loaded automatically.
		 * If not use load method to load the source URL
		 * 
		 * @see flash.media.StageWebView#loadURL()
		 * */
		[Bindable]
		public function set source(value:String):void {
			_source = value;
			sourceChanged = true;
			invalidateProperties();
			invalidateSize();
			
		}
		
		private var _visibleChanged:Boolean;
		
		override public function get visible():Boolean {
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = value;
			_visibleChanged = true;
			invalidateProperties();
			invalidateSize();
		}
		
		
		/**
		 * If enabled adds support for the back and search keys. 
		 * Back key navigates back in web view history and search navigates forward.
		 * */
		public var navigationSupport:Boolean;
		
		/**
		 * If enabled adds a keyboard listener to the stage.
		 * This handles when the component does not have focus
		 * */
		public var addKeyHandlerToStage:Boolean;
		
		/**
		 * KeyCode to use when navigation support is enabled.
		 * Default is Keyboard.BACK
		 * */
		public var backKeyCode:int = Keyboard.BACK;
		
		/**
		 * KeyCode to use when navigation support is enabled.
		 * Default is Keyboard.SEARCH
		 * */
		public var forwardKeyCode:int = Keyboard.SEARCH;
		
		private var contentChanged:Boolean;
		private var _mimeType:String = "text/html";
		private var sourceChanged:Boolean;
		
		/**
		 * MIME type of the web view content. Default is "text/html"
		 * @see flash.media.StageWebView#loadString()
		 * */
		public function get mimeType():String {
			return _mimeType;
		}
		
		/**
		 * @private
		 */
		public function set mimeType(value:String):void {
			_mimeType = value;
		}
		
		/**
		 * @copy flash.media.StageWebView#viewPort
		 * */
		public function get viewPort():Rectangle { 
			return webView ? webView.viewPort : null; 
		}
		
		/**
		 * @copy flash.media.StageWebView#title
		 * */
		public function get title():String {
			return webView ? webView.title : null;
		}
		
		/**
		 * @copy flash.media.StageWebView#isHistoryBackEnabled()
		 * */
		public function get isHistoryBackEnabled():Boolean {
			return webView ? webView.isHistoryBackEnabled : false;
		}
		
		/**
		 * @copy flash.media.StageWebView#isHistoryForwardEnabled()
		 * */
		public function get isHistoryForwardEnabled():Boolean {
			return webView ? webView.isHistoryForwardEnabled : false;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @copy mx.core.UIComponent#measure()
		 * */
		override protected function measure():void {
			super.measure();
			
			measuredWidth=480;
			measuredMinWidth=120;
			measuredHeight=320;
			measuredMinHeight=160;
		}
		
		/**
		 * @copy mx.core.UIComponent#createChildren()
		 * */
		override protected function createChildren():void {
			super.createChildren();
		}
		
		
		/**
		 * @copy mx.core.UIComponent#commitProperties()
		 * */
		override protected function commitProperties():void {
			super.commitProperties();
			
			// create webview
			if (!webView) {
				webView = new StageWebView();
				webView.addEventListener(Event.COMPLETE, completeHandler);
				webView.addEventListener(ErrorEvent.ERROR, errorHandler);
				webView.addEventListener(FocusEvent.FOCUS_IN, focusInViewHandler);
				webView.addEventListener(FocusEvent.FOCUS_OUT, focusOutViewHandler);
				webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, locationChangingHandler);
				webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChangeHandler);
				
				// load URL or text if available
				if (autoLoad && source) {
					webView.loadURL(source);
				} else if (content) {
					webView.loadString(content, mimeType);
				}
			}
			
			// visibility
			if (_visibleChanged) {
				if (snapshotMode) {
					//value ? takeSnapshot() : removeSnapshot();
					if (webView) webView.stage = null;
				}
				else {
					
					if (webView) {
						webView.stage = visible ? stage : null;
					}
				}
				_visibleChanged = false;
			}
			
			// content changed
			if (contentChanged) {
				if (_content && _content.indexOf("<html")>=0) {
					webView.loadString(_content, mimeType);
				}
				else {
					wrappedContent = htmlWrapper.replace("[content]", _content || "");
					webView.loadString(wrappedContent, mimeType);
				}
				contentChanged = false;
			}
			
			// source URL changed
			if (sourceChanged) {
				if (autoLoad) {
					webView.loadURL(source);
				}
				sourceChanged = false;
			}
		}
		
		
		
		/**
		 * @copy mx.core.UIComponent#updateDisplayList()
		 * */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var runtimeDPI:int = FlexGlobals.topLevelApplication.runtimeDPI;
			var applicationDPI:int = FlexGlobals.topLevelApplication.applicationDPI;
			var point:Point;
			var scaledWidth:int;
			var scaledHeight:int;
			var scaleFactor:Number;
			var scaledY:int;
			
			
			// NOTE: IF THE WEBVIEW IS NOT BEING SIZED CORRECTLY 
			// check if focusEnabled is true. If it is then the soft keyboard may not be dispatching the 
			// deactivate event because the webview has focus when it is dispatched. set to false
			// position according to the container rather than the stage
			if (webView) {
				point = localToGlobal(new Point());
				scaleFactor = runtimeDPI / applicationDPI;
				
				scaledWidth = width * scaleFactor;
				scaledHeight = height * scaleFactor;
				
				webView.viewPort = new Rectangle(point.x, point.y, scaledWidth, scaledHeight);
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the stage property is available add it to the web view
		 * */
		public function addedToStageHandler(event:Event):void {
			
			// adds support for keyboard events when not in focus
			if (navigationSupport && addKeyHandlerToStage) {
				stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
			
			_visibleChanged = true;
			invalidateProperties();
			invalidateDisplayList();
			
		}
		
		/**
		 * When removed from the stage remove the web view
		 * */
		protected function removedFromStageHandler(event:Event):void {
			destroySnapshot();
			hideWebView();
			
			// removes support for keyboard events when not in focus
			if (navigationSupport && addKeyHandlerToStage) stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
		}
		
		/**
		 * Dispatches a focus in event when the web view gains focus.
		 * */
		protected function focusInViewHandler(event:FocusEvent):void {
			//webView.assignFocus();
			
			if (hasEventListener(event.type)) 
				dispatchEvent(event);
			
		}
		
		/**
		 * Dispatches a focus out event when the web view gains focus.
		 * */
		protected function focusOutViewHandler(event:FocusEvent):void {
			//webView.assignFocus(FocusDirection.TOP);
			
			if (hasEventListener(event.type)) 
				dispatchEvent(event);
		}
		
		/**
		 * Dispatches a focus in event when the web view gains focus.
		 * */
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
			if (navigationSupport) {
				if (event.keyCode == backKeyCode && webView.isHistoryBackEnabled ) {
					webView.historyBack();
					event.preventDefault();
				}
				
				if (navigationSupport && event.keyCode == forwardKeyCode && webView.isHistoryForwardEnabled ) {
					webView.historyForward();
				}
			}
			
			super.keyDownHandler(event);
		}
		
		
		/**
		 * Dispatched when the page or web content has been fully loaded
		 * */
		protected function completeHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location is about to change
		 * */
		protected function locationChangingHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location has changed
		 * */
		protected function locationChangeHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when an error occurs
		 * */
		protected function errorHandler(event:ErrorEvent):void {
			
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
	}
}