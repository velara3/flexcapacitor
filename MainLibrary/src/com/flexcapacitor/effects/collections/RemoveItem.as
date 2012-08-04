

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.RemoveItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.IList;
	import mx.effects.IEffect;
	
	/**
	 * Dispatched when collection is not set
	 * */
	[Event(name="collectionNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when data is not set
	 * */
	[Event(name="dataNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when data item is not found in the collection
	 * */
	[Event(name="itemNotFound", type="flash.events.Event")]
	
	/**
	 * Dispatched when the data item has been removed from the collection
	 * */
	[Event(name="removed", type="flash.events.Event")]
	
	/**
	 * Removes an item in the collection. The item being removed is the item in the data property. 
	 * */
	public class RemoveItem extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var DATA_NOT_SET:String = "dataNotSet";
		public static var REMOVED:String = "removed";
		public static var ITEM_NOT_FOUND:String = "itemNotFound";
		public static var OUT_OF_BOUNDS:String = "outOfBounds";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function RemoveItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = RemoveItemInstance;
		}
		
		/**
		 * Reference to the collection 
		 * */
		[Bindable]
		public var collection:IList;
		
		/**
		 * When set to true does not throw an error when the item to remove is null
		 * */
		public var allowNullData:Boolean = true;
		
		/**
		 * When set to true allows the collection to be null
		 * otherwise an error is thrown.
		 * */
		public var allowNullCollection:Boolean = true;
		
		/**
		 * Item to remove or removed item if index is set.
		 * */
		public var data:Object;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when data item is null. 
		 * */
		public var dataNotSetEffect:IEffect;
		
		/**
		 * Effect played when the item is not found in the collection. 
		 * */
		public var itemNotFoundEffect:IEffect;
		
		/**
		 * Effect played when item has been removed 
		 * */
		public var removedEffect:IEffect;
	}
}