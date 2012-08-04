

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.GetDataFromTarget;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	/**
	 *  @copy GetValueFromTarget
	 * */
	public class GetDataFromTargetInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function GetDataFromTargetInstance(target:Object) {
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
			
			var action:GetDataFromTarget = GetDataFromTarget(effect);
			var labelFunction:Function = action.labelFunction;
			var value:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!target) {
					errorMessage = "The target cannot be null";
					dispatchErrorEvent(errorMessage);
				}
				// check if target property exists on target
				else if (action.targetPropertyName && !(action.targetPropertyName in target)) {
					errorMessage = "The " + action.targetPropertyName + " property does not exist on the target object";
					dispatchErrorEvent(errorMessage);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// GET VALUE
			// check if we should use source or value
			if (action.target) {
				
				if (action.targetPropertyName) {
					
					if (action.targetSubPropertyName) {
						value = action.target[action.targetPropertyName];
						
						if (value && action.targetSubPropertyName in value) {
							value = value[action.targetSubPropertyName];
						}
						else {
							dispatchErrorEvent("The sub property " + action.targetSubPropertyName + " is not on the " + action.targetPropertyName + " object");
						}
						
					}
					else {
						// if source property index is set we get the index
						if (action.targetPropertyIndex!=-1) {
							value = action.target[action.targetPropertyName][action.targetPropertyIndex];
						}
						else {
							value = action.target[action.targetPropertyName];
						}
					}
				}
				else {
					value = action.target;
				}
				
			}
			
			if (labelFunction!=null) {
				value = labelFunction(value);
			}
			
			// SET DATA to VALUE
			action.data = value;
			
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