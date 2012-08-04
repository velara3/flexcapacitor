

package com.flexcapacitor.effects.states.supportClasses {
	import com.flexcapacitor.effects.states.ToggleStates;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.UIComponent;
	
	
	
	/**
	 * @copy ToggleStates
	 * */  
	public class ToggleStatesInstance extends ActionEffectInstance {
		
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
		public function ToggleStatesInstance(target:Object) {
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
			
			var action:ToggleStates = ToggleStates(effect);
			var targetStates:Array = action.targetStates;
			var validateNow:Boolean = action.validateNow;
			var component:UIComponent;
			var currentState:String;
			var states:Array;
			var statesLength:int;
			var currentStateIndex:int;
			var targetState:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!action.target) {
					dispatchErrorEvent("Target is null.");
				}
				
				if (!(action.target is UIComponent)) {
					dispatchErrorEvent("Target must be a UIComponent.");
				}
				
				if (!targetStates || targetStates.length<2) {
					dispatchErrorEvent("At least two state names must be provided.");
				}
			}
			
			// get component
			component = UIComponent(action.target);
			
			// get states
			states = targetStates;
			currentState = component.currentState;
			
			// get number of states
			statesLength = states ? states.length : 0;
			
			// get index of current state
			currentStateIndex = states.indexOf(currentState);
			
			// if we are at the last state select the first state
			if (currentStateIndex == statesLength-1) {
				targetState = states[0];
			}
			else {
				// get next state
				targetState = states[currentStateIndex+1];
			}
			
			// check if component has target state
			if (!component.hasState(targetState)) {
				dispatchErrorEvent("Target component does not contain the state " +  targetState);
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// go to the next state
			component.currentState = targetState;
			
			if (validateNow) {
				component.validateNow();
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