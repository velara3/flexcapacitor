




package com.flexcapacitor.effects.collections.supportClasses {
	

	/**
	 * Used for filtering data in filtering effect 
	 * */
	public class FilterField {
		
		public function FilterField() {
			
		}
	
	    /**
	     *  The name of the property on an object to match. Leave this null if primitive.  
	     */
	    public var name:String;
		
	    /**
	     *  The value to compare to item to.
	     *
	     *  @default undefined
	     */
	    public var value:*;
		
	    /**
	     *  An array of values to compare item to.
	     *
	     *  @default undefined
	     */
	    public var values:Array;
		
		/**
		 * If comparison of value is case sensitive
		 */
	    public var caseSensitive:Boolean = true;

	}
	
}
