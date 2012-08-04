

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.UpdateItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
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
	 * Dispatched when the data item has been updated from the collection
	 * */
	[Event(name="updated", type="flash.events.Event")]
	
	/**
	 * Dispatched when the index of the item to be updated is greater or less than the available items.
	 * */
	[Event(name="outOfBounds", type="flash.events.Event")]
	
	/**
	 * updates an item in the collection. The item being updated is the item in the data property. 
	 * */
	public class UpdateItem extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var DATA_NOT_SET:String = "dataNotSet";
		public static var UPDATED:String = "updated";
		public static var ITEM_NOT_FOUND:String = "itemNotFound";
		public static var OUT_OF_BOUNDS:String = "outOfBounds";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function UpdateItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = UpdateItemInstance;
		}
		
		/**
		 * Reference to the collection 
		 * */
		[Bindable]
		public var collection:IList;
		
		/**
		 * When set to true does not throw an error when the item to update is null
		 * */
		public var allowNull:Boolean = true;
		
		/**
		 * When set to true allows the collection to be null
		 * otherwise an error is thrown.
		 * */
		public var allowNullCollection:Boolean = true;
		
		/**
		 * Index at where to update item. Default is -1. 
		 * */
		public var index:int = -1;
		
		/**
		 * Item to update
		 * */
		public var data:Object;
		
		/**
		 * Property name on item to update. Optional.
		 * */
		public var propertyName:String;
		
		/**
		 * Old value on item to update. Optional.
		 * */
		public var oldValue:*;
		
		/**
		 * New value on item to update. Optional.
		 * */
		public var newValue:*;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when data item is null. 
		 * */
		public var dataNotSetEffect:IEffect;
		
		/**
		 * Effect played when data item is no found in the collection. 
		 * */
		public var itemNotFoundEffect:IEffect;
		
		/**
		 * Effect played when item has been updated 
		 * */
		public var updatedEffect:IEffect;
		
		/**
		 * Effect played when index of the item to update is out of bounds
		 * */
		public var outOfBoundsEffect:IEffect;
	}
}