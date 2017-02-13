package com.flexcapacitor.utils
{
	import com.flexcapacitor.events.RedirectEvent;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import mx.core.IMXMLObject;
	
	/**
	 * Dispatched before redirecting to https
	 * */
	[Event(name="redirecting", type="com.flexcapacitor.events.RedirectEvent")]
	
	/**
	 * Dispatched when running on http
	 * */
	[Event(name="redirectionRecommendation", type="com.flexcapacitor.events.RedirectEvent")]
	
	/**
	 * Redirects from http to https protocol at startup
	 * */
	public class SecureRedirect extends EventDispatcher implements IMXMLObject {
		
		public function SecureRedirect() {
			
		}
		
		/**
		 * If set to true then the URL is performed automatically on the application initialized event
		 * */
		public var redirectAtStartup:Boolean = true;
		
		/**
		 * If set to true then redirect does not occur when running on localhost 
		 * */
		public var doNotRedirectFromUnsecuredLocalhost:Boolean = true;
		
		/**
		 * Path to localhost or allowed server
		 * */
		public var localhostPath:String = "localhost";
		
		public function initialized(document:Object, id:String):void {
			var redirectRecommended:Boolean;
			var redirectEvent:RedirectEvent;
			
			if (ExternalInterface.available) {
				redirectRecommended = redirectAvailable();
				
				if (redirectRecommended && redirectAtStartup) {
					redirectEvent = new RedirectEvent(RedirectEvent.REDIRECTING, false, true);
					dispatchEvent(redirectEvent);
					
					if (!redirectEvent.isDefaultPrevented()) {
						redirectToHTTPS();
					}
				}
				else if (hasEventListener(RedirectEvent.REDIRECTION_RECOMMENDATION)) {
					redirectEvent = new RedirectEvent(RedirectEvent.REDIRECTION_RECOMMENDATION, false, true);
					redirectEvent.redirectRecommended = redirectRecommended;
					dispatchEvent(redirectEvent);
				}
			}
		}
		
		/**
		 * Redirects to https
		 * */
		public function redirectToHTTPS():void {
			if (ExternalInterface.available) {
				var string:String = <code><![CDATA[
				function () {
					var isHTTPS = document.location.protocol.toLowerCase() == "https:";
					if (isHTTPS==false) {
						document.location.href = document.location.href.replace("http:", "https:");
					}
					return true;
				}
				]]></code>
				var results:Boolean = ExternalInterface.call(string);
			}
		}
		
		/**
		 * Returns true if we should redirect. If on localhost, you may want to skip 
		 * https. In that case set allow unsecured localhost to true.  
		 * 
		 * In other words, if this function returns true then you are on an unsecure channel on your server
		 * and should redirect to https. 
		 * */
		public function redirectAvailable():Boolean {
			//var isURLInaccessible:Boolean = isURLInaccessible;
			//var displayObject:DisplayObject = new Sprite();
			//var url:String = displayObject.loaderInfo!=null ? displayObject.loaderInfo.url;
			
			if (ExternalInterface.available) {
				var string:String = <code><![CDATA[
				function (localhost, doNotRedirectFromUnsecuredLocalhost) {
					var isFileSystem = document.location.protocol.toLowerCase() == "file:";
					var isHTTP = document.location.protocol.toLowerCase() == "http:";
					var isLocalhost = document.location.host.toLowerCase().indexOf(localhost)!=-1;
					
					if (isHTTP) {
						if (isLocalhost) {
							if (doNotRedirectFromUnsecuredLocalhost) {
								return false; // don't redirect
							}
						}
						
						return true;
					}
					
					return false;
				}
				]]></code>;
				
				var results:Boolean = ExternalInterface.call(string, localhostPath, doNotRedirectFromUnsecuredLocalhost);
			}
			
			return results;
		}
		
		
	}
}