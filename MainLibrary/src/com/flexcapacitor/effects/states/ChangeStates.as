

package com.flexcapacitor.effects.states {
	
	import com.flexcapacitor.effects.states.supportClasses.ChangeStatesInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	


	//--------------------------------------
	//  State events
	//--------------------------------------
	
	/**
	 *  Dispatched after the <code>currentState</code> property changes,
	 *  but before the view state changes.
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.StateChangeEvent.CURRENT_STATE_CHANGING
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="currentStateChanging", type="mx.events.StateChangeEvent")]
	
	/**
	 *  Dispatched after the view state has changed.
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.StateChangeEvent.CURRENT_STATE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="currentStateChange", type="mx.events.StateChangeEvent")]
	
	/**
	 *  Dispatched after the component has entered a view state.
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.FlexEvent.ENTER_STATE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="enterState", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched just before the component exits a view state.
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.FlexEvent.EXIT_STATE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="exitState", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched after the component has entered a new state and
	 *  any state transition animation to that state has finished playing.
	 *
	 *  The event is dispatched immediately if there's no transition playing
	 *  between the states.
	 *
	 *  If the component switches to a different state while the transition is
	 *  underway, this event will be dispatched after the component completes the
	 *  transition to that new state.
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.FlexEvent.STATE_CHANGE_COMPLETE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="stateChangeComplete", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched when a component interrupts a transition to its current
	 *  state in order to switch to a new state. 
	 * 
	 *  <p>This event is only dispatched when there are one or more 
	 *  relevant listeners attached to the dispatching object.</p>
	 *
	 *  @eventType mx.events.FlexEvent.STATE_CHANGE_INTERRUPTED
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="stateChangeInterrupted", type="mx.events.FlexEvent")]
	
	/**
	 * Changes to the name of the state specified. 
	 * */
	public class ChangeStates extends ActionEffect {
		
		public static const CURRENT_STATE_CHANGING:String = StateChangeEvent.CURRENT_STATE_CHANGING;
		public static const CURRENT_STATE_CHANGE:String = StateChangeEvent.CURRENT_STATE_CHANGE;
		public static const ENTER_STATE:String = FlexEvent.ENTER_STATE;
		public static const EXIT_STATE:String = FlexEvent.EXIT_STATE;
		public static const STATE_CHANGE_COMPLETE:String = FlexEvent.STATE_CHANGE_COMPLETE;
		public static const STATE_CHANGE_INTERRUPTED:String = FlexEvent.STATE_CHANGE_INTERRUPTED;
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ChangeStates(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ChangeStatesInstance;
		}

		
		/**
		 * Name of state to change to. 
		 * Changes the state of the component assigned to the target property.
		 * */
		public var state:String;
		
		/**
		 * Object that contains the property that contains the name of the state to change to.
		 * */
		public var source:Object;
		
		/**
		 * Property on the source object that contains the name of the state to change to. 
		 * */
		public var sourceProperty:String;
		
		/**
		 * Validate the component after setting the state
		 * */
		public var validateNow:Boolean;
		
		/**
		 * Effect played  
		 * */
		public var currentStateChangingEffect:IEffect;
		
		/**
		 * Effect played if   
		 * */
		public var currentStateChangeEffect:IEffect;
		
		/**
		 * Effect played if   
		 * */
		public var enterStateEffect:IEffect;
		
		/**
		 * Effect played if   
		 * */
		public var exitStateEffect:IEffect;
		
		/**
		 * Effect played if   
		 * */
		public var stateChangeCompleteEffect:IEffect;
		
		/**
		 * Effect played if 
		 * */
		public var stateChangeInterruptedEffect:IEffect;
		
	}
}