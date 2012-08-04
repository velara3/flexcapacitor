

package com.flexcapacitor.effects.services.supportClasses {
	import com.flexcapacitor.effects.services.RequestServiceURL;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	
	/**
	 *  @copy RequestServiceURL
	 * */
	public class RequestServiceURLInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function RequestServiceURLInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:RequestServiceURL = effect as RequestServiceURL;
			var service:HTTPService;
			var url:String = action.url;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!url) {
					dispatchErrorEvent("The destination URL is not set.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			service 					= new HTTPService(); // do we need to create a new instance each time?
			service.url 				= url;
			service.method 				= action.method;
			service.contentType 		= action.contentType;
			service.request 			= action.request;
			service.resultFormat 		= action.resultFormat;
			service.useProxy 			= action.useProxy;
			
			service.addEventListener(FaultEvent.FAULT, faultHandler);
			service.addEventListener(ResultEvent.RESULT, resultHandler);
			
			service.send();
			
			action.service = service; // keep it alive
			
			if (action.inspectData) {
				trace(ObjectUtil.toString(action.data));
			}
			
			if (action.inspectRequest) {
				trace(ObjectUtil.toString(action.request));
			}
			
			///////////////////////////////////////////////////////////
			// Pause the effect
			///////////////////////////////////////////////////////////
			
			waitForHandlers();
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function faultHandler(event:FaultEvent):void {
			var action:RequestServiceURL = effect as RequestServiceURL;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeListeners();
			
			action.faultEvent = event;
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(FaultEvent.FAULT)) {
				action.dispatchEvent(event);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			cancel("Fault Error "+ event.fault);
		}
		
		protected function resultHandler(event:ResultEvent):void {
			var action:RequestServiceURL = effect as RequestServiceURL;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeListeners();
			
			action.data = event.result;
			action.resultEvent = event;
			
			if (action.inspectResult) {
				trace(ObjectUtil.toString(event.result));
			}
			
			if (action.resultEffect) {
				playEffect(action.resultEffect);
			}
			
			if (action.hasEventListener(ResultEvent.RESULT)) {
				action.dispatchEvent(event);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * Remove listeners
		 * */
		protected function removeListeners():void {
			var action:RequestServiceURL = effect as RequestServiceURL;
			action.service.removeEventListener(FaultEvent.FAULT, faultHandler);
			action.service.removeEventListener(ResultEvent.RESULT, resultHandler);
		}
		
	}
}