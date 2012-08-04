

package com.flexcapacitor.form.vo {
	import com.flexcapacitor.form.FormUtilities;
	
	/**
	 * This class is used to store values for connecting the UI Component 
	 * to the form
	 * */
	public class ItemElement {
		
		
		public function ItemElement() {
			
		}
		
		/**
		 * @private
		 * */
		private var _targetComponent:Object;

		/**
		 * The UI component that displays and edits the value
		 * */
		public function get targetComponent():Object {
			return _targetComponent;
		}

		/**
		 * @private
		 */
		public function set targetComponent(value:Object):void {
			
			if (_targetComponent==value) return;
			
			_targetComponent = value;
			
			if (pendingSetting) { // if the value is XML we may need to cast to a string
				
				// cast to type
				// for example cast XML to String (otherwise it may return as XML or XMLList
				if (valueType && pendingValue!=null) {
					pendingValue = valueType(pendingValue);
				}
				
				FormUtilities.setValue(targetComponent, targetComponentProperty, pendingValue, wrapValueInCDATATags);
			}
		}

		
		/**
		 * The property of the target UI component that contains the value to be edited
		 * Default is "text".
		 * */
		public var targetComponentProperty:String = "text";
		
		/**
		 * This is the default value used when a default value is requested
		 * Note: If using a checkbox or list based component use default selected
		 * or default selected index;
		 * */
		public var defaultValue:String = "";
		
		/**
		 * This is the default value used when a default value is requested
		 * and the target component is a checkbox
		 * Note: If not using a checkbox or using a list based component use default value
		 * or default selected index;
		 * */
		public var defaultSelected:Boolean;
		
		/**
		 * This is the default value used when a default value is requested
		 * and the target component is list based
		 * Note: If not using a list or using a checkbox  use default selected
		 * or default value;
		 * */
		public var defaultSelectedIndex:int;
		
		/**
		 * When we attempt to set the value of the target component but it isn't created yet 
		 * then we set this flag to true so when it is created we can set the value
		 * at a later time. Using databinding we are notified when the component
		 * is created and set the value then.
		 * The value is stored in the pending value property.
		 * */
		public var pendingSetting:Boolean;
		
		/**
		 * Stores the value that will be set in the component when it is created.
		 * @see pendingSetting
		 * */
		public var pendingValue:Object;
		
		/**
		 * Description for readability or to display with the form element. 
		 * */
		[Bindable]
		public var description:String;
		
		/**
		 * When this property is true and when the form data object is XML then
		 * wrap the value in CDATA tags.
		 * */
		public var wrapValueInCDATATags:Boolean;
		
		/**
		 * Value type. Optional. 
		 * For example, XML switches automatically between XML and XMLList when there is 
		 * one item. We may want to get the String contents of the XML. To do that 
		 * we may have to cast to String.
		 * */
		public var valueType:Class;
	}
}