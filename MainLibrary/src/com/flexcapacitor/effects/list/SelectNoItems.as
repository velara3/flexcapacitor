

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.SelectNoItemsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there is no items.
	 * */
	[Event(name="noItems", type="flash.events.Event")]
	
	/**
	 * Deselects all items  in the list. This is the same as 
	 * setting the selected index to -1 and selectedItem to null
	 * 
	 * If there is no selected item then the noItemsEffect is played if set.
	 * */
	public class SelectNoItems extends ActionEffect {
		
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
		public function SelectNoItems(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = SelectNoItemsInstance;
			
		}
		
		/**
		 * Effect that is played if there is no selected item.
		 * */
		public var noItemsEffect:Effect;
		
		/**
		 * If true sets the selectedIndex to -1
		 * */
		public var setSelectedIndex:Boolean = true;
		
		/**
		 * If true sets the selectedItem to null
		 * */
		public var setSelectedItem:Boolean = true;
		
	}
}