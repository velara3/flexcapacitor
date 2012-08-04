

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.RefreshCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.effects.IEffect;
	
	/**
	 * Dispatched when the collection is null
	 * */
	[Event(name="collectionNotSet", type="flash.events.Event")]
	
	/**
	 * Dispatched when the collection is was successfully refreshed
	 * */
	[Event(name="refreshComplete", type="flash.events.Event")]
	
	/**
	 * Dispatched when the collection refresh was not complete
	 * */
	[Event(name="refreshNotComplete", type="flash.events.Event")]
	
	/**
	 * Refreshes a collection.
	 * */
	public class RefreshCollection extends ActionEffect {
		
		public static var COLLECTION_NOT_SET:String = "collectionNotSet";
		public static var REFRESH_COMPLETE:String = "refreshComplete";
		public static var REFRESH_NOT_COMPLETE:String = "refreshNotComplete";
		
		/**
		 *  Constructor.
		 *  
		 */
		public function RefreshCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = RefreshCollectionInstance;
		}
		
		/**
		 * Reference to the collection 
		 * */
		[Bindable]
		public var collection:ICollectionView;
		
		/**
		 * When set to true allows the collection to be null
		 * otherwise an error is thrown.
		 * */
		public var allowNullCollection:Boolean;
		
		/**
		 * Effect played when collection is null. 
		 * */
		public var collectionNotSetEffect:IEffect;
		
		/**
		 * Effect played when collection was not refreshed successfully
		 * */
		public var refreshNotCompleteEffect:IEffect;
		
		/**
		 * Effect played when collection was refreshed successfully
		 * */
		public var refreshCompleteEffect:IEffect;
		
		
	}
}