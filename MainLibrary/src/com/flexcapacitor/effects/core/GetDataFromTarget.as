

package com.flexcapacitor.effects.core {
	import com.flexcapacitor.effects.core.supportClasses.GetDataFromTargetInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Get's the value from the target object and copies it into the data property.
	 * */
	public class GetDataFromTarget extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function GetDataFromTarget(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = GetDataFromTargetInstance;
		}
		
		/**
		 * Name of property on target object. 
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Name of sub property on target object. 
		 * */
		public var targetSubPropertyName:String;
		
		/**
		 * If the property on the target is an array then 
		 * you can set the index in the targetPropertyIndex. 
		 * Default is -1.
		 * */
		public var targetPropertyIndex:int = -1;
		
		/**
		 * Holds the value we get from the target object.
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * Hook to modify the value. Label function. 
		 * 
		 * function labelFunction(item:Object):Object {
		 * 		return item;
		 * }
		 * */
		public var labelFunction:Function;
		
	}
}