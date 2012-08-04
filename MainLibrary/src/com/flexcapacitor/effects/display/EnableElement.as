

package com.flexcapacitor.effects.display {
	
	import com.flexcapacitor.effects.display.supportClasses.EnableElementInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Sets the enabled property to true on an element (UIComponent).
	 * 
	 * @copy mx.core.IUIComponent#enabled
	 * */
	public class EnableElement extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function EnableElement(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = EnableElementInstance;
		}
		
		
		/**
		 * When set to true sets the enabled property to true 
		 * Default is true.
		 * @copy mx.core.IUIComponent#enabled
		 * */
		public var enabled:Boolean = true;
		
	}
}