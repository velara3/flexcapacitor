

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.CollectionEmptyInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	
	
	/**
	 * Dispatched when the collection is empty
	 * */
	[Event(name="empty", type="flash.events.Event")]
	
	/**
	 * Dispatched when the collection is not empty
	 * */
	[Event(name="notEmpty", type="flash.events.Event")]
	
	/**
	 * Plays an collectionEmpty effect when the collection has no items
	 * */
	public class CollectionEmpty extends ActionEffect {
		
		public static const NOT_EMPTY:String 		= "notEmpty";
		public static const EMPTY:String 			= "empty";
		
		/**
		 *  Constructor.
		 * */
		public function CollectionEmpty(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = CollectionEmptyInstance;
		}
		
		
		/**
		 * Effect played when the collection has items
		 * */
		public var notEmptyEffect:IEffect;
		
		/**
		 * Effect played when the collection has no items
		 * */
		public var emptyEffect:IEffect;
		
	}
}