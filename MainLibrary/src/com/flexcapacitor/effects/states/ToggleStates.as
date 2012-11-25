

package com.flexcapacitor.effects.states {
	
	import com.flexcapacitor.effects.states.supportClasses.ToggleStatesInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Toggles between one or more states on the component specified 
	 * in the order the states are listed. <br/><br/>
	 * Usage:
<pre>
	&lt;states:ToggleStates target="{this}" targetStates="{['home','library']}"/>
</pre>
	 * */
	public class ToggleStates extends ActionEffect {
		
		
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
		public function ToggleStates(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ToggleStatesInstance;
		}

		
		/**
		 * Name of states to toggle between. Can be more than just 2 states. 
		 * When more than 2 states are provided then they will be changed in the order.
		 * Note: Naming this property to "states" caused errors with the compiler so it
		 * is called targetStates
		 * */
		public var targetStates:Array;
		
		/**
		 * Validate the component after setting the state
		 * */
		public var validateNow:Boolean;
		
		
	}
}