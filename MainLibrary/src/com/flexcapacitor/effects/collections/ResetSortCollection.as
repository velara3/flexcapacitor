

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.ResetSortCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Resets a sorted collection to no sort
	 * */
	public class ResetSortCollection extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function ResetSortCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ResetSortCollectionInstance;
		}
		
		/**
		 * Apply immediately
		 * */
		public var refresh:Boolean = true;
	}
}