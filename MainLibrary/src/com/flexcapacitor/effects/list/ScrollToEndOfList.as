

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.ScrollToEndOfListInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there are no items.
	 * */
	[Event(name="noItems", type="flash.events.Event")]
	
	/**
	 * Scrolls to the last item in the list
	 * */
	public class ScrollToEndOfList extends ActionEffect {
		
		/**
		 * Event name constant when there is no items.
		 * */
		public static const NO_ITEMS:String = "noItems";
		
		
		/**
		 *  Constructor.
		 * */
		public function ScrollToEndOfList(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ScrollToEndOfListInstance;
			
		}
		
		/**
		 * Effect that is played if there is no items.
		 * */
		public var noItemsEffect:Effect;
		
		
	}
}