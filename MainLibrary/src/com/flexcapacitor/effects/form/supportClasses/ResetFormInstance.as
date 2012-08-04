

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.ResetForm;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormUtilities;
	import com.flexcapacitor.form.vo.FormElement;
	
	
	/**
	 * @copy ResetForm
	 * */
	public class ResetFormInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ResetFormInstance(target:Object) {
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
			var action:ResetForm = ResetForm(effect);
			var form:FormAdapter = action.formAdapter;
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var item:FormElement;
			
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
			
			// set values of form elements
			for (var i:int;i<length;i++) {
				item = items[i];
				
				if (item.targetComponent) {
					FormUtilities.setValue(item.targetComponent, item.targetComponentProperty, item.defaultValue);
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