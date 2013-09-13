

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.GetFormElementsValuesInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	
	/**
	 * Gets the values from the form components and stores it in the data property. <br/><br/>
	 * 
	 * TO GET THE FORM COMPONENT VALUES<br/><br/>
	 * 
	 * Add form adapter in declarations<br/>
	 * Add form elements to form adapter default tag<br/>
	 * Add form components<br/><br/>
	 * 
	 * In the form elements set<br/>
	 * - target component - id of UI Component, such as myTextInput<br/>
	 * - target component property - property on target component that contains the property value, such as "text" or selected<br/>
	 * - data - ?is the variable that will contain the value from the component (set in form adapter)<br/>
	 * - data property - name of property on the data object that will contain the target component value<br/>
	 * - default value, default index, default selected - default value if target data is null and use default values is true<br/><br/>
	 * 
	 * Call "get form elements values" effect<br/>
	 * Set data type in effect<br/>
	 * 
	 * */
	public class GetFormElementsValues extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function GetFormElementsValues(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = GetFormElementsValuesInstance;
		}
		
		/**
		 * Reference to the Form Adapter instance. Required.
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Traces data to console
		 * */
		public var inspectData:Boolean;
		
		/**
		 * Populates the data object with default values specified in 
		 * the Form Element object when value is null and this property is true.
		 * */
		public var useDefaultValues:Boolean;
		
		/**
		 * Data from the form elements. You do not set this. 
		 * */
		public var data:Object;
		
		/**
		 * Type of the data object
		 * */
		public var dataType:Class;
	}
}