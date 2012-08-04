

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.ToggleEffectsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Event dispatched when the effects change
	 * NOT IMPLEMENTED
	 * */
	[Event(name="change", type="flash.events.Event")]
	
	
	[DefaultProperty("effects")]
	
	/**
	 * Toggles between one or more effects in order. 
	 * Place the effects you want to toggle between in the effects array
	 * 
	 * For example, if you define three effects they are played in order 
	 * and start over from the beginning.
	 * 
	 * @see SwitchEffects
	 * */
	public class ToggleEffects extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 */
		public function ToggleEffects(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ToggleEffectsInstance;
		}
		
		/**
		 * Effects to play when matching toggle values. 
		 * If the toggle values are "page1" and "page2" in that order 
		 * and "page1" is the new value then the effect, if defined, 
		 * in the first index is played.
		 * */
		public var effects:Array;
		
		/**
		 * Index of the last effect played
		 * */
		public var lastEffectPlayedIndex:int = -1;
		
		/**
		 * If true ends the previous effect if it is playing (or paused). 
		 * */
		public var endPreviousEffectIfPlaying:Boolean;
	}
}