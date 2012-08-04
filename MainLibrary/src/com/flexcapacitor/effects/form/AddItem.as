

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.AddItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when form is invalid.
	 * */
	[Event(name="invalid", type="flash.events.Event")]
	
	/**
	 * Event dispatched when form is valid
	 * */
	[Event(name="valid", type="flash.events.Event")]
	
	/**
	 * Event dispatched when item is added
	 * */
	[Event(name="added", type="flash.events.Event")]
	
	/**
	 * Adds an item to the array or xmlist supplied
	 * */
	public class AddItem extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
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
		
		public static const ADDED:String = "added";
		public static const VALID:String = "valid";
		public static const INVALID:String = "invalid";
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Validates the form before adding the item. 
		 * If form is invalid then does not add the item
		 * */
		public var validate:Boolean = true;
		
		/**
		 * Reference to the added item after it has been created
		 * */
		public var addedItem:Object;
		
		/**
		 * Array, List or Collection.
		 * */
		[Bindable]
		public var targetList:Object;
		
		/**
		 * Effect played when form is invalid.
		 * */
		public var invalidEffect:IEffect;
		
		/**
		 * Effect played when form is valid.
		 * */
		public var validEffect:IEffect;
		
		/**
		 * Effect played when item is added.
		 * */
		public var addedEffect:IEffect;
	}
	
}