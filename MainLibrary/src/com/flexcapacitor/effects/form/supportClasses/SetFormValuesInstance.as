

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.SetFormValues;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormUtilities;
	import com.flexcapacitor.form.vo.FormElement;
	
	/**
	 * @copy SetFormValues
	 * */  
	public class SetFormValuesInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SetFormValuesInstance(target:Object) {
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
			
			var action:SetFormValues = SetFormValues(effect);
			var formAdapter:FormAdapter = action.formAdapter;
			var useDefaultValues:Boolean = action.useDefaultValues;
			var elements:Vector.<FormElement>;
			var data:Object = action.data || formAdapter.data;
			var targetComponent:Object;
			var componentPropertyName:String;
			var suppressErrors:Boolean;
			var valid:Boolean = true;
			var length:int;
			var item:FormElement;
			var value:*;
			var i:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!formAdapter) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				
				// if we can't use default values and the data property is null
				if (!useDefaultValues && !data ) {
					dispatchErrorEvent("Data cannot be null if form adapter data is null and use default value property is false.");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			elements = formAdapter.items;
			length = elements.length;
			suppressErrors = action.suppressErrors;
			
			// set values of form elements
			for (i=0;i<length;i++) {
				item = elements[i];
				
				// data can be null for a variety of reasons (for example data binding)
				if (data) {
					value = data[item.dataProperty];
				}
				else {
					value = null;
				}
				
				componentPropertyName = item.targetComponentProperty;
				
				if (useDefaultValues && (value==null || value=="")) {
					
					// list based
					if (componentPropertyName=="selectedIndex") {
						value = item.defaultSelectedIndex;
					}
					
					// checkbox or toggle button
					else if (componentPropertyName=="selected") {
						value = item.defaultSelected;
					}
					
					// text or other
					else {
						value = item.defaultValue;
					}
				}
				
				// cast to type
				// for example cast XML to String (otherwise it may return as XML or XMLList
				if (item.valueType && value!=null) {
					value = item.valueType(value);
				}
				
				targetComponent = item.targetComponent;
				
				// check if target component is null
				// we may be trying to set the form components before they are created
				// you can work around this by adding the same handler actions 
				// on the target component's parent creation complete event 
				// and suppressing the errors until the components are created
				// which happens when listening to a data change event which 
				// is set before components are created
				
				// the item holds the pending value
				// when the target is created data binding sets the value at that time
				// look in DataElement.target setter
				if (targetComponent==null) {
					
					
					if (suppressErrors) {
						item.pendingSetting = true;
						item.pendingValue = value;
						continue;
					}
					else {
						dispatchErrorEvent("The target component is null. It may not be created yet. Enable suppress errors for components that are not created yet.");
					}
				}
				
				
				FormUtilities.setValue(targetComponent, componentPropertyName, value, item.wrapValueInCDATATags);
				
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