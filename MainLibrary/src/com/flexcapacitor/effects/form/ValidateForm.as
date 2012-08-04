

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.ValidateFormInstance;
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
	 * Validates a form
	 * */
	public class ValidateForm extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function ValidateForm(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ValidateFormInstance;

		}
		
		public static const VALID:String = "valid";
		public static const INVALID:String = "invalid";
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Allows you to disable validation for testing purposes
		 * */
		public var validate:Boolean = true;
		
		/**
		 * Effect played when form is invalid.
		 * */
		public var invalidEffect:IEffect;
		
		/**
		 * Effect played when form is valid.
		 * */
		public var validEffect:IEffect;
	}
	
}