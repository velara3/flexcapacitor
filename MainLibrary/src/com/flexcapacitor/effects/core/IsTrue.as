

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.IsTrueInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Event dispatched when the property specified is true.
	 * */
	[Event(name="true", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the property specified is not true. 
	 * */
	[Event(name="notTrue", type="flash.events.Event")]
	
	/**
	 * Checks if a property on the target is true. 
	 * If the property is true then the trueEffect is played.
	 * If the property is not true then the falseEffect is played.
	 * 
	 * @see IsTrueToValue
	 * */
	public class IsTrue extends ActionEffect {
		
		/**
		 * Event name constant when target property is true.
		 * */
		public static const TRUE:String = "true";
		
		/**
		 * Event name constant when target property is not true.
		 * */
		public static const NOT_TRUE:String = "notTrue";
		
		
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
		public function IsTrue(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = IsTrueInstance;
			
		}
		
		/**
		 * Name of property on the target.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Name of a sub property on the property on the target. 
		 * */
		public var targetSubPropertyName:String;
		
		/**
		 * Effect that is played if the property is true.
		 * */
		public var trueEffect:IEffect;
		
		/**
		 * Effect that is played if the property is not true.
		 * */
		public var notTrueEffect:IEffect;
		
		
	}
}