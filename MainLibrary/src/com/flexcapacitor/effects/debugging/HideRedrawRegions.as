

package com.flexcapacitor.effects.debugging {
	import com.flexcapacitor.effects.debugging.supportClasses.HideRedrawRegionsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Hides the redraw regions.
	 * */
	public class HideRedrawRegions extends ActionEffect {
		
		
		/**
		 * 
		 * */
		public function HideRedrawRegions(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = HideRedrawRegionsInstance;
		}
		
		
		/**
		 * The color of the redraw region outlines
		 * */
		public var color:Number = 0xFF0000;
		
	}
}