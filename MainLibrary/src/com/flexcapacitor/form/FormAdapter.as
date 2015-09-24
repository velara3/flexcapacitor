

package com.flexcapacitor.form {
	
	
	import com.flexcapacitor.form.vo.FormElement;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatched after a new item has been added. Check for lastAddedItem
	 * */
	[Event(name="addComplete", type="flash.events.Event")]
	
	/**
	 * Dispatched after a existing item has been edited. Check for editableObject
	 * */
	[Event(name="editComplete", type="flash.events.Event")]
	
	/**
	 * Dispatched after the form has been submitted. Check for editableObject
	 * */
	[Event(name="submitComplete", type="flash.events.Event")]
	
	[DefaultProperty("items")]
	
	/**
	 * The Form Adapter class helps you add, remove, update and submit
	 * data in your forms. It helps you map the client side value object
	 * with the client side components and server side request objects.<br/><br/>
	 * 
	 * Use with the Form Manager.<br/><br/>
	 * 
	 * It helps you in the following: <br/>
	 *  - submit the form items to the server<br/>
	 *  - set the names of the elements submitted to the server<br/>
	 *  - validate the values before submitting to the server<br/>
	 *  - display errors when values are invalid<br/>
	 *  - display errors when values are required<br/>
	 *  - display errors when server form is not submitted<br/>
	 *  - reset and clear form items to default values<br/>
	 *  - set form items to the values in a client side object<br/>
	 *  - edit values in a client side object<br/>
	 *  - remove a client side object from a client side array or list it is part of<br/><br/>
	 * 
	 * Usage:<br/><br/>
	 * 
	 * If submitting a form to the server you would set the following:<br/>
	 * - target component - id of UI Component, such as TextInput<br/>
	 * - target component property - property on target component that contains the property value, such as "text"<br/>
	 * - request name - name of property to send to the server, such as firstName<br/>
	 * - default value, default index, default selected - default value if any of target UI component<br/>
	 * CALL SUBMIT FORM ITEMS TO SERVER METHOD<br/>
	 * 
	 * If setting the form components to data object<br/><br/>
	 * Add form adapter<br/>
	 * Add form items <br/>
	 * In the form items set<br/>
	 * - target component - id of UI Component, such as myTextInput<br/>
	 * - target component property - property on target component that contains the property value, such as "text"<br/>
	 * - data - is the variable that has the object that will be edited (set in form adapter)<br/>
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to<br/> 
	 * - default value, default index, default selected - default value if any of target UI component<br/>
	 * CALL SET FORM ITEMS TO DATA METHOD<br/><br/>
	 * 
	 * If setting a data object to form components values<br/>
	 * - target component - id of UI Component, such as TextInput<br/>
	 * - target component property - property on target component that contains the property value, such as "text"<br/>
	 * - data - is the variable that has the object that will be edited (set in form adapter)<br/>
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to<br/> 
	 * - default value, default index, default selected - default value if any of target UI component<br/>
	 * CALL SET DATA TO FORM ITEMS METHOD<br/><br/>
	 * 
	 * If setting the data to server data<br/>
	 * - result data - (set in form adapter) object that has the data from the server. usually the service.lastResult property<br/>
	 * - result data property - property on server data that contains the value to place in the data property<br/>
	 * - data - (set in form adapter) is the variable that has the object that will be edited (set in form adapter)<br/>
	 * - data property - name of property on the data object that the target component gets the value from and sets its own value to<br/> 
	 * - default value, default index, default selected - default value if any of target UI component<br/>
	 * CALL SET DATA TO SERVER DATA METHOD<br/><br/>
	 * 
	 * If validating target component value<br/>
	 * - validator - set to id of a validator declared in declarations<br/>
	 * CALL VALIDATE FORM METHOD<br/>
	 * 
	 * If formatting target component value<br/>
	 * - formatter - (not set in Form Element) set target component to a formatter declared in declaration<br/><br/> 
	 * 
	 * If displaying validation error<br/>
	 * - error component - set to id of component to display when validation error occurs<br/>
	 * - error component property - set to property of component that contains the error message<br/>
	 * CALL VALIDATE FORM METHOD<br/><br/>
	 * 
	 * If data needs CDATA tags<br/>
	 * - is complex XML - set to true<br/>
	 * */
	public class FormAdapter extends EventDispatcher {
		
		public function FormAdapter(target:IEventDispatcher=null) {
			super(target);
			
		}
		
		public static const CREATE_MODE:String = "create";
		public static const EDIT_MODE:String = "edit";
		public static const SUBMIT_MODE:String = "submit";
		
		public static const CREATION_COMPLETE:String = "creationComplete";
		public static const SUBMIT_COMPLETE:String = "submitComplete";
		public static const UPDATE_COMPLETE:String = "updateComplete";
		public static const REMOVE_COMPLETE:String = "removeComplete";
		
		private var _mode:String = CREATE_MODE;

		/**
		 * List of form elements that map value objects to components and vice versa
		 * */
		public var items:Vector.<FormElement> = new Vector.<FormElement>();
		
		/**
		 * Type of class to use when creating new items. 
		 * The default is an object. If set to the string "xml" then 
		 * it creates an XML class using the defaultXMLItemValue;
		 * If the value is set to anything else then it attempts to create an instance
		 * of the class using newItemClassType();
		 * Be sure to pass in a reference to the class and not a string with the exception being "xml".
		 * */
		public var newItemClassType:Object;
		
		/**
		 * Value to use when creating an new XML item
		 * */
		public var defaultXMLItemValue:String = "<item/>";
		
		/**
		 * Component that contains the form validation results. ie the error messsages
		 * If this is set than it will receive all error messages for any FormElement 
		 * that does not define a error component.
		 * */
		public var errorComponent:Object;
		
		/**
		 * Property of error component that is set with the error messages. 
		 * */
		public var errorComponentProperty:String;
		
		public function get lastRemovedItem():Object {
			return _lastRemovedItem;
		}
		
		private var _lastRemovedItem:Object;

		public function set lastRemovedItem(value:Object):void {
			_lastRemovedItem = value;
		}

		/**
		 * The form adapter copies values into the components. But if the 
		 * components haven't been created yet we will receive errors. 
		 * The alternative is to set this property to true and add 
		 * set the mode later after the components have been created.
		 * Usually this is by adding a second event listener to a parent
		 * of the target components on the creation complete event.
		 * */
		public function get suppressNullTargetErrors():Boolean {
			return _suppressNullTargetErrors;
		}
		
		private var _suppressNullTargetErrors:Boolean;
		
		/**
		 * @private
		 */
		public function set suppressNullTargetErrors(value:Boolean):void {
			_suppressNullTargetErrors = value;
		}

		/**
		 * Mode to switch to after adding a new item
		 * */
		[Inspectable(enumeration="update, create, submit, none", arrayType="String")]
		public function set modeToSwitchToAfterCreate(value:String):void {
			_modeToSwitchToAfterCreate = value;
		}
		
		private var _modeToSwitchToAfterCreate:String;
		
		/**
		 * @private
		 * */
		public function get modeToSwitchToAfterCreate():String {
			return _modeToSwitchToAfterCreate;
		}
		
		/**
		 * Mode to switch to after submitting the form
		 * */
		[Inspectable(enumeration="update, create, submit, none", arrayType="String")]
		public function set modeToSwitchToAfterSubmit(value:String):void {
			_modeToSwitchToAfterCreate = value;
		}
		
		private var _modeToSwitchToAfterSubmit:String;
		
		/**
		 * @private
		 * */
		public function get modeToSwitchToAfterSubmit():String {
			return _modeToSwitchToAfterSubmit;
		}
		
		/**
		 * Mode to switch to after updating an item
		 * */
		[Inspectable(enumeration="update, create, submit, none", arrayType="String")]
		public function set modeToSwitchToAfterUpdate(value:String):void {
			_modeToSwitchToAfterUpdate = value;
		}
		
		private var _modeToSwitchToAfterUpdate:String;
		
		/**
		 * @private
		 * */
		public function get modeToSwitchToAfterUpdate():String {
			return _modeToSwitchToAfterUpdate;
		}
		
		/**
		 * Mode to switch to after removing an item
		 * */
		[Inspectable(enumeration="update, create, submit, none", arrayType="String")]
		public function set modeToSwitchToAfterRemove(value:String):void {
			_modeToSwitchToAfterRemove = value;
		}
		
		private var _modeToSwitchToAfterRemove:String;
		
		/**
		 * @private
		 * */
		public function get modeToSwitchToAfterRemove():String {
			return _modeToSwitchToAfterRemove;
		}
		
		/**
		 * Current object that will be updated when update method is called
		 * and object that is used to set the values of the form elements 
		 * */
		public function set data(value:Object):void {
			_data = value;
		}
		
		private var _data:Object;
		
		public function get data():Object {
			return _data;
		}
		
		/**
		 * Last item that was created by this form
		 * */
		public function set lastCreatedItem(value:Object):void {
			if (_lastCreatedItem!=value) {
				_lastCreatedItem = value;
			}
		}
		
		private var _lastCreatedItem:Object;
		
		public function get lastCreatedItem():Object {
			return _lastCreatedItem;
		}
		
		private var _lastRequestObject:Object;
		public function get lastRequestObject():Object { return _lastRequestObject; }
		
		/**
		 * Last request data that was created by this form
		 * */
		public function set lastRequestObject(value:Object):void
		{
			if (_lastRequestObject == value)
				return;
			_lastRequestObject = value;
		}
		
		
		/**
		 * Reference to the targetList. If the list is an XMLList then it is
		 * appended to the end of the list. Supports IList, array and vector.
		 * */
		public var targetList:Object;
		public var dataType:String;
		
		
		/**
		 * Sets the form to either support editing or creating a new item.
		 * In editing mode the values are pulled from the input properties
		 * In add mode the values are pulled from the add mode
		 * */
		[Inspectable(enumeration="edit, add, submit", arrayType="String")]
		public function set mode(value:String):void {
			
			// we always go to the mode in case the form has been tampered
			_mode = value;
		}
		
		/**
		 * @private
		 * */
		public function get mode():String {
			return _mode;
		}
	}
}