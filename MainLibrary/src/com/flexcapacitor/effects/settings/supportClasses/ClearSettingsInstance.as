

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.ClearSettings;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	
	/**
	 *@copy ClearSettings
	 * */  
	public class ClearSettingsInstance extends ActionEffectInstance {
		
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
		public function ClearSettingsInstance(target:Object) {
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
			
			var action:ClearSettings = ClearSettings(effect);
			var sharedObject:SharedObject;
			var result:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!action.group) {
					errorMessage = "Group name is required";
					dispatchErrorEvent(errorMessage);
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// gets the shared object with the name specified in the group
			// if a group doesnt exist with this name it's created
			result = SharedObjectUtils.getSharedObject(action.group, action.localPath, action.secure);
			
			// check if we could create the shared object
			if (result is Event) {
				
				trace("shared object could not be created");
				
				// step through 
				if (action.hasEventListener("error")) {
					action.dispatchEvent(new Event("error"));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				cancel();
				return;
			}
			else if (!result) {
				
				trace("shared object could not be created. is null");
				
				if (action.hasEventListener("error")) {
					action.dispatchEvent(new Event("error"));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				cancel();
				return;
			}
			
			sharedObject = SharedObject(result);
			
			sharedObject.clear();
			
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
		
		
	}
	
	
}