

package com.flexcapacitor.effects.debugging {
	import com.flexcapacitor.effects.debugging.supportClasses.TraceInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Displays a message in the console
	 * */
	public class Trace extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function Trace(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = TraceInstance;
		}
		
		/**
		 * Contents to trace
		 * */
		public var message:String;
		
		/**
		 * Used to trace out the value of the property on the target with the 
		 * name specified.
		 * */
		public var targetPropertyName:String;
		
	}
}