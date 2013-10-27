

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.SaveSetting;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy SaveSetting
	 * */  
	public class SaveSettingInstance extends ActionEffectInstance {
		
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
		public function SaveSettingInstance(target:Object) {
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
		 * @private
		 * */
		override public function play():void { 
			super.play(); // dispatch startEffect
			
			var action:SaveSetting = SaveSetting(effect);
			var traceToConsole:Boolean = action.traceDataToConsole;
			var sharedObject:SharedObject;
			var result:Object;
			var status:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!action.name) {
					errorMessage = "Name is required";
					dispatchErrorEvent(errorMessage);
				}
				if (action.data==null && !action.valueCanBeNull) {
					errorMessage = "Data value cannot be null";
					dispatchErrorEvent(errorMessage);
				}/*
				if (!action.name) {
					errorMessage = "Group name is required";
					dispatchErrorEvent(errorMessage);
				}*/
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// gets the shared object with the name specified
			// if a path doesn't exist with this name it's created
			result = SharedObjectUtils.getSharedObject(action.name, action.localPath, action.secure);
			
			// check if we could create the shared object
			if (result is Event) {
				
				action.errorEvent = result;
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created. " + ObjectUtil.toString(result));
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(SaveSetting.ERROR)) {
					dispatchActionEvent(new Event(SaveSetting.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				///////////////////////////////////////////////////////////
				// Finish the effect
				///////////////////////////////////////////////////////////
				
				finish();
				return;
			}
			else if (result is Error) {
				
				action.errorEvent = result;
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created. " + ObjectUtil.toString(result));
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(SaveSetting.ERROR)) {
					dispatchActionEvent(new Event(SaveSetting.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				///////////////////////////////////////////////////////////
				// Finish the effect
				///////////////////////////////////////////////////////////
				
				finish();
				return;
			}
			else if (result==null) {
				// see errors in main class asdocs
				action.errorEvent = result;
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created. It's value is null.");
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(SaveSetting.ERROR)) {
					dispatchActionEvent(new Event(SaveSetting.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				///////////////////////////////////////////////////////////
				// Finish the effect
				///////////////////////////////////////////////////////////
				
				finish();
				return;
			}
			
			
			// shared object found - continue
			sharedObject = SharedObject(result);
			action.sharedObject = sharedObject;
			
			sharedObject.objectEncoding = action.objectEncoding;
			
			// set property - by default null data deletes the property --is this true?? maybe earlier fp?
			// - sometimes fields are empty, "" but we still want the property 
			// use RemoveSetting to remove the property
			
			// is property set
			if (action.property!=null) {
				
				// if data is null
				if (action.data==null) {
					if (action.removeSettingWhenDataIsNull) {
						delete sharedObject.data[action.property];
					}
					else {
						sharedObject.setProperty(action.property, "");
					}
				}
				else {
					sharedObject.setProperty(action.property, action.data);
				}
			}
			else {
				if (action.data==null) {
					if (action.removeSettingWhenDataIsNull) {
						delete sharedObject.data[action.name];
					}
					else {
						sharedObject.setProperty(action.name, "");
					}
				}
				else {
					sharedObject.setProperty(action.name, action.data);
				}
			}

			// Immediately writes a locally persistent shared object to a 
			// local file. If you don't use this method, Flash Player writes 
			// the shared object to a file when the shared object session ends — 
			// that is, when the SWF file is closed, when the shared object is 
			// garbage-collected because it no longer has any references to it, 
			// or when you call SharedObject.clear() or SharedObject.close(). 
			if (action.applyImmediately) {
				
				// Flash Player throws an exception when a call to the flush method fails.
				// Flash Player responds in the netStatus event when user allows or denies more disk space
				sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
				sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
				
				
				try {
					if (action.minimumSettingsSpace==0) {
						status = sharedObject.flush();
					}
					else {
						status = sharedObject.flush(action.minimumSettingsSpace);
					}
				}
				catch (error:Error) {
					
					action.errorEvent = error;
					
					if (action.hasEventListener(SaveSetting.ERROR)) {
						dispatchActionEvent(new Event(SaveSetting.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
				}
				
				if (status == SharedObjectFlushStatus.PENDING) {
					
					if (action.hasEventListener(SharedObjectFlushStatus.PENDING)) {
						dispatchActionEvent(new Event(SharedObjectFlushStatus.PENDING));
					}
					
					if (action.pendingEffect) {
						playEffect(action.pendingEffect);
					}
				}
				else if (status==SharedObjectFlushStatus.FLUSHED) {
					
					if (action.hasEventListener(SaveSetting.SAVED)) {
						dispatchActionEvent(new Event(SaveSetting.SAVED));
					}
					
					if (action.savedEffect) {
						playEffect(action.savedEffect);
					}
				}
				
				// not sure why I'm removing event listeners here
				sharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				
			}
			else {
				// don't know if it makes sense to add handlers since 
				// the setting is saved on exit of application?
				// this action makes more sense when it's applied immediately
				
				// Flash Player throws an exception when a call to the flush method fails.
				// Flash Player responds in the netStatus event when user allows or denies more disk space
				sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
				sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
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
		
		/**
		 * Handles net status events
		 * NOT TESTED
		 * */
		protected function netStatusHandler(event:NetStatusEvent):void {
			var action:SaveSetting = SaveSetting(effect);
			var sharedObject:SharedObject = action.sharedObject;
			
			// NOT TESTED
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			sharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			
			// "SharedObject.Flush.Failed" "error" The "pending" status is resolved, but the SharedObject.flush() failed. 
			// "SharedObject.Flush.Success" "status" The "pending" status is resolved and the SharedObject.flush() call succeeded. 
			
			if (event.info=="error") {
				
				action.errorEvent = event;
				
				if (action.hasEventListener(SaveSetting.ERROR)) {
					dispatchActionEvent(new Event(SaveSetting.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
			}
			else if (event.info==SharedObjectFlushStatus.FLUSHED) {
				
				action.netStatusEvent = event;
				
				if (action.hasEventListener(SaveSetting.SAVED)) {
					dispatchActionEvent(new Event(SaveSetting.SAVED));
				}
				
				if (action.savedEffect) {
					playEffect(action.savedEffect);
				}
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * Handles async error events
		 * NOT TESTED
		 * */
		protected function asyncErrorHandler(event:AsyncErrorEvent):void {
			var action:SaveSetting = SaveSetting(effect);
			var sharedObject:SharedObject = action.sharedObject;
			
			// NOT TESTED
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			sharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			
			action.asyncErrorEvent = event;
			
			
			if (action.hasEventListener(SaveSetting.ERROR)) {
				dispatchActionEvent(new Event(SaveSetting.ERROR));
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		
	}
	
	
}