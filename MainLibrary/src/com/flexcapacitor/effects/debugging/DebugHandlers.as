

package com.flexcapacitor.effects.debugging {
	
	import com.flexcapacitor.effects.debugging.supportClasses.DebugHandlersInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.handlers.EventHandler;
	
	
	
	public class DebugHandlers extends ActionEffect {
		
		
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
		public function DebugHandlers(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = DebugHandlersInstance;
		}
		
		/**
		 * Message to trace. Optional
		 * */
		public var message:String;
		
		/**
		 * If true then enters the debugger at the beginning of each event handler
		 * */
		public var enterDebugger:Boolean;
		
		/**
		 * If enabled traces the event handlers as they run. 
		 * To enter the debugger on each event handler set enter debugger to true.
		 * */
		public function set enable(value:Boolean):void {
			EventHandler.debugHandlers = value;
			_enable = value;
		}
		public function get enable():Boolean {
			return EventHandler.debugHandlers;
		}
		private var _enable:Boolean;
	}
}