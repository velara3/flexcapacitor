package com.flexcapacitor.model
{
	
	/**
	 * Used to store properties, styles and values from XML nodes during import
	 * */
	public class ValuesObject {
		
		/**
		 * List of properties 
		 * */
		public var properties:Array = [];
		
		/**
		 * List of events 
		 * */
		public var events:Array = [];
		
		/**
		 * List of styles 
		 * */
		public var styles:Array = [];
		
		/**
		 * List of child node properties 
		 * */
		public var childProperties:Array = [];
		
		/**
		 * List of child node events 
		 * */
		public var childEvents:Array = [];
		
		/**
		 * List of child node styles 
		 * */
		public var childStyles:Array = [];
		
		/**
		 * Object containing values of styles and properties
		 * */
		public var values:Object = {};
		
		/**
		 * Array of attributes on the XML node
		 * */
		public var attributes:Array;
		
		/**
		 * Array of qualified attributes on the XML node. 
		 * Qualified means having a specific namespace other than the parent namespace.
		 * */
		public var qualifiedAttributes:Array;
		
		/**
		 * Array of child node names on the XML node.
		 * For example, dataProvider would be a child node name: 
<pre>
&lt;s:ComboBox id="listOfThings">
   &lt;s:dataProvider>1,2,3&lt;/s:dataProvider>
&lt;/s:ComboBox>
</pre>
		 * */
		public var childNodeNames:Array;
		
		/**
		 * Array of qualified child node names on the XML node.
		 * For example, dataProvider would be a child node name: 
<pre>
&lt;s:ComboBox id="listOfThings">
   &lt;s:dataProvider>1,2,3&lt;/s:dataProvider>
&lt;/s:ComboBox>
</pre>
		 * */
		public var qualifiedChildNodeNames:Array;
		
		/**
		 * Array of child node names on the XML node.
		 * For example, "dataProvider" and "1,2,3" would be a child node name and child node value: 
<pre>
&lt;s:ComboBox id="listOfThings">
    &lt;s:dataProvider>1,2,3&lt;/s:dataProvider>
&lt;/s:ComboBox>
</pre>
		 * */
		public var childNodeValues:Object;
		
		/**
		 * An object containing all the styles whose values could not be casted into an acceptable type
		 * on the target object and the error as it's value.
		 * */
		public var stylesErrorsObject:Object;
		
		/**
		 * An object containing all the properties whose values could not be casted into an acceptable type
		 * on the target object and the error as it's value.
		 * */
		public var propertiesErrorsObject:Object;
		
		/**
		 * An object containing all the events whose values could not be casted into an acceptable type
		 * on the target object and the error as it's value.
		 * */
		public var eventsErrorsObject:Object;
		
		/**
		 * Array of valid properties, events and styles 
		 * */
		public var propertiesStylesEvents:Array;
		
		/**
		 * Array of attributes that are not valid properties, events and styles.
		 * They may be valid, such as state specific attributes, but they are not known 
		 * to the importer. 
		 * */
		public var attributesNotFound:Array;
		
		/**
		 * Array of attributes that are not valid properties, events and styles.
		 * They may be valid, such as state specific attributes, but they are not known 
		 * to the importer. 
		 * */
		public var nonNsAttributesNotFound:Array;
		
		/**
		 * Object that contains the default property value if default property is not 
		 * explictly defined as an attribute or a child node
		 * */
		public var defaultPropertyObject:Object;
		
		/**
		 * An array of other errors encountered during import
		 * */
		public var errors:Array;
		
		/**
		 * 
		 * */
		public var attributePropertiesStylesEvents:Array;
		
		/**
		 * 
		 * */
		public var childNodePropertiesStylesEvents:Array;
		
		/**
		 * 
		 * */
		public var childNodesNotFound:Array;
		
		/**
		 * Child nodes that are part of the element that do not need to be processed
		 * */
		public var handledChildNodeNames:Array;
		
		/**
		 * If true do not process child nodes
		 * */
		public var skipChildNodes:Boolean;
	}
}