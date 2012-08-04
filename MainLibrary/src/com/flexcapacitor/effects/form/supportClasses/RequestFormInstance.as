

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.RequestForm;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormManager;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 *  @copy RequestForm
	 */  
	public class RequestFormInstance extends ActionEffectInstance {
		
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
		public function RequestFormInstance(target:Object) {
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
			super.play();
			// Dispatch an effectStart event
			var valid:Boolean = true;
			var action:RequestForm = effect as RequestForm;
			var modeToSwitchToAfterSubmit:String;
			
			if (!action.formAdapter) {
				cancel();
				throw new Error("Form adapter property is required.");
			}
			
			// set editable object in form's class
			if (action.modeToSwitchToAfterSubmit) {
				// store value so we can switch back later
				modeToSwitchToAfterSubmit = action.formAdapter.modeToSwitchToAfterSubmit;
				action.formAdapter.modeToSwitchToAfterSubmit = action.modeToSwitchToAfterSubmit;
			}
			
			if (action.validate) {
				valid = FormManager.instance.validate(action.formAdapter);
			}
			
			if (valid) {
				action.requestData = FormManager.instance.createRequest(action.formAdapter, action.suppressNullTargetErrors);
			}
			
			// the add method automatically does the switching for us
			// set form back to it's original value
			if (action.modeToSwitchToAfterSubmit) {
				action.formAdapter.modeToSwitchToAfterSubmit = modeToSwitchToAfterSubmit;
				
				if (action.submitMethod!=null) {
					action.submitMethod.apply(this, [action.requestData]);
				}
			}
			
			// if not valid - we call this after reverting modeToSwitchToAfterSubmit
			if (!valid) {
				cancel();
				return;
			}
			
			
			// state to switch to after submit
			if (action.stateToSwitchToAfterSubmit) {
				if (action.view==null) {
					cancel();
					throw new Error("The view is not set");
				}
				
				if (action.view.hasState(action.stateToSwitchToAfterSubmit)) {
					action.view.currentState = action.stateToSwitchToAfterSubmit;
				}
				else {
					cancel();
					throw new Error("The view does not have the state specified");
				}
			}
			
			if (action.resetForm) {
				FormManager.instance.reset(action.formAdapter);
			}
			
			if (action.destinationURL) {
				
				action.loader = new URLLoader();
				action.request = new URLRequest(action.destinationURL);
				action.request.data = action.requestData;
				action.request.method = action.requestMethod;
				action.loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				action.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				action.loader.addEventListener(Event.COMPLETE, loaderComplete);
				action.loader.load(action.request);
				
				if (action.inspectRequestObject) {
					trace(ObjectUtil.toString(action.requestData));
					enterDebugger();
				}
				waitForHandlers();
			}
			else {
				cancel();
				throw new Error("The destination URL is not set.");
			}
			
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function ioErrorHandler(event:IOErrorEvent):void {
			var action:RequestForm = effect as RequestForm;
			action.loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(IOErrorEvent.IO_ERROR)) 
				action.dispatchEvent(event);
			
			cancel("IO Error "+ event.errorID);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:RequestForm = effect as RequestForm;
			action.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) 
				action.dispatchEvent(event);
			
			cancel("Security error "+event.errorID);
		}
		
		protected function loaderComplete(event:Event):void {
			var action:RequestForm = effect as RequestForm;
			action.loader.removeEventListener(Event.COMPLETE, loaderComplete);
			
			if (action.hasEventListener(Event.COMPLETE)) 
				action.dispatchEvent(event);
			
			finishEffect();
		}
		
	}
}