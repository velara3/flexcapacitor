

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.UpdateItemInstance;
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
	 * Event dispatched when item is updated
	 * */
	[Event(name="updated", type="flash.events.Event")]
	
	/**
	 * Updates the item selected in the form. 
	 * Usually you call a save method after this.
	 * */
	public class UpdateItem extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function UpdateItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = UpdateItemInstance;

		}
		
		public static const UPDATED:String = "updated";
		public static const VALID:String = "valid";
		public static const INVALID:String = "invalid";
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Reference to the data object being update. 
		 * If not set then checks the form adapter data property. 
		 * */
		public var data:Object;
		
		/**
		 * Validates the form before updating the item. 
		 * If form is invalid then does not add the item
		 * */
		public var validate:Boolean = true;
		
		/**
		 * Reference to the updated item after it has been created
		 * */
		public var updatedItem:Object;
		
		/**
		 * Array, List or Collection.
		 * */
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
		 * Effect played when item is updated.
		 * */
		public var updatedEffect:IEffect;
	}
	
}