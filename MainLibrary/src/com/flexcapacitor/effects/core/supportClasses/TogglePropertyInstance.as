

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.ToggleProperty;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.TypeUtils;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.effects.Effect;
	import mx.effects.IEffect;
	
	
	
	/**
	 *  @copy ToggleProperty
	 */  
	public class TogglePropertyInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 */
		public function TogglePropertyInstance(target:Object) {
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
		 */
		override public function play():void { 
			super.play(); // Dispatch an effectStart event
			
			var action:ToggleProperty = ToggleProperty(effect);
			var values:Array = action.toggleValues;
			var length:int = values.length;
			var currentValue:Object;
			var valueType:String;
			var targetValue:Object;
			var index:int;
			var effectIndex:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!action.target) {
					dispatchErrorEvent("Target is null.");
				}
				
				if (!action.toggleValues || action.toggleValues.length<2) {
					dispatchErrorEvent("At least two values must be provided.");
				}
				
				if (!action.targetPropertyName || !(action.targetPropertyName in action.target)) {
					dispatchErrorEvent("The target property is not set or defined on the target");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// get current value
			currentValue = TypeUtils.getTypedValue(action.target[action.targetPropertyName]);
			
			// get index of current value
			index = values.indexOf(currentValue);
			
			if (index==-1) {
				valueType = TypeUtils.getValueType(currentValue);
				
				if (valueType=="Boolean") {
					index = values.indexOf(String(currentValue));
				}
				else if (valueType=="int" || valueType=="Number") {
					index = values.indexOf(String(currentValue));
				}
				
				if (index==-1) {
					dispatchErrorEvent("The targets current value of '" + currentValue + "' is not one listed in the toggle values");
				}
			}
			
			
			
			// set target property to the new value
			if (action.updateTargetProperty) {
				
				// if we are at the last value set the first value
				if (index == length-1) {
					effectIndex = 0;
					targetValue = TypeUtils.getTypedValue(values[0], valueType);
				}
				else {
					// get next value
					effectIndex = index+1;
					targetValue = TypeUtils.getTypedValue(values[effectIndex], valueType);
				}
				
				// update target property
				action.target[action.targetPropertyName] = targetValue;
				action.data = targetValue;
				
				
				if (action.hasEventListener(Event.CHANGE)) {
					action.dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else {
				// if we don't update the target we don't advance the effect index
				effectIndex = index;
			}
			
			// check if effect is set for item
			if (action.effects && action.effects.length>0) {
				if (effectIndex <=action.effects.length-1) {
					
					if (action.effects[index] && IEffect(action.effects[index]).isPlaying) {
						IEffect(action.effects[index]).end();
					}
					
					action.effects[effectIndex].play();
				}
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
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