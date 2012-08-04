

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.HasPropertyInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when if the target has the property.
	 * 
	 * The default action is to move to the next effect if the 
	 * property is set. 
	 * */
	[Event(name="hasProperty", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the target does not have the property. 
	 * 
	 * The default action is to cancel out of the sequence if the 
	 * property is not set. 
	 * */
	[Event(name="noProperty", type="flash.events.Event")]
	
	/**
	 * Checks if a property on the target exists 
	 * If the property exists on the target then the hasPropertyEffect is played.
	 * If the property does not exist then the noPropertyEffect is played.
	 * */
	public class HasProperty extends ActionEffect {
		
		/**
		 * Event name constant when target property exists.
		 * */
		public static const HAS_PROPERTY:String = "hasProperty";
		
		/**
		 * Event name constant when target property does not exist.
		 * */
		public static const NO_PROPERTY:String = "noProperty";
		
		
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
		public function HasProperty(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = HasPropertyInstance;
			
		}
		
		/**
		 * Name of property to check for on the target. 
		 * */
		public var propertyName:String;
		
		/**
		 * Name of a sub property to check for on the property on the target. 
		 * */
		public var subPropertyName:String;
		
		/**
		 * Effect that is played if the property is NOT set.
		 * */
		public var noPropertyEffect:Effect;
		
		/**
		 * Effect that is played if the property is set.
		 * */
		public var hasPropertyEffect:Effect;
		
		/**
		 * If this property is true and if the property is not on the target 
		 * then this will cancel out of the sequence.
		 * */
		public var cancelIfNoProperty:Boolean;
		
	}
}