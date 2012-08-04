

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.RemoveItemAtInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.IList;
	import mx.effects.IEffect;
	
	/**
	 * Dispatched when collection is not set
	 * */
	[Event(name="collectionNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when an item has been removed from the collection
	 * */
	[Event(name="removed", type="flash.events.Event")]
	
	/**
	 * Dispatched when the index of the item to be removed is greater or less than the available items.
	 * */
	[Event(name="outOfBounds", type="flash.events.Event")]
	
	/**
	 * Removes an item in the collection at the index specified. The item being removed is the item in the data property. 
	 * */
	public class RemoveItemAt extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var REMOVED:String = "removed";
		public static var OUT_OF_BOUNDS:String = "outOfBounds";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function RemoveItemAt(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = RemoveItemAtInstance;
		}
		
		/**
		 * Reference to the collection 
		 * */
		[Bindable]
		public var collection:IList;
		
		/**
		 * When set to true allows the collection to be null
		 * otherwise an error is thrown.
		 * */
		public var allowNullCollection:Boolean = true;
		
		/**
		 * Index where to remove item. Default is 0. 
		 * */
		public var index:int;
		
		/**
		 * Removed item.
		 * */
		public var data:Object;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when item has been removed 
		 * */
		public var removedEffect:IEffect;
		
		/**
		 * Effect played when index of the item to remove is out of bounds
		 * */
		public var outOfBoundsEffect:IEffect;
	}
}