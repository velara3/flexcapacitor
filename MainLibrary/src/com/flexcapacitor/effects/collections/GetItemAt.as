

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.GetItemAtInstance;
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
	 * Dispatched when the collection is empty
	 * */
	[Event(name="collectionEmpty", type="flash.events.Event")]
	
	/**
	 * Gets an item in the collection by index. 
	 * */
	public class GetItemAt extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var COLLECTION_EMPTY:String = "collectionEmpty";
		public static var OUT_OF_BOUNDS:String = "outOfBounds";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function GetItemAt(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = GetItemAtInstance;
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
		 * Item
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * Index of item in the collection
		 * */
		[Bindable]
		public var index:int;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when data item is no found in the collection. 
		 * */
		public var collectionEmptyEffect:IEffect;
		
		/**
		 * Effect played when index of the item to remove is out of bounds
		 * */
		public var outOfBoundsEffect:IEffect;
		
	}
}