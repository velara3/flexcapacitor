

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.FilterCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Filters a list collection by the value specified
	 * <br/><br/>
	 * Usage:<br/>
	 * Filtering a collection of objects by lastName by the value of the text property in a TextInput:<br/>
	 * <pre>
&lt;collections:FilterCollection target="{myArrayCollection}" 
		source="{myTextInput}" 
		sourcePropertyName="text"
		showAllItemsOnEmpty="true"
		fieldName="lastName"
		searchAtStart="true"
		/>
</pre><br/>
	 * Filtering a collection of objects by title or description by the value of the ID property of the selectedItem in a List:<br/>
	 * <pre>
&lt;collections:FilterCollection target="{myArrayCollection}" 
		source="{categoriesList}" 
		sourcePropertyName="selectedItem"
		sourceSubPropertyName="id"
		showAllItemsOnEmpty="true"
		fieldName="title,description"
		caseSensitive="true"
		/>
</pre><br/>
	 * Filtering a collection of strings by the value of the searchString variable:<br/>
	 * <pre>
&lt;collections:FilterCollection target="{myArrayCollection}" 
		source="{searchString}" 
		showAllItemsOnEmpty="false"
		exactMatch="true"
		/>
</pre>
	 * */
	public class FilterCollection extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function FilterCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = FilterCollectionInstance;
		}
		
		/**
		 * @copy spark.collections.SortField.compareFunction
		 * */
		public var filterFunction:Function;
		
		/**
		 * Apply immediately
		 * */
		public var refresh:Boolean = true;
		
		/**
		 * If true then the search must start at the beginning of a word rather than anywhere
		 * */
		public var searchAtStart:Boolean;
		
		/**
		 * If true then the search must be exact. It cannot match a part of a word.
		 * */
		public var exactMatch:Boolean;
		
		/**
		 * Determines if search text is case sensitive
		 * */
		public var caseSensitive:Boolean;
		
		/**
		 * Name of field to search for on object in collection. If collection contains
		 * simple types then do not set this property. If the collection contains
		 * XML items and you want to filter on an attribute add the "@" sign.
		 * For example, "@name". <br/><br/>
		 * 
		 * This can also accept multiple field names. Separate by comma. 
		 * */
		public var fieldName:String;
		
		/**
		 * Name of field to get search value from when source is set. If source is not 
		 * an object then do not set this property.
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * Name of sub field to get search value from when source is set. If source is not 
		 * an object then do not set this property.
		 * */
		public var sourceSubPropertyName:String;
		
		/**
		 * The value to search for or object that contains the value to search for. 
		 * */
		public var source:Object;
		
		/**
		 * If the search value is empty then do not apply any filter and thus show all items
		 * in the collection.
		 * */
		public var showAllItemsOnEmpty:Boolean;
		
		/**
		 * The default filter function
		 * ReferenceError: Error #1069: Property @title not found on String and there is no default value.
		 * */
		public function defaultFilterFunction(item:Object):Boolean {
				var filterValue:Object;
				var filterValueAsString:String;
				var itemValue:String;
				var valueLength:int;
				var isSpace:Boolean;
				var index:int;
				var fieldNames:Array;
				var fieldNamesLength:int;
				var match:Boolean;
				
				filterValue = sourcePropertyName ? source[sourcePropertyName] : String(source);
				filterValueAsString = sourceSubPropertyName && filterValue ? filterValue[sourceSubPropertyName] : String(filterValue);
				
				if (fieldName.indexOf(",")!=-1) {
					fieldNames = fieldName.split(",");
				}
				else {
					fieldNames = [fieldName];
				}
				
				fieldNamesLength = fieldNames.length;
				
				
				for (var i:int;i<fieldNamesLength;i++) {
					match = false;
					itemValue = fieldName ? item[fieldNames[i]] : String(item);
					valueLength = filterValueAsString ? filterValueAsString.length : 0;
					
					// show all items if search is empty
					if (showAllItemsOnEmpty && valueLength==0) {
						return true;
					}
					else if (!showAllItemsOnEmpty && valueLength==0) {
						//return false;
						continue;
					}
					
					// case sensitive
					if (!caseSensitive) { 
						filterValueAsString = filterValueAsString ? filterValueAsString.toLowerCase() : filterValueAsString;
						itemValue = itemValue ? itemValue.toLowerCase() : itemValue;
					}
					
					// exact match
					if (exactMatch) {
						index = itemValue.indexOf(filterValueAsString);
						
						if (itemValue==filterValueAsString) {
							return true;
						}
						
						//return false;
						continue;
					}
					
					// search at the start of a word - this could use regexp
					if (searchAtStart) {
						index = itemValue.indexOf(filterValueAsString);
						
						if (index!=-1) {
							isSpace = itemValue.charAt(index-1)==" ";
							
							if (index==0 || isSpace) {
								return true;
							}
							
							//return false;
							continue;
						}
						
						//return false;
						continue;
					}
					
					// search at start is false so allow search anywhere in search item
					if (itemValue.indexOf(filterValueAsString)!=-1) {
						return true;
					}
					
					//return false;
					continue;
				}
				
				return false;
			}
	}
}