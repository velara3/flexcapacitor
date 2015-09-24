

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.ValidateForm;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormManager;
	
	import flash.events.Event;
	
	
	/**
	 * @copy ValidateForm
	 * */
	public class ValidateFormInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ValidateFormInstance(target:Object) {
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
			
			var action:ValidateForm = effect as ValidateForm;
			var validateForm:Boolean = action.validate;
			var form:FormAdapter = action.formAdapter;
			var valid:Boolean = true;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!form) {
					dispatchErrorEvent("Form adapter property is required.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (validateForm) {
				valid = FormManager.instance.validate(form);
			}
			
			if (valid) {
				
				if (action.hasEventListener(ValidateForm.VALID)) {
					dispatchActionEvent(new Event(ValidateForm.VALID));
				}
				
				if (action.validEffect) {
					playEffect(action.validEffect);
				}
			}
			
			// if not valid
			else {
				if (action.hasEventListener(ValidateForm.INVALID)) {
					dispatchActionEvent(new Event(ValidateForm.INVALID));
				}
				
				if (action.invalidEffect) {
					playEffect(action.invalidEffect);
				}
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