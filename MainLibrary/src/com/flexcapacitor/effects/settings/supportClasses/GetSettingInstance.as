

package com.flexcapacitor.effects.settings.supportClasses {
	import com.flexcapacitor.effects.settings.GetSetting;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.SharedObjectUtils;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy GetSetting
	 * */  
	public class GetSettingInstance extends ActionEffectInstance {
		
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
		public function GetSettingInstance(target:Object) {
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
			
			var action:GetSetting = GetSetting(effect);
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
				if (!action.name) {
					errorMessage = "Name is required";
					dispatchErrorEvent(errorMessage);
				}/*
				if (!action.property) {
					errorMessage = "Propery name is required";
					dispatchErrorEvent(errorMessage);
				}*/
				
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
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created.");
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(GetSetting.ERROR)) {
					dispatchActionEvent(new Event(GetSetting.ERROR));
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
					traceMessage("Shared object could not be created.");
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(GetSetting.ERROR)) {
					dispatchActionEvent(new Event(GetSetting.ERROR));
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
				
				action.errorEvent = result;
				
				if (traceToConsole) {
					traceMessage("Shared object could not be created. It's value is null");
					traceMessage(ObjectUtil.toString(result));
				}
				
				if (action.hasEventListener(GetSetting.ERROR)) {
					dispatchActionEvent(new Event(GetSetting.ERROR));
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
			
			sharedObject = SharedObject(result);
			
			data = action.property ? sharedObject.data[action.property] : sharedObject.data;
			
			for (var name:String in data) {
				properties.push(name);
				
				if (traceToConsole) {
					traceMessage(name + "=" + data[name]);
				}
			}
			
			if (traceToConsole && properties.length==0) {
				traceMessage("No data on object");
			}
			
			action.data = data;
			
			if (data == null || sharedObject.size==0 || properties.length==0) {
				
				if (action.hasEventListener(GetSetting.VALUE_NOT_SET)) {
					dispatchActionEvent(new Event(GetSetting.VALUE_NOT_SET));
				}
				
				if (action.valueNotSetEffect) {
					playEffect(action.valueNotSetEffect);
				}
				
			}
			else {
				if (action.hasEventListener(GetSetting.VALUE_SET)) {
					dispatchActionEvent(new Event(GetSetting.VALUE_SET));
				}
				
				if (action.valueSetEffect) {
					playEffect(action.valueSetEffect);
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
		
		
	}
	
	
}