

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.IsPropertySet;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	

	/**
	 * @copy IsPropertySet
	 * */  
	public class IsPropertySetInstance extends ActionEffectInstance {
		
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
		public function IsPropertySetInstance(target:Object) {
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
			
			var action:IsPropertySet = IsPropertySet(effect);
			var propertyName:String = action.targetPropertyName;
			var subPropertyName:String = action.targetSubPropertyName;
			var emptyStringsAreNull:Boolean = action.emptyStringsAreNull;
			var propertySet:Boolean;
			var value:Object;
			var subValue:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (target==null) {
					dispatchErrorEvent("The target is not set.");
				}
				if (!(propertyName in target)) {
					dispatchErrorEvent("The property " + propertyName + " is not found on the target.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (subPropertyName) {
				value = target[propertyName];// "data" is the default property
				
				// if value is set and sub property exists
				if (value && subPropertyName in value) {
					subValue = value[subPropertyName];
					
					if (subValue is Number) {
						if (isNaN(Number(subValue))) {
							propertySet = false;
						}
						else {
							propertySet = true;
						}
					}
					else if (subValue==null ||
							(subValue=="" && emptyStringsAreNull)) {
						
						propertySet = false;
					}
					else {
						propertySet = true;
					}
				}
				else {
					dispatchErrorEvent("The sub property " + subPropertyName + " is not on the " + propertyName + " object");
				}
			}
			else {
				value = target[propertyName];
				
				if (value && value is Number) {
					if (isNaN(Number(value))) {
						propertySet = false;
					}
					else {
						propertySet = true;
					}
				}
				else if (value==null ||
						(value=="" && emptyStringsAreNull)) {
					
					propertySet = false;
				}
				else {
					propertySet = true;
				}
			}
			
			
			// check if the property is set
			if (!propertySet) { 
				
				// property is NOT set 
				
				if (action.hasEventListener(IsPropertySet.PROPERTY_NOT_SET)) {
					action.dispatchEvent(new Event(IsPropertySet.PROPERTY_NOT_SET));
				}
				
				if (action.propertyNotSetEffect) { 
					playEffect(action.propertyNotSetEffect);
					return;
				}
				
			}
			else {
				
				// property IS set
				if (action.hasEventListener(IsPropertySet.PROPERTY_SET)) {
					action.dispatchEvent(new Event(IsPropertySet.PROPERTY_SET));
				}
				
				if (action.propertySetEffect) { 
					playEffect(action.propertySetEffect);
					return;
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