

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.ScrollItemIntoViewInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Event dispatched when the item is found
	 * */
	[Event(name="itemFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the item is not found
	 * */
	[Event(name="itemNotFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the item is not set
	 * */
	[Event(name="itemNotSet", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the dataProvider is not set
	 * */
	[Event(name="dataProviderNotSet", type="flash.events.Event")]
	
	/**
	 * Scrolls to the last item in the list
	 * */
	public class ScrollItemIntoView extends ActionEffect {
		
		/**
		 * Event name constant when the item is not found
		 * */
		public static const ITEM_NOT_FOUND:String = "itemNotFound";
		
		/**
		 * Event name constant when the item is found
		 * */
		public static const ITEM_FOUND:String = "itemFound";
		
		/**
		 * Event name constant when the item is not set
		 * */
		public static const ITEM_NOT_SET:String = "itemNotSet";
		
		/**
		 * Event name constant when the dataProvider is not set
		 * */
		public static const DATAPROVIDER_NOT_SET:String = "dataProviderNotSet";
		
		
		/**
		 *  Constructor.
		 * */
		public function ScrollItemIntoView(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ScrollItemIntoViewInstance;
			
		}
		
		/**
		 * Effect that is played if the item is found
		 * */
		public var itemFoundEffect:IEffect;
		
		/**
		 * Effect that is played if the item is not found
		 * */
		public var itemNotFoundEffect:IEffect;
		
		/**
		 * Effect that is played if the item is not set
		 * */
		public var itemNotSetEffect:IEffect;
		
		/**
		 * Effect that is played if the dataProvider is not set
		 * */
		public var dataProviderNotSetEffect:IEffect;
		
		/**
		 * The reference to the item to scroll into view. 
		 * */
		public var data:Object;
		
		
	}
}