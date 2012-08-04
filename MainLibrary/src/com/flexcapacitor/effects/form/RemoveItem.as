

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.RemoveItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when item is not found in the array or list.
	 * */
	[Event(name="notFound", type="flash.events.Event")]

	/**
	 * Event dispatched when item is added
	 * */
	[Event(name="removed", type="flash.events.Event")]
	
	/**
	 * Removes an item from the array or list supplied
	 * */
	public class RemoveItem extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function RemoveItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = RemoveItemInstance;

		}
		
		public static const REMOVED:String = "removed";
		public static const NOT_FOUND:String = "notFound";
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Reference to the item to remove
		 * */
		public var data:Object;
		
		/**
		 * Array, List or Collection.
		 * */
		public var targetList:Object;
		
		/**
		 * Effect played when item is not found.
		 * */
		public var notFoundEffect:IEffect;
		
		/**
		 * Effect played when item is removed.
		 * */
		public var removedEffect:IEffect;
	}
	
}