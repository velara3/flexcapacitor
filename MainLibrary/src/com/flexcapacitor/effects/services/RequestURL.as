

package com.flexcapacitor.effects.services {
	
	import com.flexcapacitor.effects.services.supportClasses.RequestURLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	
	[Event(name="securityErrorEvent", type="flash.events.SecurityErrorEvent")]
	[Event(name="ioErrorEvent", type="flash.events.IOErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	
	/** 
	 * Uses the URLLoader to load in a URL
	 * NOT COMPLETE
	 * */
	public class RequestURL extends ActionEffect {
		
		public static const RESULT_EVENT:String = "resultEvent";
		public static const FAULT_EVENT:String = "faultEvent";
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function RequestURL(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = RequestURLInstance;
		}
	
		
		/**
		 * Data sent to send to the server in the URL Request data property
		 * */
		public var requestData:Object;
		
		
		/**
		 * Request being submitted
		 * */
		public var request:URLRequest;
		
		/**
		 * Request type. URLRequestMethod.POST or URLRequestMethod.GET
		 * */
		[Inspectable(enumeration="post,get", defaultValue="post")]
		public var method:String = URLRequestMethod.POST;
		
		/**
		 * URL to request
		 * */
		public var url:String;
		
		/**
		 * Result object returned from the server
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * Loader used to make http calls
		 * */
		public var loader:URLLoader;
		
		/**
		 * Inspects the request object
		 * */
		public var inspectRequestObject:Boolean;
		
		/**
		 * Inspects the response object
		 * */
		public var inspectResultObject:Boolean;
		
		/**
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:Object;
		
		/**
		 * Reference to the error message
		 * */
		[Bindable]
		public var errorMessage:String;
		
		/**
		 * Effect to run when a service fault is generated
		 * */
		public var faultEffect:ActionEffect;
		
		/**
		 * Effect to run when a service result is generated.
		 * You can set this or continue to the next effect if in a sequence
		 * */
		public var resultEffect:ActionEffect;
	}
}