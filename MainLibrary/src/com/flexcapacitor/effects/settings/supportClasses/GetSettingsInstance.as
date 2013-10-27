

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.GetSettings;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy GetSettings
	 * */  
	public class GetSettingsInstance extends ActionEffectInstance {
		
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
		public function GetSettingsInstance(target:Object) {
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
			var action:GetSettings = GetSettings(effect);
			var traceToConsole:Boolean = action.traceDataToConsole;
			var sharedObject:SharedObject;
			var properties:Array = [];
			var result:Object;
			var status:String;
			var data:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!action.name && !action.allowNullName) {
					errorMessage = "Name is required";
					dispatchErrorEvent(errorMessage);
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
				
				action.errorEvent = result;
				
				if (action.traceDataToConsole) {
					traceMessage("Shared object could not be created. " + ObjectUtil.toString(result));
				}
				
				// step through 
				if (action.hasEventListener(GetSettings.ERROR)) {
					dispatchActionEvent(new Event(GetSettings.ERROR));
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
				}
				
				if (action.hasEventListener(GetSettings.ERROR)) {
					dispatchActionEvent(new Event(GetSettings.ERROR));
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
			else if (result==null) { // this condition might not be needed anymore - see SharedObjectUtils.getSharedObject
				action.errorEvent = result;
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created. It's value is null");
				}
				
				if (action.hasEventListener(GetSettings.ERROR)) {
					dispatchActionEvent(new Event(GetSettings.ERROR));
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
			
			// no errors - continue
			
			// get shared object
			sharedObject = SharedObject(result);
			
			data = sharedObject.data;
			
			for (var name:String in data) {
				properties.push(name);
				
				if (traceToConsole) {
					traceMessage(name + "=" + data[name]);
				}
			}
			
			// clears any previously set data and properties with actual values (even if they are null)
			action.data = data;
			action.properties = properties;
			
			// if data is null then dispatch null values event and effect
			if (data == null || properties.length==0) {
				
				if (action.hasEventListener(GetSettings.VALUE_NOT_SET)) {
					dispatchActionEvent(new Event(GetSettings.VALUE_NOT_SET));
				}
				
				if (action.valueNotSetEffect) {
					playEffect(action.valueNotSetEffect);
				}
				
			}
			else {
				if (action.hasEventListener(GetSettings.VALUE_SET)) {
					dispatchActionEvent(new Event(GetSettings.VALUE_SET));
				}
				
				if (action.valueSetEffect) {
					playEffect(action.valueSetEffect);
				}
			}
			
			sharedObject = null;
			result = null;
			
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