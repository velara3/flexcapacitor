

package com.flexcapacitor.effects.popup {
	
	import com.flexcapacitor.effects.popup.supportClasses.HidePopupAnchorInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Hides a popup anchor. 
	 * Note add listeners to the mouseDownOutside event of  
	 * a child of the pop up anchor NOT the anchor itself
	 * */
	public class HidePopupAnchor extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *  
		 */
		public function HidePopupAnchor(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = HidePopupAnchorInstance;
		}
		
		
	}
}