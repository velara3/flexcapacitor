

package com.flexcapacitor.effects.debugging {
	import com.flexcapacitor.effects.debugging.supportClasses.EnterDebuggerInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Enters the debugger 
	 * */
	public class EnterDebugger extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function EnterDebugger(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = EnterDebuggerInstance;
		}
		
		/**
		 * Message to trace. Optional
		 * */
		public var message:String;
		
		/**
		 * If false then does not enter the debugger
		 * */
		public var enabled:Boolean = true;
		
	}
}