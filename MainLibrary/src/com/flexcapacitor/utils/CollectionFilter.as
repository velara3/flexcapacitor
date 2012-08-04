




package com.flexcapacitor.utils {
	

	[Bindable]
	public class CollectionFilter {

		public function CollectionFilter() {
			
		}
		
		// name of property to filter on if the item is an object
		public var property:String = "";
		
		// operator to apply comparison
		public var operator:String = "==";
		
		// value to compare to in filter
		public var value:* = "";

		// filter function
		public var filterFunction:Function;
		
		// after running validate this is either true or false
		public var valid:Boolean = true;
		
		// case sensitive
		public var caseSensitive:Boolean = true;
		
		public function validate(item:*):Boolean {
			valid = false;
			
			// there is a filter function - run that
			if (filterFunction!=null) {
				valid = filterFunction(item);
				return valid;
			}
			
			if (item is String) {
				if (caseSensitive) {
					
					if (item==value) {
						valid = true;
					}
					
				}
				else {
					if (String(item).toLowerCase()==String(value).toLowerCase()) {
						valid = true;
					}
				}
				
			}
			else if (item is Object) {
				if (item.hasOwnProperty(property)) {
					if (item[property]==value) {
						valid = true;
					}
				}
			}
			
			return valid;
		}

	}
}