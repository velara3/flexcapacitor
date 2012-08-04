

package com.flexcapacitor.effects.display.supportClasses {
	import com.flexcapacitor.effects.display.EnableElement;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.IUIComponent;
	
	
	/**
	 *  @copy EnableElement
	 * */  
	public class EnableElementInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function EnableElementInstance(target:Object) {
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
			super.play(); // dispatches startEffect
			
			var action:EnableElement = EnableElement(effect);
			var element:IUIComponent = target as IUIComponent;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!(action.target is IUIComponent)) {
					dispatchErrorEvent("Target must be a UIComponent");
				}
				
				if (!element) {
					dispatchErrorEvent("Target is required");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			element.enabled = action.enabled;
			
			
			///////////////////////////////////////////////////////////
			// End the effect
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