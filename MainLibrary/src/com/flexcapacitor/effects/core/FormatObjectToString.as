

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.FormatObjectToStringInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Formats an Object or XML into a more readable format
	 * */
	public class FormatObjectToString extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function FormatObjectToString(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = FormatObjectToStringInstance;
		}
		
		/**
		 * @copy mx.utils.ObjectUtil.toString()
		 * */
		public var formattedData:String;
		
		/**
		 * Data to format
		 * */
		public var data:Object;
		
		/**
		 * Array of namespace URIs for properties that should be included in 
		 * the output. By default only properties in the public namespace will 
		 * be included in the output. To get all properties regardless of namespace 
		 * pass an array with a single element of ".<br/>
		 * @copy mx.utils.ObjectUtil.toString()
		 * */
		public var namespaceURIs:Array;
		
		/**
		 * Array of the property names that should be excluded from the output. 
		 * Use this to remove data from the formatted string.<br/>
		 * @copy mx.utils.ObjectUtil.toString()
		 * */
		public var exclude:Array;
		
		/**
		 * Trace the value to the console
		 * */
		public var traceToConsole:Boolean;
		
		
	}
}