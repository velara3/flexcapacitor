

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.CopyValueInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.utils.TypeUtils;
	
	/**
	 * Copies the value in the data property to the target object.
	 * If data is null then an error is thrown. 
	 * If allowNullValues is true and data is null then no error is thrown. 
	 * if allowNullValues is true and data is null and useDefaultValues is true 
	 * then the value the defaultValue property is used. 
	 * If the target is null then an error is thrown
	 * If suppressErrors is true then no error is thrown.
	 * If the target is assigned by databinding  
	 * and suppressErrors is true then when the target is
	 * created and databinding triggers it is assigned the values from when the 
	 * effect originally ran. For example, if you set values at application creation complete
	 * and the component is in another deferred state then we can't set any values until it is created.
	 * So the value is stored. When we switch to another state and the component is created it triggers databinding 
	 * on this effect and the value we stored is then copied into it.
	 * When the target is XML and the wrapValueInCDATATags 
	 * is true then the value is enclosed in CDATA tags.
	 * 
	 * @see CopyPreviousToNext
	 * @see CopyValueToTarget
	 * */
	public class CopyValue extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function CopyValue(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = CopyValueInstance;
		}
		
		/**
		 * Name of property on target object. See source and sourcePropertyName.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Alternative data object. Used if source property is not set.
		 * If this value is being used and it is null you can set the 
		 * useDefaultValue to true to prevent errors and assign 
		 * the default value.
		 * */
		public var data:Object;
		
		/**
		 * Name of property on source object. If the property is an array then 
		 * you can set the index in the sourcePropertyIndex. 
		 * */
		public var dataPropertyName:String;
		
		/**
		 * When true sets the default values when the value is null. 
		 * */
		public var useDefaultValue:Boolean = true;
		
		/**
		 * This is the default value used when a default value is requested
		 * Note: If using a checkbox or list based component use default selected
		 * or default selected index;
		 * */
		public var defaultValue:String;
		
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
		 * Components can creation can be defered in the Flex framework. We can store the 
		 * value and set it after the target is created. Set this to true to allow this 
		 * behavior. 
		 * */
		public var suppressErrors:Boolean;
		
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
		 * When target is XML this will wrap the value in CDATA tags.
		 * */
		public var wrapValueInCDATATags:Boolean;
		
		/**
		 * If the data property is null and this value is true throw an error.
		 * */
		public var allowNullData:Boolean;
		
		/**
		 * Sets the property when the target is created. Since components
		 * can defer their creation we need to be able to set the value
		 * when they have been created.
		 * */
		override public function set target(value:Object):void {
			super.target = value;
			
			if (_target==value) return;
			
			_target = value;
			
			// defer setting until target is created
			if (pendingSetting) {
				TypeUtils.setValue(_target, targetPropertyName, pendingValue, wrapValueInCDATATags);
			}
		}
		private var _target:Object;
		
		/**
		 * If the target is a UIComponent calls validateNow on the component
		 * when this property is true.
		 * */
		public var validateNow:Boolean;
	}
}