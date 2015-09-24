




package com.flexcapacitor.form {
	import com.flexcapacitor.form.vo.FormElement;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.managers.ToolTipManager;
	import mx.validators.IValidator;
	import mx.validators.Validator;

	/**
	 * Class that handles all form related managing.
	 * Add
	 * Edit
	 * Delete
	 * Validate
	 * */
	public class FormManager {
		
		private static var _instance:FormManager;
		
		public static function get instance():FormManager {
			if (_instance==null) {
				_instance = new FormManager();
			}
			return _instance;
		}
		
		public function FormManager() {
			
		}
		
		
		/**
		 * Reset the form
		 * */
		public function reset(form:FormAdapter):void {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var item:FormElement;
			var target:Object;
			
			// set values of form elements
			for (var i:int;i<length;i++) {
				item = items[i];
				
				FormUtilities.setValue(item.targetComponent, item.targetComponentProperty, item.defaultValue);
			}
		}
		
		/**
		 * Remove item from the form
		 * */
		public function remove(form:FormAdapter):Boolean {
			var items:Object = form.targetList;
			var index:int;
			
			// check if targetList is set
			if (items is XML) {
				// NOT IMPLEMENTED!
				throw new Error("XML not supported yet.");
				//XML(targetList).appendChild(editableItem);
			}
			else if (items is XMLList) {
				items = items as XMLList;
				index = 0;
				
				if (items==null) {
					// no items exist
					return false;
				}
				
				for each (var item:XML in items) {
					if (item==form.data) {
						delete items[index];
					}
					index++;
				}
			}
			else if (items is IList) {
				index = IList(items).getItemIndex(form.data);
				IList(items).removeItemAt(index);// check for -1
			}
			else if (items is Array) {
				throw new Error("Array not supported yet.");
				//(targetList as Array).push(editableItem);
			}
			else if (items is Vector) {
				throw new Error("Vector not supported yet.");
				//Vector.<Class>(targetList).push(editableItem);
			}
			else if (items!=null) {
				// if target list is defined but adding to the target list is not supported
				throw new Error("The target list is not a type that this class can remove items from. You must manually remove the item. See lastRemovedItem.");
			}
			
			// it should be right here that we would call a remove method
			
			form.lastRemovedItem = form.data;
			
			if (form.modeToSwitchToAfterRemove==FormAdapter.CREATE_MODE || form.modeToSwitchToAfterRemove==FormAdapter.EDIT_MODE) {
				gotoMode(form, form.modeToSwitchToAfterRemove);
			}
			
			if (form.hasEventListener(FormAdapter.REMOVE_COMPLETE)) 
				form.dispatchEvent(new Event(FormAdapter.REMOVE_COMPLETE));
			
			return true;
		}
		
		/**
		 * Creates a new item and sets the values of it to the components values in the form elements
		 * */
		public function createRequest(form:FormAdapter, suppressNullTargetErrors:Boolean=false):Object {
			return create(form, suppressNullTargetErrors, true);
		}
		
		/**
		 * Sets the Form Element components to the values in the form data
		 * */
		public function setFormElementsToFormData(form:FormAdapter, suppressNullTargetErrors:Boolean=false):void {
			
			FormUtilities.setComponentsValues(form.data, form.items, true);
			
		}
		
		/**
		 * Creates a new object and sets the values of it to the components values in the form. 
		 * The new object is set to the form data property. The names of the properties on the form data object
		 * are defined in the Form Element dataProperty
		 * */
		public function create(form:FormAdapter, suppressNullTargetErrors:Boolean=false, requestObject:Boolean = false):Object {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var formItem:FormElement;
			var newItem:Object;
			var isXML:Boolean;
			var xmlList:XMLList;
			var position:int = -1;
			
			if (form.newItemClassType=="xml") {
				newItem = new XML(form.defaultXMLItemValue);
			}
			else if (form.newItemClassType) {
				newItem = new form.newItemClassType();
			}
			else {
				newItem = new Object();
			}
			
			isXML = newItem is XML;
			
			// set values of new item
			for (var i:int;i<length;i++) {
				formItem = items[i];
				
				
				// target UI Components may not be created
				if (formItem.targetComponent==null) {
					
					// we can't get a value to submit to the server
					if (suppressNullTargetErrors) {
						// continue to the next item
						continue;
					}
					else {
						// look at the Form Element in the items array in the Form Adapter to see which item is null
						throw new Error("The component at the index " + i + " in the items array is null.");
					}
				}
				
				
				if (formItem.dataProperty.indexOf("@")==0 && !isXML) {
					throw new Error("In the form element the property " + formItem.dataProperty + " indicates an attribute on an XML item. Set the new item class type property.");
				}
				else {
					if (requestObject) {
						
						if (!formItem.requestName) {
							throw new Error("In the request name is not specified in the form element for " + formItem.targetComponent);
						}
						FormUtilities.setValue(newItem, formItem.requestName, formItem.targetComponent[formItem.targetComponentProperty], formItem.wrapValueInCDATATags);
					}
					else {
						FormUtilities.setValue(newItem, formItem.dataProperty, formItem.targetComponent[formItem.targetComponentProperty], formItem.wrapValueInCDATATags);						
					}
				}
				
			}
			
			
			if (requestObject) {
				form.lastRequestObject = newItem;
			}
			else {
				form.lastCreatedItem = newItem;
			}
			
			
			if (form.hasEventListener(FormAdapter.CREATION_COMPLETE)) 
				form.dispatchEvent(new Event(FormAdapter.CREATION_COMPLETE));
			
			
			return newItem;
		}
		
		/**
		 * Adds an item to the target list
		 * */
		public function add(form:FormAdapter, list:Object):Boolean {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var item:FormElement;
			var position:int = -1;
			var xmlList:XMLList;
			var newItem:Object;
			var isXML:Boolean;
			var value:Object;
			
			if (form.newItemClassType=="xml") {
				newItem = new XML(form.defaultXMLItemValue);
			}
			else if (form.newItemClassType) {
				newItem = new form.newItemClassType();
			}
			else {
				newItem = new Object();
			}
			
			isXML = newItem is XML;
			
			// set values of new item
			for (var i:int;i<length;i++) {
				item = items[i];
				
				if (item.dataProperty.indexOf("@")==0 && !isXML) {
					throw new Error("In the form element the property " + item.dataProperty + " requires the new item to be XML. Set the new item class type property.");
				}
				else {
					
					
					if (item.readOnly) continue;
					
					value = item.targetComponent ? item.targetComponent[item.targetComponentProperty] : item.defaultValue;
					FormUtilities.setValue(newItem, item.dataProperty, value, item.wrapValueInCDATATags);
				}
				
			}
			
			form.lastCreatedItem = newItem;
			
			addItemToList(list, newItem);
			
			
			if (form.modeToSwitchToAfterCreate==FormAdapter.CREATE_MODE || form.modeToSwitchToAfterCreate==FormAdapter.EDIT_MODE) {
				gotoMode(form, form.modeToSwitchToAfterCreate);
			}
			
			if (form.hasEventListener(FormAdapter.CREATION_COMPLETE)) 
				form.dispatchEvent(new Event(FormAdapter.CREATION_COMPLETE));
			
			
			return true;
		}
		
		
		/**
		 * Copy values from server data to form data property
		 * */
		public function setFormDataToServerData(form:FormAdapter, data:Object):Object {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var isClientDataXML:Boolean;
			var isServerDataXML:Boolean;
			var formItem:FormElement;
			var newData:Object;
			var xmlList:XMLList;
			var position:int = -1;
			
			if (form.newItemClassType=="xml") {
				newData = new XML(form.defaultXMLItemValue);
			}
			else if (form.newItemClassType) {
				newData = new form.newItemClassType();
			}
			else {
				newData = new Object();
			}
			
			// check the type of the objects
			isClientDataXML = newData is XML;
			isServerDataXML = data is XML;
			
			// Loop through the form elements in the form adapter
			// set values of new item to values in server data
			// we need the data property and the request name
			for (var i:int;i<length;i++) {
				formItem = items[i];
				
				if (!formItem.dataProperty && !formItem.resultName) {
					continue;
				}
				else if (!formItem.dataProperty || !formItem.resultName) {
					throw new Error("To get the data the resultName and the dataProperty need to be set");
				}
				
				if (formItem.dataProperty.indexOf("@")==0 && !isClientDataXML) {
					throw new Error("In the form element the property " + formItem.dataProperty + " indicates an attribute on an XML item but the new item class is not XML.");
				}
				
				// if server data is XML
				// get values from resultData
				// we want to copy data from the server (xml object) into the local client object
				
				FormUtilities.setValue2(newData, formItem.dataProperty, data, formItem.resultName, formItem.wrapValueInCDATATags);
			
				
			}
			
			
			if (data) {
				form.lastCreatedItem = newData;
			}
			
			if (newData) {
				form.data = newData;
			}
			
			
			if (form.hasEventListener(FormAdapter.CREATION_COMPLETE)) 
				form.dispatchEvent(new Event(FormAdapter.CREATION_COMPLETE));
			
			
			return newData;
		}
		
		/**
		 * Adds an item to an array (needs updating)
		 * */
		private function addItemToList(list:Object, item:Object):void {
			if (list is XML) {
				XML(list).appendChild(item);
			}
			else if (list is IList) {
				IList(list).addItem(item);
			}
			else if (list is Array) {
				(list as Array).push(item);
			}
			else if (list is Vector) {
				Vector.<Class>(list).push(item);
			}
			else if (list!=null) {
				// if target list is defined but adding to the target list is not supported
				throw new Error("The target list is not a type that this class can add new items too. You must manually add the new item. See lastAddedItem.");
			}
			else if (list==null) {
				throw new Error("Item cannot be null");
			}
		}
		
		/**
		 * Updates the form data object with the values from the form elements
		 * */
		public function update(form:FormAdapter, itemData:Object=null):Boolean {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var data:Object = form.data || itemData;
			var item:FormElement;
			var value:Object;
			
			if (!data) {
				throw new Error("Form data is not set on the form");
			}
			
			// set values of editable object
			for (var i:int;i<length;i++) {
				item = items[i];
				
				if (item.readOnly) continue;
				
				value = item.targetComponent ? item.targetComponent[item.targetComponentProperty] : item.defaultValue;
				FormUtilities.setValue(data, item.dataProperty, value, item.wrapValueInCDATATags);
				
			}
			
			if (form.hasEventListener(FormAdapter.UPDATE_COMPLETE))
				form.dispatchEvent(new Event(FormAdapter.UPDATE_COMPLETE));
			
			return true;
		}
		
		/**
		 * Updates the target item with the values from the form
		 * */
		public function validate(form:FormAdapter, showHideErrors:Boolean = true, showErrorToolTip:Boolean = true):Boolean {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var item:FormElement;
			var validator:Validator;
			var resultEvent:ValidationResultEvent;
			var result:Array = [];
			var valid:Boolean;
			var formValid:Boolean;
			var errorComponents:Array = [];
			//pt = UIComponent(target.parent).contentToGlobal(pt);
			
			// validate each item with a validator 
			// display or hide error messages
			for (var i:int;i<length;i++) {
				item = items[i];
				
				if (item.validator && item.validator is IValidator) {
					validator = item.validator;
					
					if (validator.source==null) {
						validator.source = item.targetComponent;
						validator.property = item.targetComponentProperty;
					}
					
					resultEvent = validator.validate();
					valid = resultEvent.type == ValidationResultEvent.VALID;
					
					// if invalid add to results array
					if (!valid) {
						result.push(resultEvent);
					}
					
					// used to show or hide errors
					if (showHideErrors) {
						
						// show error tool tip
						if (showErrorToolTip) {
							showErrorImmediately(item.targetComponent as UIComponent);
						}
						
						// show errors in alternative component like a label
						// note: changing the next line to the next line after bc incorrect?
						// if (errorComponents.indexOf(item.errorComponent)) {
						if (item.errorComponent && errorComponents.indexOf(item.errorComponent)==-1) {
							displayErrorMessages(valid, item, resultEvent);
							
							// do not overwrite previous error messages
							if (!valid && item.errorComponent) {
								errorComponents.push(item.errorComponent);
							}
						}
					}
					
				}
				
			}
			
			
			// This is attempting to reorder error messages so when reusing the 
			// same error component the last error message does not over write the first
			
			// used to show or hide errors
/*			if (showHideErrors) {
				
				// display or hide error messages
				for (i=length;i;i--) {
					item = items[i-1];
					
					displayErrorMessages(item, resultEvent);
				}
			}*/
			
			
			if (result.length>0) {
				return false;
			}
			
			return true;
		}
		
		/**
		 * Used to display or hide error messages in a display object
		 * */
		public function displayErrorMessages(valid:Boolean, item:FormElement, resultEvent:ValidationResultEvent):void {
			var message:String = !valid ? item.errorMessage || resultEvent.message : null;
			var errorComponent:Object = item.errorComponent;
			var errorComponentProperty:String = item.errorComponentProperty;
			
			if (errorComponent && errorComponentProperty) {
				
				errorComponent[errorComponentProperty] = message;
				
				if (errorComponent is IUIComponent) {
					errorComponent.includeInLayout = valid ? false : true;
					errorComponent.visible = valid ? false : true;
				}
			}
		}
		
		/**
		 * http://stackoverflow.com/a/1878602/441016
		 * */
		public function showErrorImmediately(target:UIComponent):void {
			
			// we have to callLater this to avoid other fields that send events
			// that reset the timers and prevent the errorTip ever showing up.
			if (target) {
				target.callLater(showDeferred, [target]);
			}
		}
		
		private function showDeferred(target:UIComponent):void {
			var oldShowDelay:Number = ToolTipManager.showDelay;
			ToolTipManager.showDelay = 0;
			
			if (target.visible) {
				// try popping the resulting error flag via the hack 
				// courtesy Adobe bug tracking system
				target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
			
			ToolTipManager.showDelay = oldShowDelay;
		}
		
		/**
		 * Set editable object
		 * */
		public function setFormDataToItem(form:FormAdapter, item:Object):void {
			form.data = form.newItemClassType ? form.newItemClassType(item) : item;
		}
		
		/**
		 * Switches between editing mode to add new item mode (submit mode is the same as add item).
		 * When switching to edit mode we get the values from the 
		 * form data property and place them in the form components.
		 * When switching to add mode we get the values from the 
		 * form element defaultValues and place them in the form components
		 * If the form data object is XML we can get an attribute value
		 * by adding a "@" sign to the first character in the form element dataProperty.
		 * */
		public function gotoMode(form:FormAdapter, value:String):void {
			var items:Vector.<FormElement> = form.items;
			var length:int = items ? items.length : 0;
			var addMode:Boolean = value==FormAdapter.CREATE_MODE || value==FormAdapter.SUBMIT_MODE;
			var item:FormElement;
			var target:Object;
			var i:int;
			
			form.mode = value;
			
			// set values of form elements
			for (i=0;i<length;i++) {
				item = items[i];
				
				// check if target component is null
				// we may be trying to set the form components before they are created
				// you can work around this by adding the same handler actions 
				// on the target component's parent creation complete event 
				// and suppressing the errors until the components are created
				if (item.targetComponent==null) {
					
					if (form.suppressNullTargetErrors)
						break;
					else 
						throw new Error("The target component is null. It may not be created yet.");
				}
				
				
				// if add or submit mode set default values
				if (addMode) {
					FormUtilities.setValue(item.targetComponent, item.targetComponentProperty, item.defaultValue);
				}
				else {
					
					// go into edit mode
					// set form elements to form data property
					if (form.data) {
						//if (form.data is XML && item.dataProperty.indexOf("@")==0) {
						//	FormUtilities.setValue2(item.targetComponent, item.targetComponentProperty, XML(form.data).attribute(item.dataProperty.slice(1)));
						//}
						//else {
							
						FormUtilities.setValue2(item.targetComponent, item.targetComponentProperty, form.data, item.dataProperty);
						//}
					}
					else if (form.data) {
						FormUtilities.setValue(item.targetComponent, item.targetComponentProperty, item.dataProperty);
					}
				}
			}
		}
	}
}