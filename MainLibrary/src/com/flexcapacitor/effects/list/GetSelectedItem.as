

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.GetSelectedItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there is no selected item.
	 * */
	[Event(name="noSelectedItem", type="flash.events.Event")]
	
	/**
	 * Event dispatched when there is a selected item.
	 * */
	[Event(name="selectedItem", type="flash.events.Event")]
	
	/**
	 * Gets the selected item in the List. 
	 * The selected item is set to the data property.
	 * If there is no selected item then the noSelectedItemEffect is played. 
	 * If there is a selected item then the selectedItemEffect is played.
	 * */
	public class GetSelectedItem extends ActionEffect {
		
		/**
		 * Event name constant when there is no selected item.
		 * */
		public static const NO_SELECTED_ITEM:String = "noSelectedItem";
		
		/**
		 * Event name constant when there is a selected item.
		 * */
		public static const SELECTED_ITEM:String = "selectedItem";
		
		
		/**
		 *  Constructor.
		 * */
		public function GetSelectedItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = GetSelectedItemInstance;
			
		}
		
		/**
		 * The reference to the selected item. 
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * The index of the selected item 
		 * */
		[Bindable]
		public var dataIndex:int;
		
		/**
		 * Effect that is played if there is no selected item.
		 * */
		public var noSelectedItemEffect:Effect;
		
		/**
		 * Effect that is played if there is a selected item.
		 * */
		public var selectedItemEffect:Effect;
		
	}
}