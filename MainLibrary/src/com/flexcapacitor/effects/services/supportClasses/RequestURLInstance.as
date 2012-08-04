

package com.flexcapacitor.effects.services.supportClasses {
	import com.flexcapacitor.effects.services.RequestURL;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 *  @copy RequestURL
	 */  
	public class RequestURLInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function RequestURLInstance(target:Object) {
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
		 */
		override public function play():void { 
			super.play(); // Dispatch an effectStart event
			
			var action:RequestURL = RequestURL(effect);
			var url:String = action.url;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!url) {
					dispatchErrorEvent("The URL is not set.");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.loader = new URLLoader();
			action.request = new URLRequest(url);
			
			action.request.data = action.requestData;
			action.request.method = action.method;
			
			action.loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			action.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			action.loader.addEventListener(Event.COMPLETE, loaderComplete);
			
			action.loader.load(action.request);
			
			if (action.inspectRequestObject) {
				trace(ObjectUtil.toString(action.requestData));
				//enterDebugger();
			}
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			waitForHandlers();
			
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function ioErrorHandler(event:IOErrorEvent):void {
			var action:RequestURL = effect as RequestURL;
			removeListeners();
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(IOErrorEvent.IO_ERROR)) 
				action.dispatchEvent(event);
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:RequestURL = effect as RequestURL;
			removeListeners();
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) 
				action.dispatchEvent(event);
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		protected function loaderComplete(event:Event):void {
			var action:RequestURL = effect as RequestURL;
			removeListeners();
			action.data = event.currentTarget.data;
			
			if (action.inspectResultObject) {
				trace(ObjectUtil.toString(event.currentTarget));
				enterDebugger();
			}
			
			if (action.hasEventListener(Event.COMPLETE)) 
				action.dispatchEvent(event);
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		protected function removeListeners():void {
			var action:RequestURL = effect as RequestURL;
			action.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			action.loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			action.loader.removeEventListener(Event.COMPLETE, loaderComplete);
		}
		
	}
}