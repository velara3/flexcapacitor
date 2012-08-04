

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.CreateFormCodeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	/**
	 * Creates a list of all the form element names for use in the PHP page
	 * It also checks for duplicates
	 * */
	public class CreateFormCode extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function CreateFormCode(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = CreateFormCodeInstance;
		}
		
		/**
		 * Reference to the Form Adapter instance. Required.
		 * */
		public var formAdapter:FormAdapter;
		public var checkForDuplicates:Boolean = true;
		public var listRequestNames:Boolean = true;
		public var requestNameJoinSeparater:String = ",";
		
	}
}