

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.RemoveSetting;
	import com.flexcapacitor.effects.settings.SaveSetting;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	
	/**
	 * @copy RemoveSetting
	 * */  
	public class RemoveSettingInstance extends ActionEffectInstance {
		
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
		public function RemoveSettingInstance(target:Object) {
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
			
			var action:RemoveSetting = RemoveSetting(effect);
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
				}/*
				if (!action.property) {
					errorMessage = "Group name is required";
					dispatchErrorEvent(errorMessage);
				}*/
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// gets the shared object with the name specified
			result = SharedObjectUtils.getSharedObject(action.name, action.localPath, action.secure);
			
			// check if we could create the shared object
			if (result is Event || result is Error) {
				
				action.errorEvent = result;
				
				if (action.hasEventListener(RemoveSetting.ERROR)) {
					dispatchActionEvent(new Event(RemoveSetting.ERROR));
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
			else if (!result) {
				
				
				action.errorEvent = result;
				
				if (action.hasEventListener(RemoveSetting.ERROR)) {
					dispatchActionEvent(new Event(RemoveSetting.ERROR));
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
			
			if (sharedObject.data) {
				
				if (action.property) {
					delete sharedObject.data[action.property];
				}
				else {
					sharedObject.clear();
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
				
				// pending
				if (status == SharedObjectFlushStatus.PENDING) {
					
					if (action.hasEventListener(SharedObjectFlushStatus.PENDING)) {
						dispatchActionEvent(new Event(SharedObjectFlushStatus.PENDING));
					}
					
					if (action.pendingEffect) {
						playEffect(action.pendingEffect);
					}
				}
				else if (status==SharedObjectFlushStatus.FLUSHED) {
					
					if (action.hasEventListener(RemoveSetting.REMOVED)) {
						dispatchActionEvent(new Event(RemoveSetting.REMOVED));
					}
					
					if (action.removedEffect) {
						playEffect(action.removedEffect);
					}
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
			
			
			action.errorEvent = event;
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