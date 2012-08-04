

package com.flexcapacitor.effects.display {
	
	import com.flexcapacitor.effects.display.supportClasses.DisableElementInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Sets the enabled property to false on an element (UIComponent).
	 * 
	 * @copy mx.core.IUIComponent#enabled
	 * */
	public class DisableElement extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function DisableElement(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = DisableElementInstance;
		}
		
		
		/**
		 * When set to false sets the enabled property to false
		 * Default is false.
		 * @copy mx.core.IUIComponent#enabled
		 * */
		public var enabled:Boolean;
		
	}
}