

package com.flexcapacitor.effects.display {
	import com.flexcapacitor.effects.display.supportClasses.HideElementInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Hide an element. Sets the visible to false. 
	 * Option to set the include in layout to false
	 * */
	public class HideElement extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function HideElement(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = HideElementInstance;
		}
		
		/**
		 * Prevents the element from being included in the layout
		 * Default is false. 
		 * @copy mx.core.IUIComponent#includeInLayout
		 * */
		[Inspectable(enumeration="true,false")]
		public var includeInLayout:String;
		
		/**
		 * When set to false the element is hidden. You can set this to true 
		 * to only apply include in layout. 
		 * Default is false.
		 * @copy mx.core.IUIComponent#visible
		 * */
		public var display:Boolean;
		
	}
}