

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.IsPropertySetToValueInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.events.EffectEvent;
	
	import mx.effects.Effect;
	import mx.managers.SystemManager;
	
	
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
	 * The default action is to cancel out of the sequence if the 
	 * property is not set. 
	 * */
	[Event(name="propertyNotSet", type="flash.events.Event")]
	
	/**
	 * Checks if a property on the target is set. 
	 * If the property is null then the propertyNotSetEffect is played.
	 * If the property is not null then the propertySetEffect is played.
	 * 
	 * @see IsPropertySet
	 * */
	public class IsPropertySetToValue extends ActionEffect {
		
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
		public function IsPropertySetToValue(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = IsPropertySetToValueInstance;
			
		}
		
		/**
		 * Name of property to check for on the target. For example, if the target
		 * is a BitmapImage you could check if "source" is set.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Effect that is played if the property is NOT set.
		 * */
		public var propertyNotSetEffect:Effect;
		
		/**
		 * Effect that is played if the property is set.
		 * */
		public var propertySetEffect:Effect;
		
		/**
		 * If this property is true and if the property on the target 
		 * is NOT set then this will cancel out of the sequence.
		 * */
		public var cancelIfNotSet:Boolean;
		
		/**
		 * The value to test for.
		 * */
		public var value:*;
		
	}
}