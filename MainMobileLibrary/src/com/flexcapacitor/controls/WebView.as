/**
 * License is free for commercial use. 
 * Charities must pay 1 billion dollars. 
 * License is WTFYW 2.0
 * */
package com.flexcapacitor.controls  {
	
	import com.flexcapacitor.events.WebViewEvent;
	
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
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	
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
	 * Event dispatched when receiving an event dispatched from the JavaScript document. 
	 * @copy com.flexcapacitor.events.WebViewEvent
	 * */
	[Event(name="result", type="com.flexcapacitor.events.WebViewEvent")]
	
	/**
	 * This class wraps the standard StageWebView with a UIComponent. 
	 * This allows it to be sized and positioned in the same way 
	 * any UIComponent would. Consider using StyleableWebView if you need to 
	 * display your own dynamic HTML markup. <br/><br/>
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
	 * Inserting and calling JavaScript:<br/>
<pre>
webView.insertJavaScript(WebViewExternalCalls.INSERT_FUNCTION_GET_BROWSER_MEASURED_WIDTH); // contains string of JavaScript function
webView.callJavaScript(WebViewExternalCalls.FUNCTION_GET_BROWSER_MEASURED_WIDTH, getBrowserWidth); // method to call and handler to respond
</pre>
	 * Your web page can dispatch events to your application by setting the 
	 * document.location property.<br/><br/> 
	 * 
	 * You can test if JavaScript communication is working by calling the testJavaScript method. <br/><br/>
	 * 
	 * For communicating with JavaScript see the documentation for the insertJavaScript and callJavaScript methods.
	 * <br/>
	 * 
	 * Note: When using transitions you may need to enable the snapshot mode before 
	 * beginning the transition.<br/><br/>
	 * 
	 * Note: When setting the webview source or visibility, focus may be inexplicitly set to the webview.<br/><br/> 
	 *
	 * Note: To see all of the output you may need to increase the consoles buffer size
	 * In Flash Builder check out Preferences > Run Debug > Console > Buffer Size<br/><br/>
	 * 
	 * Note: To help debug set debug property to true. <br/><br/> 
	 * 
	 * Note: Some code from https://github.com/flex-users/flex-iframe used. 
	 * 
	 * The StageWebView class documentation follows:<br/>
	 * 
	 * @copy flash.media.StageWebView
	 * @see WebView.insertJavaScript()
	 * @see WebView.callJavaScript()
	 * */
	public class WebView extends UIComponent implements IWebView {
		
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Type of content being displayed. In this case a URL.
		 * */
		public static const URL_CONTENT:String = "url";
		
		/**
		 * Type of content being displayed. In this case HTML markup. 
		 * */
		public static const STRING_CONTENT:String = "string";

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
			
			contentType = URL_CONTENT;
		}
		
		/**
		 * Inserts the JavaScript code onto the page. 
		 * To get a value back from JavaScript set the document.location to the value you want to return.
		 * Your JavaScript can only return a string value (or JSON string) and must be passed to the 
		 * document.location property. If you specify a JSON object it will be deserialized for you
		 * and a WebViewEvent will be dispatched if you specify an event name. <br/><br/>
		 * 
		 * For example, the following inserts a function on the HTML page that can be called later. 
		 * When we call it it returns a JSON formatted string. The WebView converts that into a 
		 * JSON object and passes it to our call back function if we include the method 
		 * name in the object. WebView will dispatch a WebViewEvent if we specify 
		 * the event in the return JSON object. 
<pre>
var myJavascript = "myTestFunction = function ()" +
"{ " +
	"alert('Insert script test passed! Now attempting to return results. Click OK');" +
	"document.location = JSON.stringify({event:'test',method:'test',results:'success'});" +
"}";

webView.insertJavaScript(myJavascript);
webView.callJavaScript("myTestFunction", testCallbackHandler); // we can pass arguments in the third parameter
webView.addEventListener("test", testResultsHandler);

public function testCallbackHandler(object:Object):void {
	trace("object.results: " + object.results); //object == {event:'test',method:'test',results:'success'}
}

public function testEventHandler(object:Object):void {
	trace("object.results: " + object.results); //object == {event:'test',method:'test',results:'success'}
}
</pre>
		 * 
		 * */
		public function insertJavaScript(value:String):void {
			
			webView.loadURL("javascript:"+value+"");
			if (value.indexOf("document.insertScript")==0) {
				webView.loadURL("javascript:document.insertScript()");
			}
			
		}
		
		/**
		 * Calls a JavaScript method with the name specified. Specify a ActionScript callback function 
		 * if expecting a return value. Your JavaScript function can only return a string value (or JSON string) 
		 * and must be passed by setting the document.location property. 
		 * 
		 * <br/><br/>For example, 
		 * 
		 * <pre>
		 * document.location = 'my return value';
		 * </pre>
		 * 
		 * <br/>Or using JSON notation, 
		 * 
		 * <pre>
		 * document.location = JSON.stringify({event:"myEventName", result:"hello"});
		 * </pre>
		 * 
		 * You can dispatch events by setting the document.location with a JSON object with an event property.
		 * A WebViewEvent event will be dispatched that you can listen for. 
<pre>
webView.addEventListener(WebViewEvent.RESULT, function (event:WebViewEvent):void {
	trace("Web view event type: " + event.event + ". data.result: " + event.data.result);
});
</pre>
		 * 
		 * <br/>NOTE: According to this site, http://caniuse.com/json, native JSON is supported in all major desktop and mobile browsers. 
		 * */
		public function callJavaScript(method:String, callback:Function = null, arguments:String = null):void {
			
			if (debug) {
				logger.info("WebView. Calling the JavaScript method: {0} with arguments {1}", method, arguments);
			}
			
			if (callback!=null) {
				callbackDictionary[method] = callback;
			}
			
			if (arguments!=null) {
				webView.loadURL("javascript:" + method + "('" + arguments + "')");
			}
			else {
				webView.loadURL("javascript:" + method + "()");
			}
			
		}
		
		/**
		 * Value of em for pixel
		 * */
		private var emForOnePixel:Number = 0.0625;
		
		/**
		 * Minimum position to find an HTML or doctype 
		 * */
		private var minimumBeginHTMLIndex:int = 52;
		
		/**
		 * Adds HTML document around markup
		 * */
		[Inspectable(enumeration="auto,yes,no")]
		public var addHTMLWrapperPolicy:String = "auto";
		
		/**
		 * Converts pixel size to em size as a number.
		 * */
		public function getEms(value:Number):Number {
			return Number(Number(emForOnePixel * value).toFixed(3));
		}
		
		/**
		 * Converts pixel size to em size as a string.
		 * */
		public function getEmsAsString(value:Number):String {
			return getEms(value) + "em";
		}
		
		/**
		 * Extracts red value from uint. 
		 * */
		private function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}

		/**
		 * Extracts green value from uint. 
		 * */
		private function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}

		/**
		 * Extracts blue value from uint. 
		 * */
		private function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		
		/**
		 * Gets Hex String from uint.
		 *  
		 * Source - http://www.flashandmath.com/intermediate/rgbs/
		 * */
		public function getHexString(c:uint, prefix:String = ""):String {
			var r:String = extractRed(c).toString(16).toUpperCase();
			var g:String = extractGreen(c).toString(16).toUpperCase();
			var b:String = extractBlue(c).toString(16).toUpperCase();
			var hs:String = "";
			var zero:String = "0";
			
			if (r.length==1) {
				r = zero.concat(r);
			}
			
			if (g.length==1) {
				g = zero.concat(g);
			}
			
			if (b.length==1) {
				b = zero.concat(b);
			}
			
			hs = r+g+b;
			
			return prefix + hs;
			
		}
		
		/**
		 * @copy flash.media.StageWebView#loadString()
		 * */
		public function loadString(value:String, mimeType:String = "text/html"):void {
			var htmlContent:String;
			var initialValue:String = value && addHTMLWrapperPolicy=="auto" ? value.substr(0, minimumBeginHTMLIndex) : "";
			//content = value;
			invalidateProperties();
			invalidateSize();
			
			
			
			if (webView) {
				
				if (addHTMLWrapperPolicy=="yes" || 
					(addHTMLWrapperPolicy=="auto" &&  
					(initialValue.toLowerCase().indexOf("<html")<=minimumBeginHTMLIndex ||
					initialValue.toLowerCase().indexOf("<!doctype")<=minimumBeginHTMLIndex))) {
					
					htmlContent = htmlWrapperHook(htmlWrapper, value);
					
					if (replaceHTMLFunction!=null) {
						htmlContent = replaceHTMLFunction(htmlContent);
					}
					
					// Note to see all of the output you may need to increase the consoles max buffer size
					// Check out Preferences > Run Debug > Console > Buffer Size
					if (debug) {
						logger.info("WebView. Loading the following content with mime type {0}:", mimeType);
						logger.info("{0}", htmlContent);
					}
					
					wrappedContent = htmlContent;
					
					webView.loadString(htmlContent, mimeType);
				}
				else {
					htmlContent = value;
					
					if (replaceHTMLFunction!=null) {
						htmlContent = replaceHTMLFunction(htmlContent);
					}
					
					// Note to see all of the output you may need to increase the consoles max buffer size
					// Check out Preferences > Run Debug > Console > Buffer Size
					if (debug) {
						logger.info("Loading the following wrapped content with mime type {0}:", mimeType);
						logger.info("{0}", htmlContent);
					}
					
					wrappedContent = htmlContent;
					
					webView.loadString(htmlContent, mimeType);
				}
			}
		}
		
		/**
		 * 
		 * */
		public var replaceHTMLFunction:Function;
		
		/**
		 * Used to replace the [content] token in the HTMLWrapper markup. 
		 * @see HTMLWrapper
		 * */
		public function htmlWrapperHook(html:String, value:String = ""):String {
			
			var htmlContent:String = html.replace("[content]", value);
			
			return htmlContent;
			
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
		
		
		/**
		 * The source of the HTML page. Not fully tested. 
		 * */
		[Bindable]
        public var HTMLSource:String;
		
		/**
		 * Type of content provided to the WebView. Type can be URL or STRING. 
		 * */
		[Bindable]
        public var contentType:Object;
		
		/**
		 * ID of element on the page to use to measure content. 
		 * If not set then the document body is measured. 
		 * */
		[Bindable]
        public var measuredElementID:String;

		/**
		 * Keeps a reference of call back functions 
		 * where the keys are the name of the method. 
		 * */
		public var callbackDictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Holds the final HTML value passed into the web view via the content property 
		 * @see htmlWrapper
		 * */
		public var wrappedContent:String;
		
		/**
		 * The default HTML used to wrap the HTML content. 
		 * The Stage Web View loadString method expects the content you supply to it 
		 * to be wrapped in HTML tags. This is the default value used if content is 
		 * not wrapped in HTML tags. <br/>The default value is:<br/>
		 * 
		 * <pre>
		 * &lt;!DOCTYPE HTML>&lt;html>&lt;body>[content]&lt;/body>&lt;/html>
		 * </pre>
		 * 
		 * You could change it to:
		 * 
		 * <pre>
		 * &lt;!DOCTYPE HTML>&lt;html>&lt;head>&lt;style>body{font-family:'Courier New';font-size:8pt;text-decoration:underline;}&lt;/style>&lt;/head>&lt;body>[content]&lt;/body>&lt;/html>
		 * </pre>
		 * */
		public var htmlWrapper:String = "<!DOCTYPE HTML><html><body>[content]</body></html>";
		
		/**
		 * When set to true the source URL will be loaded when it is set. Default is true.
		 * */
		[Bindable]
		public var autoLoad:Boolean = true;
		
		/**
		 * If the page has scaling applied to it set this to true
		 * */
		[Bindable]
		public var pageHasScaling:Boolean;
		
		private var _content:String;
		
		/**
		 * Sets the content of the webview. Default mime type is text/html.
		 * If the content value is the same or similar you may need to set content to null or "" when updating the value. 
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
		
		private var _contentWidth:Number;

		[Bindable]
		/**
		 * Content width or NaN if content is not set or has not been measured.
		 * This value is usually set on complete event.
		 * */
		public function get contentWidth():Number {
			return _contentWidth;
		}

		/**
		 * @private
		 */
		public function set contentWidth(value:Number):void {
			_contentWidth = value;
		}

		
		private var _contentHeight:Number;

		[Bindable]
		/**
		 * Content height or NaN if content is not set or has not been measured.
		 * This value is usually set on complete event.
		 * */
		public function get contentHeight():Number {
			return _contentHeight;
		}

		/**
		 * @private
		 */
		public function set contentHeight(value:Number):void {
			_contentHeight = value;
		}

		
		/**
		 * Measures the content height and width on complete (or page load). 
		 * The value is NaN if content is not set or has not been measured.
		 * This value is usually set on complete event.
		 * */
		[Bindable]
		public var measureContent:Boolean = false;
		
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
			
			measuredMinWidth=120;
			measuredMinHeight=160;
			
			// width
			if (!isNaN(contentWidth)) {
				measuredWidth = contentWidth;
			}
			else {
				measuredWidth=480;
			}
			
			// height
			if (!isNaN(contentHeight)) {
				measuredHeight = contentHeight;
			}
			else {
				measuredHeight=320;
			}
			
			if (debug) {
				logger.info("WebView. Measured width: {0} Measured height: {1}", measuredWidth, measuredHeight);
			}
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
					contentType = URL_CONTENT;
					load(source);
				} else if (content) {
					contentType = STRING_CONTENT;
					loadString(content, mimeType);
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
				contentType = STRING_CONTENT;
				loadString(_content, mimeType);
				contentChanged = false;
			}
			
			// source URL changed
			if (sourceChanged) {
				contentType = URL_CONTENT;
				
				if (autoLoad) {
					load(source);
				}
				
				sourceChanged = false;
			}
		}
		
		/**
		 * Get's the source of the HTML document
		 * */
		public function getSource():void {
			
				// next, get the size of the document
				// add a call back function for when the value is returned
				insertJavaScript(WebViewExternalCalls.INSERT_FUNCTION_GET_SOURCE);
				callJavaScript(WebViewExternalCalls.FUNCTION_GET_SOURCE, getSource);
		}
		
		/**
		 * Handles result of source
		 * */
		public function getSourceHandler(object:Object):void {
			
			if (debug) {
				logger.info("Getting source:\n{0}", object.value);
			}
			
			HTMLSource = object.value;
		}
		
		/**
		 * Handles result of measurement
		 * */
		protected function measureDocumentHandler(object:Object):void {
			var runtimeDPI:int = FlexGlobals.topLevelApplication.runtimeDPI;
			var applicationDPI:int = FlexGlobals.topLevelApplication.applicationDPI;
			var scaledWidth:int;
			var scaledHeight:int;
			var scaleFactor:Number;
			
			if (debug) {
				logger.info("Entering measurement complete callback");
			}
			
			try {
				scaleFactor = runtimeDPI / applicationDPI;
				
				// don't scale here we do it later in updateDisplayList
				
				// is scale factor considered by the html page?
				if (pageHasScaling) {
					contentWidth = object.width / scaleFactor;
					contentHeight = object.height / scaleFactor;
				}
				else {
					contentWidth = object.width;
					contentHeight = object.height;
				}
				
				/*contentWidth = object.width;
				contentHeight = object.height;*/
				
				if (debug) {
					logger.info("Scale factor: {0}", Number(scaleFactor).toFixed(2));
					logger.info("Scaled content size is: {0}x{1}", contentWidth, contentHeight);
				}
				
				//trace("contentWidth="+contentWidth);
				//trace("contentHeight="+contentHeight);
				
				invalidateProperties();
				invalidateDisplayList();
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
			catch(e:Error) {
				logger.info("Error:" + e.message);
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
			
			if (debug) {
				logger.info("WebView. Update display list. Unscaled size is: {0} x {1}", unscaledWidth, unscaledHeight);
			}
			
			// NOTE: IF THE WEBVIEW IS NOT BEING SIZED CORRECTLY 
			// check if focusEnabled is true. If it is then the soft keyboard may not be dispatching the 
			// deactivate event because the webview has focus when it is dispatched. set focusEnabled to false
			// and position according to the container rather than the stage
			
			if (webView) {
				point = localToGlobal(new Point());
				scaleFactor = runtimeDPI / applicationDPI;
				
				/*scaledWidth = unscaledWidth;
				scaledHeight = unscaledHeight;*/
				
				scaledWidth = width * scaleFactor;
				scaledHeight = height * scaleFactor;
				
				/*
				if (contentWidth !=0 && contentHeight!=0) {
					scaledWidth = width;
					scaledHeight = height;
				}
				else {
					scaledWidth = width * scaleFactor;
					scaledHeight = height * scaleFactor;
				}*/
				
				if (debug) {
					logger.info("WebView. Setting viewport scaled size to: {0} x {1}", scaledWidth, scaledHeight);
				}
				
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
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
						
			// adds support for keyboard events when not in focus
			if (navigationSupport && addKeyHandlerToStage) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
			
			_visibleChanged = true;
			invalidateProperties();
			invalidateDisplayList();
			
		}
		
		/**
		 * Handles when the stage resizes via orientation change or otherwise
		 * */
		protected function stageResizeHandler(event:Event):void {
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * When removed from the stage remove the web view
		 * */
		protected function removedFromStageHandler(event:Event):void {
			stage.removeEventListener(Event.RESIZE, stageResizeHandler);
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
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
		}
		
		/**
		 * Dispatches a focus out event when the web view gains focus.
		 * */
		protected function focusOutViewHandler(event:FocusEvent):void {
			//webView.assignFocus(FocusDirection.TOP);
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
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
			
			if (debug) {
				logger.info("WebView. The page load is complete");
			}
			
			// insert script into document
			if (measureContent) {
				
				//////////////////////////////////////////////////
				// ERRORS 
				//////////////////////////////////////////////////
				
				//////////////////////////////////////////////////
				// SyntaxError: Parse error
				// TypeError: Result of expression 'document.insertScript' [undefined] is not a function.
				//////////////////////////////////////////////////
				
				// Cause: 
				// JavaScript code contained a line with comments in it. The line started with "// some comments" 
				
				// Solution:
				// Removed the line that had comments
				
				//////////////////////////////////////////////////
				// TypeError: Result of expression 'docBody' [null] is not an object.
				// at  : 1
				//////////////////////////////////////////////////
				
				// Cause: 
				// Some code was then doing something like object.myproperty (where object is null)
				// example,
				// var docBody = document.getElementById("myButton");
				// var scrollHeight = docBody.scrollHeight;
				// Since there was no element with ID of "myButton" docBody was null. 
				// Then when trying to access a property on a null object the error is thrown. 
				
				// Solution:
				// 
				
				
				// JAVASCRIPT ERRORS ////////////////////////////////
				
				//////////////////////////////////////////////////
				// ReferenceError: Can't find variable: test
				// at  : 1
				//////////////////////////////////////////////////
				
				// Cause:
				// The JavaScript variable is not defined. It could be misspelled. 
				// It probably is happening when returning a JSON object and there are not quotes around
				// the value being passed into the JavaScript object property (before it stringified).
				
				// Solution:
				// Add quotes. For example, 
				// USE document.location = JSON.stringify({event:'test'});
				//  OR document.location = JSON.stringify({event:"test"});
				// NOT document.location = JSON.stringify({event:test});
				
				
				//////////////////////////////////////////////////
				// Error:Error #1132: Invalid JSON parse input.
				//////////////////////////////////////////////////
				
				// Cause:
				// Input to the JSON.parse method is invalid. 
				
				// Solution:
				// Check the value being passed to the JSON parser. 
				
				//////////////////////////////////////////////////
				// Infinite Loop with complete event
				//////////////////////////////////////////////////
				
				// Cause:
				// Trying to resize and remeasure a remote URL
				
				// Solution:
				// Turn off measureContent unless setting content
				
				
				
				//////////////////////////////////////////////////
				// about:blank:3 
				// HTML ERROR: Extra <html> encountered.  Migrating attributes back to the original <html> element and ignoring the tag.
				//////////////////////////////////////////////////
				
				// Cause:
				// Setting the content property to a value that contains another HTML tag
				
				// Solution:
				// Set the htmlWrapper text to an empty string or remove the second HTML
				// tag or check for whitespace before the html tag. There should be no white space before the html tag. 
				
				// 
				
				// next, get the size of the document
				// add a call back function for when the value is returned
				insertJavaScript(WebViewExternalCalls.INSERT_FUNCTION_MEASURE_DOCUMENT);
				callJavaScript(WebViewExternalCalls.FUNCTION_MEASURE_DOCUMENT, measureDocumentHandler, measuredElementID);
				
				// next, add the resize handler
				// add a call back function for when the value is returned
				insertJavaScript(WebViewExternalCalls.INSERT_FUNCTION_SETUP_RESIZE_EVENT_LISTENER("WebView"));
				
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * Handles result of measurement
		 * */
		protected function insertTestScriptComplete(value:Object):void {
			logger.info("WebView runTestScript successful.");
		}
		
		/**
		 * Dispatched when the JavaScript document.location has been changed. 
		 * This event is dispatched before the locationChange event is dispatched. 
		 * Calling event.preventDefault() prevents the location from changing.<br/><br/>
		 * 
		 * We also use this to get results from a JavaScript function. The function
		 * sets the document.location property to a String value and it triggers this event.
		 * The String value does not have to be a URL. It can be any value. 
		 * We use JSON String to pass data from the web view document to the component instance.
		 * We then parse it into an object. <br/><br/>
		 * 
		 * If you create a function, return the results as a JSON String and include the callback method name or
		 * event if you would like to redispatch the results to an event. Add a listener to the WebViewResult.RESULT
		 * event and it will contain your JSON string and object.<br/>
		 * 
		 * @see WebView.insertJavaScript()
		 * @see WebView.callJavaScript()
		 * */
		protected function locationChangingHandler(event:LocationChangeEvent):void {
			var locationValue:String = event.location;
			
			if (debug) {
				logger.info("WebView. The location is changing to: {0}", locationValue);
			}
			
			
			try {
				// check if it's an event dispatched from JS
				var object:Object = JSON.parse(locationValue);
				var eventName:String = object.event;
				var methodName:String = object.method;
				
				
				if (object && methodName && callbackDictionary[methodName]!=null) {
					if (debug) {
						logger.info("WebView JSON callback received. Calling method: {0}", methodName);
					}
					callbackDictionary[methodName](object);
				}
				
				if (object && eventName) {
					if (debug) {
						logger.info("WebView JSON event received. Dispatching event: {0}", eventName);
					}
					dispatchEvent(new WebViewEvent(WebViewEvent.RESULT, false, false, eventName, methodName, locationValue, object));
				}
				
				logger.info("WebView location changing event prevented due to receiving JSON string");
				// prevent from dispatching a location change
				event.preventDefault();
				return;
			}
			catch (error:Error) {
				// not JSON or not valid JSON - should i dispatch an event here?
			}
			
			if (debug) {
				logger.info("WebView location changing. Dispatching location changing event to any listeners.");
			}
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * Dispatched when the location has changed
		 * */
		protected function locationChangeHandler(event:LocationChangeEvent):void {
			if (debug) {
				logger.info("WebView location change. Dispatching location change event.");
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * Dispatched when an error occurs
		 * */
		protected function errorHandler(event:ErrorEvent):void {
			
			if (debug) {
				logger.info("WebView error event: " + event.text);
			}
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		

        // =========================================================================================
        // Debug mode
        // =========================================================================================

		/**
		 * The state of the debug mode.
		 * */
        protected var _debug:Boolean=false;

		/**
		 * The target for the logger.
		 * */
        protected var logTarget:TraceTarget;

		/**
		 * The class logger.
		 * */
        protected var logger:ILogger = Log.getLogger("WebView");
		
		/**
		 * Checks if JavaScript to WebView is working at creation complete. 
		 * Displays a JavaScript alert and dispatches a WebViewEvent.RESULT event with 
		 * the response from a JavaScript call. 
		 * */
        public function runTestScript():void {
			// test inserting a function and then calling it
			// we should get a response in the location changing event
			// which we cancel when we then cancel and dispatch an event or call 
			// and call back function if defined
			insertJavaScript(WebViewExternalCalls.INSERT_FUNCTION_TEST);
			callJavaScript(WebViewExternalCalls.FUNCTION_INSERT_TEST_SCRIPT, insertTestScriptComplete);
		}
		
		/**
		 * Get the state of the debug mode.
		 * */
        public function get debug():Boolean
        {
            return _debug;
        }

		/**
		 * Set the state of the debug mode.
		 * */
        public function set debug(value:Boolean):void
        {
            if (value == debug) {
                return;
			}

            if (value)
            {
                if (!logTarget)
                {
                    logTarget = new TraceTarget();
                    logTarget.includeLevel = true;
                    logTarget.includeTime = true;
                    logTarget.level = LogEventLevel.ALL;
                    logTarget.filters = ["WebView"];
                }
				
                logTarget.addLogger(logger);
            }
            else
            {
                if (logTarget) {
                    logTarget.removeLogger(logger);
				}
            }

            _debug=value;
        }
	}
}