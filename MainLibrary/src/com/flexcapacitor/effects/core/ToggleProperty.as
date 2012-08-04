

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.TogglePropertyInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.core.UIComponent;
	
	/**
	 * Event dispatched when the property specified changes.
	 * 
	 * */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Toggles between one or more values in order. 
	 * Plays the effects in the effects array by index if set. For example,
	 * if toggle values are true then false then if the new target value is true
	 * then the first effect is played.
	 * 
	 * To use with a checkbox or toggle button component set the properties like so,
	 * target="{redrawButton}" targetPropertyName="selected" toggleValues="{[true, false]}"
	 * updateTargetProperty="false"
	 * */
	public class ToggleProperty extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 */
		public function ToggleProperty(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = TogglePropertyInstance;
		}

		
		/**
		 * Name of values to toggle between. Can be more than just 2 states. 
		 * When more than 2 values are provided then they will be changed in order.
		 * */
		public var toggleValues:Array;
		
		/**
		 * Name of property that contains the toggle value.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Effects to play when matching toggle values. 
		 * If the toggle values are "page1" and "page2" in that order 
		 * and "page1" is the new value then the effect, if defined, 
		 * in the first index is played.
		 * */
		public var effects:Array;
		
		/**
		 * New toggle value
		 * */
		public var data:Object;
		
		/**
		 * If true then updates the target property to the next value in the toggle values array.
		 * For use with a toggle button or checkbox set this to false. 
		 * */
		public var updateTargetProperty:Boolean;
	}
}