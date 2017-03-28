package com.flexcapacitor.utils
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import mx.core.IMXMLObject;
	import mx.utils.Platform;
	
	/**
	 * Handles keyboard events 
	 * */
	public class HTMLKeyboardHandler extends EventDispatcher implements IMXMLObject {
		
		public function HTMLKeyboardHandler() {
			
		}
		
		
		public function initialized(document:Object, id:String):void {
			
			if (ExternalInterface.available) {
				preventSafariNavigate();
			}
		}
		
		/**
		 * Prevents undo in Safari from loading a previously open tab
		 * when a user presses Command+z or Command+Shift+z
		 * */
		public function preventSafariNavigate(prevent:Boolean = true):void {
			var isBrowser:Boolean = Platform.isBrowser;
			var isSafari:Boolean;
			
			if (ExternalInterface.available  && isBrowser) {
				//ExternalInterface.marshallExceptions = true;
				var string:String = <code><![CDATA[
				function (prevent) {
					var isSafari;
					var useCapture = true;
					const KEYTYPE = "keypress";

					if (navigator.vendor && navigator.vendor.indexOf('Apple') > -1 && 
						navigator.userAgent && !navigator.userAgent.match('CriOS')) {
						isSafari = true;
					}
					else {
						return true;
					}
					
					if (window.preventOpenOnUndoKey==null) {
						window.preventOpenOnUndoKey = function(event) {
							if (event.keyCode==122 && event.metaKey==true) {
								event.preventDefault();
							}
						}
					}
					
					if (prevent) {
						window.addEventListener(KEYTYPE, window.preventOpenOnUndoKey, useCapture);
					}
					else {
						window.removeEventListener(KEYTYPE, window.preventOpenOnUndoKey, useCapture);
					}

					return true;
				}
				]]></code>
				var results:Boolean = ExternalInterface.call(string, prevent);
			}
		}
	}
}