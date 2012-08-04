

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.SelectFirstItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.events.EffectEvent;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there is no items.
	 * */
	[Event(name="noItems", type="flash.events.Event")]
	
	/**
	 * Selects the first item in the list. 
	 * The selected item is set to the data property.
	 * If there is no selected item then the noItemsEffect is played if set.
	 * */
	public class SelectFirstItem extends ActionEffect {
		
		/**
		 * Event name constant when there is no items in the list.
		 * */
		public static const NO_ITEMS:String = "noItems";
		
		
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
		 * Effect that is played if there is no selected item.
		 * */
		public var noItemsEffect:Effect;
		
		/**
		 * The reference to the selected item. 
		 * */
		public var data:Object;
		
		/**
		 * The index of the selected item 
		 * */
		public var dataIndex:int;
		
	}
}