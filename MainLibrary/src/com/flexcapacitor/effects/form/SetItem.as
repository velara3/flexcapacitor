

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.SetItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	/**
	 * Sets the form to the data that we plan to use
	 * */
	public class SetItem extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function SetItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = SetItemInstance;

		}
		
		/**
		 * Reference to the form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Reference to the data being used in the form
		 * */
		public var data:Object;
	}
	
}