

package com.flexcapacitor.effects.debugging.supportClasses {
	import com.flexcapacitor.effects.debugging.Trace;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	
	/**
	 *  @copy Trace
	 * */  
	public class TraceInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function TraceInstance(target:Object) {
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
		 * */
		override public function play():void { 
			super.play();
			var action:Trace = Trace(effect);
			var traceMessage:String = "";
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			// we do
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.message) {
				traceMessage += action.message;
			}
			
			if (action.target && action.targetPropertyName) {
				traceMessage += "" + action.target[action.targetPropertyName];
			}
			
			trace(traceMessage);
			
			
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