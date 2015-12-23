

package com.flexcapacitor.effects.data {
	
	import com.flexcapacitor.effects.data.supportClasses.ConvertStringToXMLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when XML is invalid.
	 * */
	[Event(name="invalidValue", type="flash.events.Event")]
	
	/**
	 * Event dispatched when XML is valid.
	 * */
	[Event(name="validValue", type="flash.events.Event")]
	
	/**
	 * Converts an XML string to XML instance. 
	 * Places the resulting XML instance into the data property.
	 * */
	public class ConvertStringToXML extends ActionEffect {
		
		public static const INVALID_VALUE:String = "invalidValue";
		public static const VALID_VALUE:String = "validValue";
		
		/**
		 *  Constructor.
		 * */
		public function ConvertStringToXML(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ConvertStringToXMLInstance;
		}
		
		/**
		 * Validate XML string before assignment
		 * */
		public var validate:Boolean;
		
		/**
		 * The XML string or object that contains the property of the XML string.
		 * Use source property name to get property on the object.
		 * */
		public var source:Object;
		
		/**
		 * Name of property on source object.
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * XML created from XML string
		 * */
		public var data:Object;
		
		/**
		 * Effect that is played when the XML string cannot be converted into XML
		 * */
		public var invalidXMLEffect:IEffect;
		
		/**
		 * Effect that is played when the XML string can be converted into XML
		 * */
		public var validXMLEffect:IEffect;
		
		/**
		 * Returns the first child
		 * */
		public var getFirstChild:Boolean;
		
		/**
		 * Gets the child by name. NOT TESTED
		 * */
		public var getChildByName:String;
		
		/**
		 * Displays the XML string in the console before and after it is processed
		 * */
		public var inspectXML:Boolean;
	}
}