

package com.flexcapacitor.effects.states {
	
	import com.flexcapacitor.effects.states.supportClasses.ChangeStatesInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Changes to the name of the state specified. 
	 * */
	public class ChangeStates extends ActionEffect {
		
		
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
		
	}
}