

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.GetItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.IList;
	import mx.effects.IEffect;
	
	/**
	 * Dispatched when collection is not set
	 * */
	[Event(name="collectionNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when the collection is empty
	 * */
	[Event(name="collectionEmpty", type="flash.events.Event")]
	
	/**
	 * Removes an item in the collection. The item being removed is the item in the data property. 
	 * */
	public class GetItem extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var COLLECTION_EMPTY:String = "collectionEmpty";
		public static var START:String = "start";
		public static var END:String = "end";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function GetItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = GetItemInstance;
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
		 * Location in the collection where the item is retrieved from. 
		 * */
		[Bindable]
		[Inspectable(enumeration="start,end")]
		public var location:String;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when the collection is empty
		 * */
		public var collectionEmptyEffect:IEffect;
		
	}
}