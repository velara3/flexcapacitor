

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.SelectFirstItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there is no items.
	 * */
	[Event(name="noItems", type="flash.events.Event")]
	
	/**
	 * Event dispatched when there is an item selected.
	 * */
	[Event(name="itemSelected", type="flash.events.Event")]
	
	/**
	 * Selects the first item in the list. 
	 * The selected item is set to the data property.
	 * If there is no selected item then the noItemsEffect is played if set.
	 * If there is a selected item then the itemSelectedEffect is played if set.
	 * */
	public class SelectFirstItem extends ActionEffect {
		
		/**
		 * Event name constant when there is no items in the list.
		 * */
		public static const NO_ITEMS:String = "noItems";
		/**
		 * Event name constant when an item is selected in the list.
		 * */
		public static const ITEM_SELECTED:String = "itemSelected";
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function SelectFirstItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = SelectFirstItemInstance;
			
		}
		
		/**
		 * Effect that is played if there is a selected item.
		 * */
		public var itemSelectedEffect:Effect;
		
		/**
		 * Effect that is played if there is no selected item.
		 * */
		public var noItemsEffect:Effect;
		
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
		 * When true does not throw an error if the data provider of the list is null.
		 * */
		public var allowNullDataProvider:Boolean = true;
		
	}
}