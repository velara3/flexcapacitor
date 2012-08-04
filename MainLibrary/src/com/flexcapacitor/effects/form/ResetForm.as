

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.ResetFormInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	
	/**
	 * Resets the form to the default values
	 * */
	public class ResetForm extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function ResetForm(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ResetFormInstance;

		}
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
	}
	
}