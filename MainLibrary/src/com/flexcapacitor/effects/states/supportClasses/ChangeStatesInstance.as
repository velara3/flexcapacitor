

package com.flexcapacitor.effects.states.supportClasses {
	import com.flexcapacitor.effects.states.ChangeStates;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
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
		
		protected var changeCompleted:Boolean;
		
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
				addListeners(component);
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
			
			// if component state hasn't dispatched stateChangeComplete or stateChangeInterrupted
			// yet and there are effects set to use them then wait until these events occur
			// In experimental stage
			if (!changeCompleted && 
				(action.stateChangeCompleteEffect || action.stateChangeInterruptedEffect)) {
				waitForHandlers();
			}
			else {
				finish();
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		public function addListeners(component:UIComponent):void {
			var action:ChangeStates = ChangeStates(effect);
			
			// we are adding listeners for every state event
			component.addEventListener(ChangeStates.CURRENT_STATE_CHANGE, 	currentStateChangeHandler, false, 0, true);
			component.addEventListener(ChangeStates.CURRENT_STATE_CHANGING, currentStateChangingHandler, false, 0, true);
			component.addEventListener(ChangeStates.ENTER_STATE, 			enterStateHandler, false, 0, true);
			component.addEventListener(ChangeStates.EXIT_STATE, 			exitStateChangeHandler, false, 0, true);
			component.addEventListener(ChangeStates.STATE_CHANGE_COMPLETE, 	stateChangeCompleteHandler, false, 0, true);
			component.addEventListener(ChangeStates.STATE_CHANGE_INTERRUPTED, stateChangeInterruptedHandler, false, 0, true);
			
		}
		
		/**
		 * 
		 * */
		protected function stateChangeInterruptedHandler(event:FlexEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			removeListeners(component);
			changeCompleted = true;
			
			if (action.hasEventListener(ChangeStates.STATE_CHANGE_INTERRUPTED)) {
				dispatchActionEvent(event);
			}
			
			if (action.stateChangeInterruptedEffect) {
				playEffect(action.stateChangeInterruptedEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * 
		 * */
		protected function stateChangeCompleteHandler(event:FlexEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			removeListeners(component);
			changeCompleted = true;
			
			if (action.hasEventListener(ChangeStates.STATE_CHANGE_COMPLETE)) {
				dispatchActionEvent(event);
			}
			
			if (action.stateChangeCompleteEffect) {
				playEffect(action.stateChangeCompleteEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Exit state
		 * */
		protected function exitStateChangeHandler(event:FlexEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			
			if (action.hasEventListener(ChangeStates.EXIT_STATE)) {
				dispatchActionEvent(event);
			}
			
			if (action.exitStateEffect) {
				playEffect(action.exitStateEffect);
			}
		}
		
		/**
		 * Enter state
		 * */
		protected function enterStateHandler(event:FlexEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			
			if (action.hasEventListener(ChangeStates.ENTER_STATE)) {
				dispatchActionEvent(event);
			}
			
			if (action.enterStateEffect) {
				playEffect(action.enterStateEffect);
			}
		}
		
		/**
		 * Current state changing
		 * */
		protected function currentStateChangingHandler(event:StateChangeEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			
			if (action.hasEventListener(ChangeStates.CURRENT_STATE_CHANGING)) {
				dispatchActionEvent(event);
			}
			
			if (action.currentStateChangingEffect) {
				playEffect(action.currentStateChangingEffect);
			}
		}
		
		/**
		 * Current state change
		 * */
		protected function currentStateChangeHandler(event:StateChangeEvent):void {
			var action:ChangeStates = ChangeStates(effect);
			var component:UIComponent = target as UIComponent;
			
			
			if (action.hasEventListener(ChangeStates.CURRENT_STATE_CHANGE)) {
				dispatchActionEvent(event);
			}
			
			if (action.currentStateChangeEffect) {
				playEffect(action.currentStateChangeEffect);
			}
			
		}
		
		/**
		 * 
		 * */
		public function removeListeners(component:UIComponent):void {
			var action:ChangeStates = ChangeStates(effect);
			
			component.removeEventListener(ChangeStates.CURRENT_STATE_CHANGE, 	currentStateChangeHandler);
			component.removeEventListener(ChangeStates.CURRENT_STATE_CHANGING, 	currentStateChangingHandler);
			component.removeEventListener(ChangeStates.ENTER_STATE, 			enterStateHandler);
			component.removeEventListener(ChangeStates.EXIT_STATE, 				exitStateChangeHandler);
			component.removeEventListener(ChangeStates.STATE_CHANGE_COMPLETE, 	stateChangeCompleteHandler);
			component.removeEventListener(ChangeStates.STATE_CHANGE_INTERRUPTED, stateChangeInterruptedHandler);
			
		}
		
	}
}