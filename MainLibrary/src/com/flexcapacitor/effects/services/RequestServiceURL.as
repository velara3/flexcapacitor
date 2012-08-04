

package com.flexcapacitor.effects.services {
	
	import com.flexcapacitor.effects.services.supportClasses.RequestServiceURLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	/**
	 * @copy mx.rpc.events.ResultEvent.RESULT 
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @copy mx.rpc.events.ResultEvent.RESULT 
	 */
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	/**
	 * @copy mx.rpc.events.FaultEvent.FAULT 
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	/**
	 * @copy mx.rpc.events.InvokeEvent.INVOKE 
	 */
	[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]
	
	[ResourceBundle("rpc")]
	
	/**
	 * This is a wrapper around the HTTPService class. Description below.
	 * 
	 * @copy mx.rpc.http.HTTPService
	 *  
	 * */
	public class RequestServiceURL extends ActionEffect {
		
		public static const RESULT_EVENT:String = "resultEvent";
		public static const FAULT_EVENT:String = "faultEvent";
		
		/**
		 *  Constructor.
		 * */
		public function RequestServiceURL(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = RequestServiceURLInstance;
		}
	
		
		/**
		 * Request being submitted
		 * @copy mx.rpc.http.HTTPService#request
		 * */
		public var request:Object;
		
		/**
		 * Form submission type. Default value is post.
		 * @copy mx.rpc.http.HTTPService#method
		 * */
		[Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete", defaultValue="GET", category="General")]
		public var method:String = "post";
		
		/**
		 * URL to submit form to
		 * @copy mx.rpc.http.HTTPService.url
		 * */
		public var url:String;
		
		/**
		 * The result data returned from the server
		 * */
		[Bindable]
		public var data:Object = new Object();
		
		/**
		 * HTTPService used to to make service calls
		 * @copy mx.rpc.http.HTTPService
		 * */
		public var service:HTTPService;
		
		/**
		 * Effect to run when a service fault is generated.
		 * Cancels the effect.
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Effect to run when a service result is generated.
		 * This is optional. You can define effects to run or 
		 * or else let the effect sequence continue on to the next effect
		 * */
		public var resultEffect:IEffect;
		
		/**
		 * @copy mx.rpc.http.HTTPService#resultFormat
		 * */
		[Inspectable(enumeration="object,array,xml,flashvars,text,e4x", defaultValue="object", category="General")]
		public var resultFormat:String;
		
		/**
		 * Traces the request to the console
		 * */
		public var inspectRequest:Boolean;
		
		/**
		 * Traces the result to the console
		 * */
		public var inspectResult:Boolean;
		
		/**
		 * Contains reference to the fault event if one is generated.
		 * */
		public var faultEvent:FaultEvent;
		
		/**
		 * Contains reference to the result event if one is generated.
		 * */
		public var resultEvent:ResultEvent;
		
		/**
		 * Traces the data object to the console
		 * */
		public var inspectData:Boolean;
		
		/**
		 * @copy mx.rpc.http.HTTPService#useProxy
		 * */
		public var useProxy:Boolean;
		
		/**
		 * @copy mx.rpc.http.HTTPService#contentType
		 * */
		[Inspectable(enumeration="application/x-www-form-urlencoded,application/xml", defaultValue="application/x-www-form-urlencoded", category="General")]
		public var contentType:String = "application/x-www-form-urlencoded";
		
	}
}