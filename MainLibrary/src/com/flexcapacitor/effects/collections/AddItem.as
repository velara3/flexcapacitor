

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.AddItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.IList;
	import mx.effects.IEffect;
	
	[Event(name="collectionNotSet", type="flash.events.Event")]
	[Event(name="dataNotSet", type="flash.events.Event")]
	
	/**
	 * Adds an item to the collection. The item being added is the value of the data property. 
	 * */
	public class AddItem extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var DATA_NOT_SET:String = "dataNotSet";
		public static var START:String = "start";
		public static var END:String = "end";
		
		
		/**
		 *  Constructor.
		 *  
		 */
		public function AddItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = AddItemInstance;
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
		 * Location where to add item. Default is end. 
		 * */
		[Bindable]
		[Inspectable(enumeration="start,end")]
		public var location:String;
		
		/**
		 * Item to add
		 * */
		[Bindable]
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