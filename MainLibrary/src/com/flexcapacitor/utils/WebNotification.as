package com.flexcapacitor.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	/**
	 * Prompts the user with a notification in the browser
	 * 
	 * 
	 * Example usage:  
<pre>
import com.flexcapacitor.utils.WebNotification;

var supported:Boolean = WebNotification.isSupported();
var options:Object = {};
var prompt:Boolean = true;

if (supported) {
	WebNotification.showNotification("Hello world", options, prompt);
}

protected function checkPermissions_clickHandler(event:MouseEvent):void
{
	var supported:Boolean = WebNotification.isPermissionGranted();
	var permission:String = WebNotification.permission;
	var results:String = WebNotification.requestPermission();
	if (results=="false") {
		resultsInput.text = "Not supported";
	}
}
</pre>
	 * 
	 * In Safari permission is denied without prompt when running on the file sytem 
	 * When running on locahost notifications are supported
	 * 
	 * More info: https://developer.mozilla.org/en-US/docs/Web/API/notification
	 * */
	public class WebNotification extends EventDispatcher
	{
		public function WebNotification(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static var debug:String;
		
		/**
		 * Shows a notification if supported. 
		 * 
		 * @param notification Message to show in notification window
		 * @param options Options for notification
		 * @param prompt If set to true then prompts the user if permission is not granted
		 * */
		public static function showNotification(notification:String, options:Object = null, prompt:Boolean = true):void {
			
			// throw errors if our JS has errors
			ExternalInterface.marshallExceptions = true;
			
			var string:String = <xml><![CDATA[
				function(message, options, prompt) {
			
					if (!("Notification" in window)) {
						return false;
					}
					else if (Notification.permission === "granted") {
						var notification = new Notification(message, options);
						return true;
					}
					else if (Notification.permission !== 'denied' && prompt==true) {
						Notification.requestPermission(function (permission) {
	
							if (permission === "granted") {
								var notification = new Notification(message, options);
								return true;
							}
	
							return false;
						});
					}
			
					return false;
				}
			]]></xml>
			var success:Boolean = ExternalInterface.call(string, notification, options, debug);
		}
		
		public static function isSupported():Boolean {
			
			// throw errors if our JS has errors
			ExternalInterface.marshallExceptions = true;
			
			var string:String = <xml><![CDATA[
				function() {
			
				  if (!("Notification" in window)) {
					 return false;
				  }

				  return true;
				}
			]]></xml>

			var results:Boolean = ExternalInterface.call(string);
			return results;
		}
		
		/**
		 * Returns true if permission is granted
		 * */
		public static function isPermissionGranted():Boolean {
			
			var string:String = <xml><![CDATA[
				function() {
			
					if (!("Notification" in window)) {
						return false;
					}
					else if (Notification.permission === "granted") {
						return true;
					}
					
					return false;
				}
			]]></xml>
			var results:Boolean = ExternalInterface.call(string);
			return results;
		}
		
		/**
		 * Request permission. 
		 * */
		public static function requestPermission():String {
			
			var string:String = <xml><![CDATA[
				function() {
			
					if (!("Notification" in window)) {
						return false;
					}	

					if (Notification.permission !== 'denied') {
						Notification.requestPermission(function (permission) {
	
							if (permission === "granted") {
								var notification = new Notification(message, options);
								return permission;
							}

							return permission;
						});
					}

					return false;
				}
			]]></xml>
			var results:String = ExternalInterface.call(string);
			
			return results;
		}
		
		/**
		 * Get current permission status. 
		 * Known results can be "granted", "denied" or "false"
		 * A value of false means that Notifications feature was not found in the 
		 * current browser. Example, !("Notification" in window)
		 * */
		public static function get permission():String {
			
			var string:String = <xml><![CDATA[
				function() {
			
					if (!("Notification" in window)) {
						return false;
					}

					return Notification.permission;
				}
			]]></xml>
			var results:String = ExternalInterface.call(string);
			
			if (results=="false") {
				return "false";
			}
			
			return results;
		}
	}
}