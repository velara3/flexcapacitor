

package com.flexcapacitor.effects.data {
	import com.flexcapacitor.effects.data.supportClasses.ParseTagIntoXMLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Not Complete
	 * Possibly meant to convert a string of XML text into an XML object from the tag
	 * @see GetXMLNode
	 * */
	public class ParseTagIntoXML extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object that contains the property that will be set to the source value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ParseTagIntoXML(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ParseTagIntoXMLInstance;
		}
		
		/**
		 * Name of property on target object. See source and sourcePropertyName.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * Source object that contains property. Optional.
		 * */
		public var source:Object;
		
		/**
		 * Name of property on source object.
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * 
		 * */
		public var data:Object;
		
	}
}