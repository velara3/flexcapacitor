

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.AddItemAtInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.IList;
	import mx.effects.IEffect;
	
	/**
	 * Dispatched when the collection is not set
	 * */
	[Event(name="collectionNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when the data property is not set
	 * */
	[Event(name="dataNotSet", type="flash.events.Event")]
	
	/**
	 * Adds an item to the collection at the index specified. The item being added is the value of the data property. 
	 * */
	public class AddItemAt extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var DATA_NOT_SET:String = "dataNotSet";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function AddItemAt(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = AddItemAtInstance;
		}
		
		/**
		 * Reference to the collection 
		 * */
		[Bindable]
		public var collection:IList;
		
		/**
		 * When set to true does not throw an error when the data to be null
		 * Note: Null values are not added.
		 * */
		public var allowNullData:Boolean = true;
		
		/**
		 * When set to true allows the collection to be null
		 * otherwise an error is thrown.
		 * */
		public var allowNullCollection:Boolean = true;
		
		/**
		 * Index at where to add item. Default is -1 or the first item. 
		 * */
		public var index:int = -1;
		
		/**
		 * Item to add
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
		
	}
}