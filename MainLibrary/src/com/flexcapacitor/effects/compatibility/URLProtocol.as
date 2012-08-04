

package com.flexcapacitor.effects.compatibility {
	
	import com.flexcapacitor.effects.compatibility.supportClasses.URLProtocolInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when the protocol is not defined.
	 * */
	[Event(name="protocolNotFound", type="flash.events.Event")]
	
	/**
	 * Plays a different effect depending on protocol type
	 * */
	public class URLProtocol extends ActionEffect {
		
		/**
		 * Event name constant when the protocol is not found.
		 * */
		public static const PROTOCOL_NOT_FOUND:String = "protocolNotFound";
		
		
		/**
		 *  Constructor.
		 * */
		public function URLProtocol(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = URLProtocolInstance;
			
		}
		
		/**
		 * URL to use. If not specified then the current loader URL is used.
		 * */
		[Bindable]
		public var URL:String;
		
		/**
		 * Name of protocol to check for
		 * */
		[Inspectable(enumeration="http,https,file,ftp,ssh,imap,pop3,tcp,udp,rtmp,rtmpt,*")]
		public var protocol:String;
		
		/**
		 * Effect that is played if defined if protocol is http.
		 * */
		public var httpEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is https.
		 * */
		public var httpsEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is file.
		 * */
		public var fileEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is ftp.
		 * */
		public var ftpEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is ssh.
		 * */
		public var sshEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is tcp.
		 * */
		public var tcpEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is udp.
		 * */
		public var udpEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is pop3.
		 * */
		public var pop3Effect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is imap.
		 * */
		public var imapEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is rtmp.
		 * */
		public var rtmpEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is rtmpt.
		 * */
		public var rtmptEffect:Effect;
		
		/**
		 * Effect that is played if defined if protocol is not found.
		 * */
		public var protocolNotFoundEffect:Effect;
		
		
	}
}