

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.ShuffleCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Shuffles a collection (shuffles the array in the collection).
	 * */
	public class ShuffleCollection extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function ShuffleCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ShuffleCollectionInstance;
		}
		
		
		/**
		 * Updates the collection immediately
		 * */
		public var refresh:Boolean = true;
		
		/**
		 * Reference to the shuffled array
		 * */
		public var shuffledArray:Array;
		
		/**
		 * If true shuffles source array. 
		 * If false creates a new array (the original array remains unchanged). 
		 * */
		public var shuffleSourceArray:Boolean;
	}
}