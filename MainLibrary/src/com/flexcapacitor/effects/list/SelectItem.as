

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.SelectItemInstance;
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
	 * Selects an item in the list. If the item is not a primitive then item must match the
	 * item in the list. It will not find a copy of the item by default. Copies are created for 
	 * a variety of reasons including the if you drag and drop an item from one list to another.
	 * Set the dataPropertyName to search for an item by the value of the property. 
	 * The first item to match the value will be selected. You can set setItemToActualItem
	 * to copy the actual item back into the data property.
	 * */
	public class SelectItem extends ActionEffect {
		
		/**
		 * Event name constant when the item is found
		 * */
		public static const ITEM_FOUND:String = "itemFound";
		
		/**
		 * Event name constant when the item is not found
		 * */
		public static const ITEM_NOT_FOUND:String = "itemNotFound";
		
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
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function SelectItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = SelectItemInstance;
			
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
		 * The reference to the item to selected. 
		 * */
		public var data:Object;
		
		/**
		 * The property on the item that contains the value to search for. Optional. 
		 * */
		public var dataPropertyName:String;
		
		/**
		 * @copy SelectItem
		 * */
		public var setItemToActualItem:Boolean = true;
		
		/**
		 * Ensures the item, if found, is scrolled into view.
		 * */
		public var ensureItemIsVisible:Boolean;
		
	}
}