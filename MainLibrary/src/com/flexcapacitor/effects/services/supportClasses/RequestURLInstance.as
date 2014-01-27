

package com.flexcapacitor.effects.services.supportClasses {
	import com.flexcapacitor.effects.services.RequestURL;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
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
			
			addEventListeners(action.loader);
			
			action.loader.load(action.request);
			
			if (action.inspectRequestObject) {
				traceMessage(ObjectUtil.toString(action.requestData));
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
		
		/**
		 * IO Error handler
		 * */
		protected function ioErrorHandler(event:IOErrorEvent):void {
			var action:RequestURL = effect as RequestURL;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeEventListeners(action.loader);
			
			action.errorEvent = event;
			action.errorMessage = event.text;
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(IOErrorEvent.IO_ERROR)) {
				action.dispatchEvent(event);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * Security Error handler
		 * */
		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:RequestURL = effect as RequestURL;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeEventListeners(action.loader);
			
			action.errorEvent = event;
			action.errorMessage = event.text;
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) {
				action.dispatchEvent(event);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * URL Loader complete
		 * */
		protected function completeHandler(event:Event):void {
			var action:RequestURL = effect as RequestURL;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeEventListeners(action.loader);
			
			action.data = action.loader.data;
			
			if (action.inspectResultObject) {
				traceMessage(ObjectUtil.toString(action.loader));
				//enterDebugger();
			}
			
			if (action.resultEffect) {
				playEffect(action.resultEffect);
			}
			
			if (action.hasEventListener(Event.COMPLETE)) {
				action.dispatchEvent(event);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}

        private function openHandler(event:Event):void {
            //trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
           // trace("httpStatusHandler: " + event);
        }

		/**
		 * Add event listeners
		 * */
		protected function addEventListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
            dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
        }
		
		/**
		 * Remove event listeners
		 * */
		protected function removeEventListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            dispatcher.removeEventListener(Event.OPEN, openHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
	}
}