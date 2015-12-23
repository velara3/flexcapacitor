

package com.flexcapacitor.utils {
	import mx.core.IStateClient;
	import mx.core.IStateClient2;
	import mx.core.UIComponent;
	import mx.states.State;

	/**
	 * A class of utilities for working with states
	 * */
	public class StateUtils {
		
		/**
		 * Returns the state with the specified name or state, or null if it doesn't exist.
		 * If multiple states have the same name the first one will be returned.
		 * You can pass in a state instance and if it is a state in the target it will be returned. 
		 * @param name of state or instance of a State
		 */
		public static function getState(target:IStateClient, state:*):State {
			var states:Array = target && "states" in target ? Object(target).states : null;
			
			if (!states || (state is String && isBaseState(state))) {
				return null;
			}
			
			if (state is State) {
				state = ArrayUtils.getItem(states, state); // get state if not found returns null
				return state;
			}
			else if (state is String) {
				state = ArrayUtils.getItem(states, state, "name");
				return state;
			}
			
			return null;
		}
		
		/**
		 * Checks if the component has the State in it's states property 
		 * or if it has a State with the same name 
		 *  @copy mx.core.IStateClient2#hasState() 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function hasState(target:IStateClient, state:*):Boolean {
			var states:Array = target ? Object(target).states : null;
			
			if (state is State && states && states.indexOf(state)!=-1) {
				return true;
			}
			else if (state is String && ArrayUtils.hasItem(states, state, "name")) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Creates a state with the given name. If you pass in a state client target 
		 * it adds the state to the target.
		 * 
		 * This method does not check if a state with the same name exists on the target. 
		 * Use hasState to check before hand.
		 */
		public static function createState(stateName:String, properties:Object = null, target:IStateClient = null):State {
			var state:State = new State(properties);
			state.name = stateName;
			
			if (target) {
				if (Object(target).states==null) {
					Object(target).states = [];
				}
				Object(target).states.push(state);
			}
			
			return state;
		}
		
		/**
		 *  @private
		 *  Returns true if the passed in state name is the 'base' state, which
		 *  is currently defined as null or ""
		 */
		public static function isBaseState(stateName:String):Boolean
		{
			return !stateName || stateName == "";
		}
		
		/**
		 *  @private
		 *  Returns the default state. For Flex 4 and later we return the base
		 *  the first defined state, otherwise (Flex 3 and earlier), we return
		 *  the base (null) state.
		 */
		public static function getDefaultStateName(target:IStateClient):String
		{
			return (target is IStateClient2 && (IStateClient2(target).states.length > 0)) ? IStateClient2(target).states[0].name : null;
		}
		
		/**
		 * Sets the style in the state specified. Creates state if it doesn't exist.
		 * */
		public static function setStyleInState(styleName:String, value:*, state:*, target:UIComponent = null):void {
			var stateName:String = state is String ? state as String : "name" in state ? state.name : null;
			
			if (!StateUtils.hasState(target, state)) {
				state = createState(stateName, null, target);
			}
			else if (!(state is State)) {
				state = getState(target, stateName);
			}
			
			
		}

	}
}