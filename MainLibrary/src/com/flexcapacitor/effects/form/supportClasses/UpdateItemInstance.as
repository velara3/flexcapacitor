

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.UpdateItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormManager;
	
	import flash.events.Event;
	
	
	/**
	 * @copy UpdateItem
	 * */
	public class UpdateItemInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function UpdateItemInstance(target:Object) {
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
			
			var valid:Boolean = true;
			var action:UpdateItem = effect as UpdateItem;
			var validateForm:Boolean = action.validate;
			var form:FormAdapter = action.formAdapter;
			var data:Object = form.data || action.data;
			var array:Object = action.targetList || form.targetList;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!form) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				if (!array) {
					dispatchErrorEvent("The target list is required in the form or effect.");
				}
				if (!data) {
					dispatchErrorEvent("Form adapter data property must be set to the data being updated.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (validateForm) {
				valid = FormManager.instance.validate(form);
			}
			
			if (valid) {
				FormManager.instance.update(form, data);
				
				action.updatedItem = form.data;
				
				if (action.hasEventListener(UpdateItem.VALID)) {
					dispatchEvent(new Event(UpdateItem.VALID));
				}
				
				if (action.validEffect) {
					playEffect(action.validEffect)
				}
				
				if (action.hasEventListener(UpdateItem.UPDATED)) {
					dispatchEvent(new Event(UpdateItem.UPDATED));
				}
				
				if (action.updatedEffect) {
					playEffect(action.updatedEffect);
				}
			}
			
			// if not valid
			else {
				if (action.hasEventListener(UpdateItem.INVALID)) {
					dispatchEvent(new Event(UpdateItem.INVALID));
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