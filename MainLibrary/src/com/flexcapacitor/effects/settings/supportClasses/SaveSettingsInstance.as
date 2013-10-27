

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.SaveSettings;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	
	/**
	 * @copy SaveSettings
	 * */  
	public class SaveSettingsInstance extends ActionEffectInstance {
		
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
		public function SaveSettingsInstance(target:Object) {
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
			
			var action:SaveSettings = SaveSettings(effect);
			var sharedObject:Object;
			var result:Object;
			var status:String;
			var properties:Array;
			var length:int;
			var data:Object;
			var name:String;
			var property:String;
			var save:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			properties = action.properties;
			status = action.propertiesStatus;
			length = properties.length;
			data = action.data;
			name = action.name;
			save = action.saveImmediately;
			
			// check for required properties
			if (validate) {
				if (!data) {
					errorMessage = "Data is required";
					dispatchErrorEvent(errorMessage);
				}
				if (!name) {
					errorMessage = "Name is required";
					dispatchErrorEvent(errorMessage);
				}
				
				// check if the property exists on the target
				if (length>0 && status=="inclusive") {
					for (var i:int; i<properties.length;i++) {
						if (!(properties[i] in data)) {
							dispatchErrorEvent("The " + properties[i] + " property is not in the data object");
						}
					}
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// gets the shared object with the name specified in the group
			// if a group doesnt exist with this name it's created
			result = SharedObjectUtils.getSharedObject(action.name, action.localPath, action.secure);
			
			// check if we could create the shared object
			if (result is Event) {
				
				// shared object could not be created
				// result is Error event
				action.errorEvent = result as Event;
				
				// step through 
				if (action.hasEventListener(SaveSettings.ERROR)) {
					dispatchActionEvent(new Event(SaveSettings.ERROR));
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
			// ArgumentError 2005 
			else if (!result || result is Error) {
				
				// shared object could not be created and is null
				action.errorEvent = result as Event;
				
				if (action.hasEventListener(SaveSettings.ERROR)) {
					dispatchActionEvent(new Event(SaveSettings.ERROR));
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
			
			// set shared object
			sharedObject = SharedObject(result);
			
			// if properties are listed and they are inclusive set them here
			if (length>0 && status=="inclusive") {
				for (i;i<length;i++) {
					sharedObject.setProperty(properties[i], data[properties[i]]);
				}
			}
			else {
				// loop through and add all the properties in data 
				for (property in data) {
					
					// any properties listed are exclusive 
					// if property is found skip to the next one
					if (length && properties.indexOf(property)!=-1) {
						continue;
					}
					
					sharedObject.setProperty(property, data[property]);
				}
			}
			
			// Save 
			// Immediately writes a locally persistent shared object to a 
			// local file. If you don't use this method, Flash Player writes 
			// the shared object to a file when the shared object session ends — 
			// that is, when the SWF file is closed, when the shared object is 
			// garbage-collected because it no longer has any references to it, 
			// or when you call SharedObject.clear() or SharedObject.close(). 
			
			if (save) {
				// Flash Player throws an exception when a call to the flush method fails.
				// Flash Player responds in the netStatus event when user allows or denies more disk space
				sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				
				status = sharedObject.flush(action.minimumSettingsSpace);
				
				if (status == SharedObjectFlushStatus.PENDING) {
					
					if (action.hasEventListener(SaveSettings.PENDING)) {
						dispatchActionEvent(new Event(SaveSettings.PENDING));
					}
					
					if (action.pendingEffect) {
						playEffect(action.pendingEffect);
					}
				}
				else if (status==SharedObjectFlushStatus.FLUSHED) {
					
					if (action.hasEventListener(SaveSettings.SAVED)) {
						dispatchActionEvent(new Event(SaveSettings.SAVED));
					}
					
					if (action.savedEffect) {
						playEffect(action.savedEffect);
					}
				}
					
				
				sharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
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
		
		
		protected function netStatusHandler(event:NetStatusEvent):void {
			var action:SaveSettings = SaveSettings(effect);
			
			// NOT TESTED
			
			// "SharedObject.Flush.Failed" "error" The "pending" status is resolved, but the SharedObject.flush() failed. 
			// "SharedObject.Flush.Success" "status" The "pending" status is resolved and the SharedObject.flush() call succeeded. 
			
			if (event.info=="error") {
				
				if (action.hasEventListener(SaveSettings.ERROR)) {
					dispatchActionEvent(new Event(SaveSettings.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
			}
			else if (event.info==SharedObjectFlushStatus.FLUSHED) {
				
				if (action.hasEventListener(SaveSettings.SAVED)) {
					dispatchActionEvent(new Event(SaveSettings.SAVED));
				}
				
				if (action.savedEffect) {
					playEffect(action.savedEffect);
				}
			}
		}
		
		protected function asyncErrorHandler(event:AsyncErrorEvent):void {
			var action:SaveSettings = SaveSettings(effect);
			
			if (action.hasEventListener(SaveSettings.ERROR)) {
				dispatchActionEvent(new Event(SaveSettings.ERROR));
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
			
		}
		
		
	}
	
	
}