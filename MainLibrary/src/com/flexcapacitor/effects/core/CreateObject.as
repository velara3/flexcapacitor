

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.CreateObjectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Creates an instance of the class specified and sets the instance to the data property
	 * */
	public class CreateObject extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function CreateObject(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = CreateObjectInstance;
		}
		
		/**
		 * Type of class to create
		 * */
		public var type:Class;
		
		/**
		 * Name and value pair of properties to create on the object
		 * */
		public var properties:Object = {};
		
		/**
		 * Name and value pair of styles to set on the object
		 * */
		public var styles:Object = {};
		
		/**
		 * Type to cast object to.
		 * */
		public var valueType:Object;
		
		/**
		 * When true traces the value to the console. 
		 * */
		public var inspectValue:Boolean;
		
		/**
		 * Instance 
		 * */
		public var data:*;
		
	}
}