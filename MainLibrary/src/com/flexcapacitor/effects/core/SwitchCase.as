

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.SwitchCaseInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	[DefaultProperty("effects")]
	
	/**
	 * Event dispatched when value is not found in the values array
	 * 
	 * */
	[Event(name="valueNotFound", type="flash.events.Event")]
	
	/**
	 * Provides switch case type of behavior that plays an effect when 
	 * a match is found. <br/><br/>
	 * 
	 * To use:<br/>
	 * You declare multiple effects in the effects array
	 * and define values in an values array.<br/> 
	 * 
	 * Then at a runtime you set the value property to one of the values in the array.<br/><br/> 
	 * 
	 * The values array and the effects array correspond 
	 * with each other. 
	 * 
	 * When the effect is run the value is checked for in the
	 * values array. If the value is found then the index 
	 * is retrieved. Then effect that is at that index in the 
	 * effects array is played.<br/>
	 * 
	 * For example, if the toggle values array is set to 
	 * "page1", "page2" and "page3" in that order 
	 * and "page1" is the new value when the effect run, 
	 * then the effect in the first index is played.
	 * 
	 * 
	 * @see ToggleEffects
	 * */
	public class SwitchCase extends ActionEffect {
		
		public static const VALUE_NOT_FOUND:String = "valueNotFound";
		
		/**
		 *  Constructor.
		 */
		public function SwitchCase(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SwitchCaseInstance;
		}
		
		/**
		 * Effects to play when matching toggle values. 
		 * If the toggle values are "page1" and "page2" in that order 
		 * and "page1" is the new value then the effect, if defined, 
		 * in the first index is played.
		 * */
		public var effects:Array;
		
		/**
		 * A list of values that when matches the value passed in 
		 * plays the effect at the same index in the effects array
		 * */
		public var values:Array;
		
		/**
		 * Value to search for in the values array.
		 * */
		public var value:Object;
		
		/**
		 * Effect to play when the value is not found in the values array
		 * */
		public var valueNotFoundEffect:IEffect;
	}
}