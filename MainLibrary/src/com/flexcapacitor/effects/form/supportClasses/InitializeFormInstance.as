

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.InitializeForm;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	
	/**
	 *  @copy InitializeForm
	 * */  
	public class InitializeFormInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function InitializeFormInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:InitializeForm = InitializeForm(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!action.formAdapter) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				
				if (action.modeToStartIn==null && action.defaultMode==null) {
					cancel();
					// mode is null. if we use binding this may be a valid value
					dispatchErrorEvent("If mode to switch to will ever be null then the default mode must be set.");
				}
				
				if ((action.stateToChangeTo || action.defaultStateName) && action.view==null) {
					dispatchErrorEvent("A view is required if the state to change to property is set.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (action.editableItem) {
				if (action.editableItemProperty) {
					action.formAdapter.data = action.editableItem[action.editableItemProperty];
				}
				else {
					action.formAdapter.data = action.editableItem;
				}
			}
			
			if (action.suppressNullTargetErrors) 
				action.formAdapter.suppressNullTargetErrors = action.suppressNullTargetErrors;
			
			if (action.modeToStartIn) 
				action.formAdapter.mode = action.modeToStartIn;
			else 
				action.formAdapter.mode = action.defaultMode;
			
			// go to another state
			if (action.stateToChangeTo) {
				// if you get an error on this line check the spelling of the state name
				action.view.currentState = action.stateToChangeTo;
			}
			
			
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