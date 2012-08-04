

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.IsPropertySetToValue;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	

	/**
	 * @copy IsPropertySetToValue
	 * */  
	public class IsPropertySetToValueInstance extends ActionEffectInstance {
		
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
		public function IsPropertySetToValueInstance(target:Object) {
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
			
			var action:IsPropertySetToValue = IsPropertySetToValue(effect);
			var propertySet:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (!(action.targetPropertyName in action.target)) {
					cancel();
					throw new Error("The property " + propertySet + " is not found on the target.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.target[action.targetPropertyName]==action.value) {
				propertySet = true;
			}
			
			
			// check if the property is set
			if (!propertySet) { 
				
				// property is NOT set to value
				if (action.hasEventListener(IsPropertySetToValue.PROPERTY_SET)) {
					action.dispatchEvent(new Event(IsPropertySetToValue.PROPERTY_SET));
				}
				
				if (action.propertyNotSetEffect) { 
					playEffect(action.propertyNotSetEffect);
				}
				
				if (action.cancelIfNotSet) {
					cancel();
				}
				
			}
			else {
				
				// property IS set to value
				if (action.hasEventListener(IsPropertySetToValue.PROPERTY_SET)) {
					action.dispatchEvent(new Event(IsPropertySetToValue.PROPERTY_SET));
				}
				
				if (action.propertySetEffect) { 
					playEffect(action.propertySetEffect);
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