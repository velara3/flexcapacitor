

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.IsPropertySetInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when the property specified IS set.
	 * 
	 * The default action is to move to the next effect if the 
	 * property is set. 
	 * */
	[Event(name="propertySet", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the property specified is NOT set. 
	 * 
	 * */
	[Event(name="propertyNotSet", type="flash.events.Event")]
	
	/**
	 * Checks if a property on the target is set. 
	 * If the property is null then the propertyNotSetEffect is played.
	 * If the property is not null then the propertySetEffect is played.
	 * 
	 * @see IsPropertySetToValue
	 * */
	public class IsPropertySet extends ActionEffect {
		
		/**
		 * Event name constant when target property is set.
		 * */
		public static const PROPERTY_SET:String = "propertySet";
		
		/**
		 * Event name constant when target property is NOT set.
		 * */
		public static const PROPERTY_NOT_SET:String = "propertyNotSet";
		
		
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
		public function IsPropertySet(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = IsPropertySetInstance;
			
		}
		
		/**
		 * Name of property to check for on the target. For example, if the target
		 * is a BitmapImage you could check if "bitmapData" is set.
		 * @see targetPropertyValueMayBeNull
		 * @see targetSubPropertyName
		 * */
		public var targetPropertyName:String;
		
		/**
		 * The property on the data object may be allowed to be null. 
		 * For example, consider the case where the target is a list, 
		 * the target property name is selectedItem and the sub property 
		 * to check is "name". If the list does not have a selectedItem
		 * then we would throw an error. If this property is set to 
		 * true then we don't throw an error and conclude the property is not set. 
		 * @see targetPropertyValueMayBeNull
		 * @see targetSubPropertyName
		 * */
		public var targetPropertyValueMayBeNull:Boolean;
		
		/**
		 * Name of a sub property to check for on the target. 
		 * For example, if the target is a BitmapImage and the target propertyName 
		 * is "bitmapData" then a subProperty could be "rect".
		 * @see targetPropertyValueMayBeNull
		 * @see targetPropertyName
		 * */
		public var targetSubPropertyName:String;
		
		/**
		 * When true empty strings are considered not set
		 * */
		public var emptyStringsAreNull:Boolean = true;
		
		/**
		 * Effect that is played if the property is NOT set.
		 * */
		public var propertyNotSetEffect:Effect;
		
		/**
		 * Effect that is played if the property is set.
		 * */
		public var propertySetEffect:Effect;
		
	}
}