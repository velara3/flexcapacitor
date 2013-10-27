

package com.flexcapacitor.effects.debugging.supportClasses {
	import com.flexcapacitor.effects.debugging.Trace;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.utils.ObjectUtil;
	
	
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
			var message:String = "";
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			// we do
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.message) {
				message += action.message;
			}
			
			if (action.target && action.targetPropertyName) {
				message += "" + ObjectUtil.toString(action.target[action.targetPropertyName]);
			}
			
			if (action.data) {
				message += "\n" + ObjectUtil.toString(action.data);
			}
			
			if (action.data==null && action.showNullData) {
				message += ". Data is null.";
			}
			
			traceMessage(message);
			
			
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