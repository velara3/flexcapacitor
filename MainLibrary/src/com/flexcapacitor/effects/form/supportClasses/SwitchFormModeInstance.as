

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.SwitchFormMode;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.UIComponent;
	
	
	
	/**
	 *  @copy SwitchFormMode
	 */  
	public class SwitchFormModeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function SwitchFormModeInstance(target:Object) {
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
		 */
		override public function play():void { 
			super.play();
			// Dispatch an effectStart event
			var modeToSwitchTo:String;
			var stateToChangeTo:String;
			var switchFormMode:SwitchFormMode = SwitchFormMode(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (!switchFormMode.formAdapter) {
				cancel();
				throw new Error("Form adapter property is required.");
			}
			
			if (switchFormMode.modeToSwitchTo==null) {
				cancel();
				throw new Error("Destination Form mode is required.");
			}
			
			if (switchFormMode.stateToChangeTo && switchFormMode.view==null 
				|| !(switchFormMode.view is UIComponent)) {
				cancel();
				throw new Error("A view is required if state to change to is set.");
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			switchFormMode.formAdapter.mode = modeToSwitchTo;
			
			// go to another state
			if (switchFormMode.stateToChangeTo) {
				// if you get an error on this line check the spelling of the state name
				switchFormMode.view.currentState = switchFormMode.stateToChangeTo;
			}
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}