

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.SetFormValuesInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	
	/**
	 * Sets the form related components to data (not the android). <br/><br/>
	 * 
	 * INSTRUCTIONS - TO SET THE FORM COMPONENTS TO THE DATA<br/>
	 * 
	 * Add form adapter in declarations
	 * Set form adapter data property to source data
	 * Add form elements to form adapter default tag
	 * Add form components
	 * 
	 * In the form elements set
	 * - target component - id of UI Component, such as myTextInput
	 * - target component property - property on target component that contains the property value, such as "text"
	 * - data - is the variable that has the object that will be edited (can be set in form adapter as well)
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to 
	 * - default value, default index, default selected - default value if target data is null
	 * 
	 * Call this effect, "set form values" effect
	 * */
	public class SetFormValues extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function SetFormValues(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SetFormValuesInstance;
		}
		
		/**
		 * Reference to the Form Adapter instance. Required.
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Data for populating the form.
		 * Usually returned from a service request.
		 * Can be of type XML, Object or your own class. 
		 * */
		public var data:Object;
		
		/**
		 * Name of property on data object. Usually returned from a service request.
		 * Can be of type XML, Object or your own class. 
		 * */
		public var dataProperty:String;
		
		/**
		 * When true sets the default values when the value is null. 
		 * */
		public var useDefaultValues:Boolean = true;
		
		/**
		 * Prevents errors from being dispatched if components have not been created yet. 
		 * */
		public var suppressErrors:Boolean;
	}
}