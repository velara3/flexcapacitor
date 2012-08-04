

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.SetFormDataToServerDataInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	/**
	 * Sets the form data to the server data object
	 * */
	public class SetFormDataToServerData extends ActionEffect {
		
		
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
		public function SetFormDataToServerData(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SetFormDataToServerDataInstance;
		}
		
		/**
		 * Reference to the Form Adapter instance. Required.
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Data object from the server. Usually returned from a service request.
		 * Can be of type XML, Object or your own class. 
		 * */
		public var source:Object;
		
		/**
		 * Name of property on data object from the server. Usually returned from a service request.
		 * Can be of type XML, Object or your own class. Optional
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * Data object created from the server data
		 * */
		public var data:Object;
		
		/**
		 * Effect to run when a service fault is generated
		 * */
		public var faultEffect:ActionEffect;
		
		/**
		 * Inspects the data object
		 * */
		public var inspectData:Boolean;
	}
}