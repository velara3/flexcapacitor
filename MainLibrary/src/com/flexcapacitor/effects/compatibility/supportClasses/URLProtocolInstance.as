

package com.flexcapacitor.effects.compatibility.supportClasses {
	
	import com.flexcapacitor.effects.compatibility.URLProtocol;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.managers.SystemManager;
	import mx.utils.URLUtil;

	/**
	 * @copy URLProtocol
	 * */  
	public class URLProtocolInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function URLProtocolInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play(); // dispatch startEffect
			
			var action:URLProtocol = URLProtocol(effect);
			var protocol:String = action.protocol;
			var protocolFound:Boolean = true;
			var currentProtocol:String;
			var url:String = action.URL;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (protocol) {
					throw new Error("The protocol is not defined.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// get url protocol
			if (!url) {
				url = SystemManager.getSWFRoot(this).loaderInfo.url;
			}
			
			currentProtocol = URLUtil.getProtocol(url);
			
			
			switch (currentProtocol) {
				
				case "http": {
					if (action.httpEffect) playEffect(action.httpEffect);
					break;
				}
				case "https": {
					if (action.httpsEffect) playEffect(action.httpsEffect);
					break;
				}
				case "file": {
					if (action.fileEffect) playEffect(action.fileEffect);
					break;
				}
				case "rtmp": {
					if (action.rtmpEffect) playEffect(action.rtmpEffect);
					break;
				}
				case "rtmpt": {
					if (action.rtmptEffect) playEffect(action.rtmptEffect);
					break;
				}
				case "ftp": {
					if (action.ftpEffect) playEffect(action.ftpEffect);
					break;
				}
				case "ssh": {
					if (action.sshEffect) playEffect(action.sshEffect);
					break;
				}
				case "imap": {
					if (action.imapEffect) playEffect(action.imapEffect);
					break;
				}
				case "pop3": {
					if (action.pop3Effect) playEffect(action.pop3Effect);
					break;
				}
				case "tcp": {
					if (action.tcpEffect) playEffect(action.tcpEffect);
					break;
				}
				case "udp": {
					if (action.udpEffect) playEffect(action.udpEffect);
					break;
				}
				default: {
					protocolFound = false;
					break;
				}
			}
			
			// check if the class is found
			if (!protocolFound) {
				
				if (action.hasEventListener(URLProtocol.PROTOCOL_NOT_FOUND)) {
					action.dispatchEvent(new Event(URLProtocol.PROTOCOL_NOT_FOUND));
				}
				
				if (action.protocolNotFoundEffect) { 
					playEffect(action.protocolNotFoundEffect);
				}
				
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
	
	
}