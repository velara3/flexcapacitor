

package com.flexcapacitor.effects.states.supportClasses {
	import com.flexcapacitor.effects.states.ChangeStates;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.UIComponent;
	
	/**
	 * @copy StateChange
	 */  
	public class ChangeStatesInstance extends ActionEffectInstance {
		
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
		public function ChangeStatesInstance(target:Object) {
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
			
			
			var action:ChangeStates = ChangeStates(effect);
			var state:String = action.state;
			var validateNow:Boolean = action.validateNow;
			var component:UIComponent = target as UIComponent;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!(target is UIComponent)) {
					dispatchErrorEvent("Target must be a UIComponent. Typically you would set it to {this}");
				}
				
				if (action.state==null && 
					action.source==null && 
					action.sourceProperty==null) {
					dispatchErrorEvent("State name or source and property is required.");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (!state && action.source) {
				if (action.sourceProperty) {
					state = action.source[action.sourceProperty];
				}
				else {
					state = action.source as String;
				}
			}
			
			// go to another state
			if (component.hasState(state)) {
				component.currentState = state;
				
				if (validateNow) {
					component.validateNow();
				}
			}
			else {
				dispatchErrorEvent("Target component does not contain the state " + state);
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