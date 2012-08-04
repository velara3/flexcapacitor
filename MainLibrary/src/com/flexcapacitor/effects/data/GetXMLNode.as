

package com.flexcapacitor.effects.data {
	
	import com.flexcapacitor.effects.data.supportClasses.GetXMLNodeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * When given an XML string or XML object finds the node and returns
	 * an XML object or XMLList. Not finished. Inspect the results
	 * 
	 * Set inspectXML to true to see the XML before and after it has been modified
	 * getChildByName returns an XML List of the child nodes that have the name specified
	 * getFirstChild returns the first node. If the first node is a list it returns the first item
	 * getChildren returns an XML or XMLList from the first node of the XML provided
	 * ignoreRoot skips the first node
	 * */
	public class GetXMLNode extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function GetXMLNode(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = GetXMLNodeInstance;
		}
		
		/**
		 * Validate XML string before assignment
		 * */
		public var validate:Boolean;
		
		/**
		 * Source object that contains property. Optional.
		 * */
		public var source:Object;
		
		/**
		 * Name of property on source object.
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * Resulting XMLList
		 * */
		public var data:Object;
		
		/**
		 * Effect played when XML is invalid
		 * */
		public var invalidXMLEffect:ActionEffect;
		
		/**
		 * Returns the first child as XML
		 * If the first child is an XMLList then returns the first child of that list
		 * */
		public var getFirstChild:Boolean;
		
		/**
		 * Returns the first children as XMLList
		 * If the node is a single XML node then returns that node as the first item in an XMLList
		 * */
		public var getFirstNodeChildren:Boolean;
		
		/**
		 * Returns the child with the name specified as XML
		 * If the child is an XMLList then returns the first child in that list
		 * */
		public var getChildByName:String;
		
		/**
		 * Returns the children with the name specified as an XMLList
		 * If the node is a single XML node then returns that node as the first item in an XMLList
		 * */
		public var getChildrenByName:String;
		
		/**
		 * Displays the XML before and after processing. Set to false to hide 
		 * this information
		 * */
		public var inspectXML:Boolean;
		
		/**
		 * If true ignores / skips the root tag
		 * */
		public var ignoreRoot:Boolean;
	}
}