

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.FilterCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Filters a list collection by the value specified
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
		 * Determines if search text is case sensitive
		 * */
		public var caseSensitive:Boolean;
		
		/**
		 * Name of field to search for on object in collection. If collection contains
		 * simple types then do not set this property.
		 * */
		public var fieldName:String;
		
		/**
		 * Name of field to get search value from when source is set. If source is not 
		 * an object then do not set this property.
		 * */
		public var sourcePropertyName:String;
		
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
				var filterValue:String;
				var itemValue:String;
				var valueLength:int;
				var isSpace:Boolean;
				var index:int;
				
				filterValue = sourcePropertyName ? source[sourcePropertyName] : String(source);
				itemValue = fieldName ? item[fieldName] : String(item);
				valueLength = filterValue ? filterValue.length : 0;
				
				// show all items if search is empty
				if (showAllItemsOnEmpty && valueLength==0) {
					return true;
				}
				else if (!showAllItemsOnEmpty && valueLength==0) {
					return false;
				}
				
				// case sensitive
				if (!caseSensitive) { 
					filterValue = filterValue ? filterValue.toLowerCase() : filterValue;
					itemValue = itemValue ? itemValue.toLowerCase() : itemValue;
				}
				
				// search at the start of a word - this could use regexp
				if (searchAtStart) {
					index = itemValue.indexOf(filterValue);
					
					if (index!=-1) {
						isSpace = itemValue.charAt(index-1)==" ";
						
						if (index==0 || isSpace) {
							return true;
						}
						
						return false;
					}
					
					return false;
				}
				
				// search at start is false so allow search anywhere in search item
				if (itemValue.indexOf(filterValue)!=-1) {
					return true;
				}
				
				return false;
			}
	}
}