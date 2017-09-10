package com.flexcapacitor.utils
{
	import com.flexcapacitor.events.RedirectEvent;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import mx.core.IMXMLObject;
	
	/**
	 * Dispatched before redirecting. Not implemented yet. 
	 * */
	[Event(name="redirecting", type="com.flexcapacitor.events.RedirectEvent")]
	
	/**
	 * When enabled shows a prompt to the user before they navigate away from the page.
	 * Note: In some browsers the user must interact with the page or give it focus for the event 
	 * to be dispatched. 
	 * */
	public class PreventRedirect extends EventDispatcher implements IMXMLObject {
		
		public function PreventRedirect() {
			
		}
		
		private var _enabled:Boolean = true;
		
		private var _message:String = "Are you sure you want to navigate away from this page?";
		
		/**
		 * Path to localhost or allowed server. Default is "localhost"
		 * */
		public var localhostPath:String = "localhost";
		
		/**
		 * Message to display in prompt before redirect
		 * */
		public function get message():String {
			return _message;
		}

		/**
		 * @private
		 */
		public function set message(value:String):void {
			if (_message==value) return; 
			_message = value;
			setHandler(enabled);
		}

		/**
		 * If true then displays prompt upon navigation. If false no prompt is shown
		 * */
		public function get enabled():Boolean{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void {
			if (_enabled==value) return; 
			_enabled = value;
			setHandler(enabled);
		}

		public function initialized(document:Object, id:String):void {
			var redirectEvent:RedirectEvent;
			
			if (ExternalInterface.available) {
				setHandler(enabled);
			}
		}
		
		/**
		 * Show prompt before page unload
		 * */
		public function setHandler(enabled:Boolean = true):void {
			var callbackName:String;
			var type:String = "onbeforeunload";
			
			if (ExternalInterface.available) {
				callbackName = type + "_" + type;
				
				if (enabled && hasEventListener("redirecting")) {
					ExternalInterface.addCallback(callbackName, onBeforeUnloadHandler);
				}
				else {
					ExternalInterface.addCallback(callbackName, null);
				}
				
				var string:String = <code><![CDATA[
				function (id, enabled, message, callback) {
					'use strict';
					var application = document.getElementById(id);
					//var application = swfobject.getObjectById(id);

					if (application!=null && application.onbeforeunload_handler!=null) {
						//window.removeEventListener("onbeforeunload", application.onbeforeunload_handler);
						window.onbeforeunload = null;
						//console.log("removing listener!");
					}

					if (application!=null && application.onbeforeunload_handler==null) {
						var beforeUnloadHandler = function () {
							//var isDebug = window.location.search.substr(1).indexOf("debug=true");
							var defaultPrevented = false;

							if (callback!=null && application[callback]!=null) {
								defaultPrevented = application[callback]("redirect");
							}
							
							if (defaultPrevented) {
								// prevent prompt from showing and navigate without interruption
								return null;
							}
							else {
								return false;
							}

							// if not debugging prompt before navigation
							//if (isDebug==-1) {
							//	return false;
							//}
						}

						application.onbeforeunload_handler = beforeUnloadHandler;
					}
					
					if (enabled && application!=null) {
						//window.addEventListener("onbeforeunload", application.onbeforeunload_handler);
						window.onbeforeunload = application.onbeforeunload_handler;
						//console.log("adding listener!");
					}

					if (application!=null) {
						//console.log("app found");
					}
					else {
						//console.log("app not found");
					}

					return true;
				}
				]]></code>
				var results:Boolean = ExternalInterface.call(string, ExternalInterface.objectID, enabled, message, callbackName);
			}
		}
		
		/**
		 * Handler called on redirect event
		 **/
		protected function onBeforeUnloadHandler(event:Object):Boolean {
			var redirectEvent:RedirectEvent;
			
			redirectEvent = new RedirectEvent(RedirectEvent.REDIRECTING, false, true);
			dispatchEvent(redirectEvent);
			
			return redirectEvent.isDefaultPrevented();
		}
		
	}
}