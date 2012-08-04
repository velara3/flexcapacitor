

package com.flexcapacitor.form.vo {
	import mx.validators.Validator;
	
	
	/**
	 * Used with the Form Adapter class to map the UI component with the
	 * client side object or the server side request.
	 * 
	 * If submitting a form to the server you would set the following:
	 * - target component - id of UI Component, such as TextInput
	 * - target component property - property on target component that contains the property value, such as "text"
	 * - request name - name of property to send to the server, such as firstName
	 * - default value, default index, default selected - default value if any of target UI component
	 * CALL SUBMIT FORM ITEMS TO SERVER
	 * 
	 * If setting the form components to data
	 * - target component - id of UI Component, such as TextInput
	 * - target component property - property on target component that contains the property value, such as "text"
	 * - data - is the variable that has the object that will be edited (set in form adapter)
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to 
	 * - default value, default index, default selected - default value if any of target UI component
	 * CALL SET FORM ITEMS TO DATA
	 * 
	 * If setting the data to form components
	 * - target component - id of UI Component, such as TextInput
	 * - target component property - property on target component that contains the property value, such as "text"
	 * - data - is the variable that has the object that will be edited (set in form adapter)
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to 
	 * - default value, default index, default selected - default value if any of target UI component
	 * CALL SET DATA TO FORM ITEMS
	 * 
	 * If setting the form data to server data
	 * - result data - (set in form adapter) object that has the data from the server. usually the service.lastResult property
	 * - result data property - property on server data that contains the value to place in the data property
	 * - data - (set in form adapter) is the variable that has the object that will be edited (set in form adapter)
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to 
	 * - default value, default index, default selected - default value if any of target UI component
	 * CALL SET DATA TO SERVER DATA
	 * 
	 * If validating target component value
	 * - validator - set to id of a validator declared in declarations
	 * CALL VALIDATE FORM
	 * 
	 * If formatting target component value
	 * - formatter - (not set in Form Element) set target component to a formatter declared in declaration 
	 * 
	 * If displaying validation error
	 * - error component - set to id of component to display when validation error occurs
	 * - error component property - set to property of component that contains the error message
	 * CALL VALIDATE FORM
	 * 
	 * If data needs CDATA tags
	 * - is complex XML - set to true
	 * @copy FormAdapter
	 * */
	public class FormElement extends ItemElement {
		
		public function FormElement() {
			super();
		}
		
		/**
		 * The name of the property on the data object in the form adapter 
		 * that the target component sets its value into. If the data 
		 * property is a reference to a value object than this is the name
		 * of the property on the value object. 
		 * 
		 * For example, if you have a text input that contains a first name, 
		 * then set this property to something descriptive such as "firstName".
		 * 
		 * The data object is a generic object by default. 
		 * */
		public function get dataProperty():String {
			return _dataProperty;
		}
		
		private var _dataProperty:String;
		
		public function set dataProperty(value:String):void {
			_dataProperty = value;
		}
		
		private var _requestName:String;
		
		/**
		 * When submitting a request to the server this is 
		 * the name of the property that will contain the value
		 * */
		public function get requestName():String {
			return _requestName;
		}
		
		public function set requestName(value:String):void
		{
			if (_requestName == value)
				return;
			_requestName = value;
		}
		
		/**
		 * Is used to read only
		 * */
		public var readOnly:Boolean;
		
		/**
		 * Component that contains the form validation results. ie the error messsages
		 * If this is not set than any error messages will display in the form 
		 * error component if it is set.
		 * */
		public var errorComponent:Object;
		
		/**
		 * Property of error component that is set with the error messages. 
		 * */
		public var errorComponentProperty:String;
		
		/**
		 * Message that is set in the error component when validation fails. Optional.
		 * If not set then uses error message from validator. 
		 * */
		public var errorMessage:String;
		
		/**
		 * Reference to the validation object if one exists
		 * */
		public var validator:Validator;
		
		/**
		 * When setting the data object in the form to data from the server this is 
		 * the name of the property in the server result data 
		 * */
		public function get resultName():String
		{
			return _resultName;
		}
		private var _resultName:String;

		/**
		 * @private
		 */
		public function set resultName(value:String):void
		{
			_resultName = value;
		}
		
	}
}