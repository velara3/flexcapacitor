

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CopyValue;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.TypeUtils;
	
	import mx.core.UIComponent;
	
	/**
	 * @copy CopyValue
	 * */
	public class CopyValueInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CopyValueInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:CopyValue = CopyValue(effect);
			var targetPropertyName:String = action.targetPropertyName;
			var suppressErrors:Boolean = action.suppressErrors;
			var target:Object = action.target;
			var data:Object = action.data;
			var dataPropertyName:String = action.dataPropertyName;
			var useDefaultValues:Boolean = action.useDefaultValue;
			var value:*;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!target && !suppressErrors) { 
					dispatchErrorEvent("The target component is null. If it will be created later enable suppress or call this effect later.");
				}
				
				if (data==null && !action.allowNullData) {
					dispatchErrorEvent("The data object is null.");
				}
				
				if (data && dataPropertyName &&
					!(dataPropertyName in data)) {
					dispatchErrorEvent("The property " + dataPropertyName + " is not in the data object.");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			useDefaultValues = action.useDefaultValue;
			dataPropertyName = action.dataPropertyName;
			
			// data can be null for a variety of reasons
			if (data) {
				
				if (dataPropertyName) {
					if (dataPropertyName in data) {
						value = data[dataPropertyName];
					}
				}
				else {
					value = data;
				}
				
			}
			
			if (value==null && useDefaultValues) {
				
				// list based
				if (targetPropertyName=="selectedIndex") {
					value = action.defaultSelectedIndex;
				} // checkbox or toggle button
				else if (targetPropertyName=="selected") {
					value = action.defaultSelected;
				}
				else {
					value = action.defaultValue;
				}
			}
			
			// check if target component is null
			// we may be trying to set the form components before they are created
			// you can work around this by adding the same handler actions 
			// on the target component's parent creation complete event 
			// and suppressing the errors until the components are created
			// which happens when listening to a data change event which 
			// is set before components are created
			if (target==null) {
				
				if (suppressErrors) {
					action.pendingSetting = true;
					action.pendingValue = value;
				}
			}
			else {
				TypeUtils.setValue(target, targetPropertyName, value, action.wrapValueInCDATATags);
			}
			
			if (action.validateNow && target is UIComponent) {
				UIComponent(target).validateNow();
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