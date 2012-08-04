

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.DataObjectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import spark.utils.DataItem;
	
	/**
	 * Used to store a data
	 * */
	public class DataObject extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function DataObject(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = DataObjectInstance;
		}
		
		/**
		 * Use to store Array
		 * */
		[Bindable]
		public var array:Array;
		
		/**
		 * Use to store vector
		 * */
		[Bindable]
		public var vector:Vector;
		
		/**
		 * Use to store string
		 * */
		[Bindable]
		public var string:String;
		
		/**
		 * Use to store int
		 * */
		[Bindable]
		public var integer:int;
		
		/**
		 * Use to store uint
		 * */
		[Bindable]
		public var unsignedInteger:uint;
		
		/**
		 * Use to store number
		 * */
		[Bindable]
		public var number:Number;
		
		/**
		 * Use to store data item
		 * */
		[Bindable]
		public var dataItem:DataItem;
		
		/**
		 * Type to cast object to.
		 * */
		public var valueType:Object;
		
		/**
		 * When true traces the value to the console. 
		 * */
		public var inspectValue:Boolean;
		
		/**
		 * Object used to hold data. 
		 * */
		[Bindable]
		public var data:*;
		
	}
}