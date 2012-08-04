

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.GetFormElementsValues;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormUtilities;
	import com.flexcapacitor.form.vo.FormElement;
	
	import mx.core.ClassFactory;
	
	
	/**
	 *  @copy GetFormELementsValues
	 */  
	public class GetFormElementsValuesInstance extends ActionEffectInstance {
		
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
		public function GetFormElementsValuesInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:GetFormElementsValues = GetFormElementsValues(effect);
			var formAdapter:FormAdapter = action.formAdapter;
			var elements:Vector.<FormElement>;
			var useDefaultValues:Boolean;
			var suppressErrors:Boolean;
			var data:Object;
			var isXML:Boolean;
			var length:int;
			var complexData:Boolean;
			var item:FormElement;
			var i:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) { // validating effect NOT validating form
				if (!action.formAdapter) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			elements = formAdapter.items;
			length = elements.length;
			useDefaultValues = action.useDefaultValues;
			
			// create data object
			if (formAdapter.dataType is XML) {
				data = new XML(formAdapter.defaultXMLItemValue);
				isXML = data is XML;
			}
			else if (formAdapter.dataType) {
				data = ClassFactory(formAdapter.dataType).newInstance();
			}
			else {
				data = new Object();
			}
			
			
			// set values of data object
			for (i;i<length;i++) {
				item = elements[i];
				
				
				// target UI Components may not be created
				if (item.targetComponent==null) {
					
					// some form components can exist in other states and not be created yet
					// we should not require all the components in a form to be created before
					// getting the value 
					
					// for example, if shipping address is same as billing address 
					// you would not need to create the shipping address components
					if (suppressErrors) {
						// continue to the next item
						continue;
					}
					else {
						// look at the Form Element in the items array in the Form Adapter to see which item is null
						dispatchErrorEvent("The component at the index " + i + " in the Form Elements array is null.");
					}
				}
				
				
				if (item.dataProperty.indexOf("@")==0 && !isXML) {
					dispatchErrorEvent("In the form element the property " + item.dataProperty + " indicates an attribute on an XML item. Set the new item class type property.");
				}
				
				if (!(item.targetComponentProperty in item.targetComponent)) {
					dispatchErrorEvent("In the form element for " + item.dataProperty + " the property " + item.targetComponentProperty + " does not exist on the target component.");
				}
				
				FormUtilities.setValue(data, item.dataProperty, item.targetComponent[item.targetComponentProperty], item.wrapValueInCDATATags);						
				
			}
			
			action.data = data;
			
			///////////////////////////////////////////////////////////
			// Continue with action
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