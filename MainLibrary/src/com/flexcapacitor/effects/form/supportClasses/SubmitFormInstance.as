

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.SubmitForm;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormManager;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.IList;
	import mx.core.UIComponentGlobals;
	import mx.managers.ILayoutManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy SubmitForm
	 */  
	public class SubmitFormInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SubmitFormInstance(target:Object) {
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
			super.play();
			// Dispatch an effectStart event
			var valid:Boolean = true;
			var action:SubmitForm = effect as SubmitForm;
			var modeToSwitchToAfterSubmit:String;
			
			if (!action.formAdapter) {
				dispatchErrorEvent("Form adapter property is required.");
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
				action.data = FormManager.instance.createRequest(action.formAdapter, action.suppressNullTargetErrors);
				
				if (action.requestData) {
					for (var name:String in action.requestData) {
						action.data[name] = action.requestData[name];
					}
				}
			}
			
			// the add method automatically does the switching for us
			// set form back to it's original value
			if (action.modeToSwitchToAfterSubmit) {
				action.formAdapter.modeToSwitchToAfterSubmit = modeToSwitchToAfterSubmit;
				
				if (action.submitMethod!=null) {
					action.submitMethod.apply(this, [action.data]);
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
			
			if (action.url) {
				
				action.service = new HTTPService();
				action.service.resultFormat = action.resultFormat;
				action.service.method = action.requestMethod;
				action.service.url = action.url;
				action.service.request = action.data;
				action.service.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				action.service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				action.service.addEventListener(ResultEvent.RESULT, loaderComplete);
				action.service.send();
				
				if (action.inspectRequestObject) {
					trace("Request:\n" + ObjectUtil.toString(action.data));
					//enterDebugger();
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
			var action:SubmitForm = effect as SubmitForm;
			removeListeners();
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(IOErrorEvent.IO_ERROR)) 
				dispatchActionEvent(event);
			
			cancel("IO Error "+ event.errorID);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:SubmitForm = effect as SubmitForm;
			removeListeners();
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			if (action.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) 
				dispatchActionEvent(event);
			
			cancel("Security error "+event.errorID);
		}
		
		protected function loaderComplete(event:ResultEvent):void {
			var action:SubmitForm = effect as SubmitForm;
			removeListeners();
			action.result = event.result;
			
			if (action.inspectResultObject) {
				trace("Result:\n" + ObjectUtil.toString(event.result));
			}
			
			if (action.hasEventListener(Event.COMPLETE)) 
				dispatchActionEvent(event);
			
			finishEffect();
		}
		
		protected function removeListeners():void {
			var action:SubmitForm = effect as SubmitForm;
			action.service.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			action.service.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			action.service.removeEventListener(Event.COMPLETE, loaderComplete);
		}
		
	}
}