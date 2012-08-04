

package com.flexcapacitor.effects.compatibility {
	
	import com.flexcapacitor.effects.compatibility.supportClasses.ParseURLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Parses the URL and returns the requested section.
	 * TODO: Get query parameters and fragment parameters
	 * */
	public class ParseURL extends ActionEffect {
		
		/**
		 *  Constructor.
		 * */
		public function ParseURL(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ParseURLInstance;
			
		}
		
		/**
		 * Name of protocol to check for
		 * */
		[Inspectable(enumeration="protocol,port,serverName,serverNameWithPort,fullURL,*")]
		public var section:String;
		
		/**
		 * Parsed value
		 * */
		public var data:Object;
		
		/**
		 * URL. Optional. 
		 * Default is the URL of the SWF. NOTE: This may NOT be the URL of the HTML wrapper page.
		 * */
		public var URL:String;
		
		/**
		 * Traces the result to the console
		 * */
		public var inspect:Boolean;
		
	}
}