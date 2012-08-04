

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.SortCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.collections.ISort;
	import mx.utils.ObjectUtil;
	
	import spark.globalization.SortingCollator;
	
	/**
	 * Sorts a list collection based on the fields you provide<br/><br/>
	 * 
	 * On XML it can sort subfields such as attributes and sub nodes<br/><br/>
	 * 
	 * <b>Examples</b>
	 * <pre>
	&lt;data:SortCollection target="{listCollection}">
		&lt;data:fields>
			&lt;s:SortField name="@value" />
		&lt;/data:fields>
	&lt;/data:SortCollection>
	 * </pre>
	 * <pre>
	&lt;data:SortCollection id="sortCollection" 
		 target="{arrayCollection}"
		 toggleSortDirection="1"
	 * </pre>
	 * <pre>
	&lt;data:SortCollection target="{arrayCollection}" >
		&lt;data:fields>
			&lt;s:SortField name="group" />
			&lt;s:SortField name="value" />
		&lt;/data:fields>
	&lt;/data:SortCollection>
	 * </pre>
		 * @copy spark.collections.SortField
	 * */
	public class SortCollection extends ActionEffect {


		/**
		 *  Constructor.
		 * */
		public function SortCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SortCollectionInstance;
		}
		
		/**
		 * @copy spark.collections.Sort
		 * */
		public var sort:ISort;
		
		/**
		 * Fields to sort by of type SortField
		 * @copy spark.collections.SortField
		 * */
		public var fields:Array;
		
		/**
		 * @copy spark.collections.SortField
		 * */
		[Bindable]
		public var descending:Boolean;
		
		/**
		 * @copy spark.collections.SortField.compareFunction
		 * */
		public var compareFunction:Function;
		
		/**
		 * Toggles between ascending and descending sort. 
		 * Set the lastDescendingDirection to 1 to toggle starting with descending sort rather than ascending.<br/>
		 * @copy spark.collections.SortField
		 * */
		public var toggleSortDirection:Boolean = true;
		
		/**
		 * Used to store the last value of the sorting direction.
		 * Used with toggleSortDirection option.
		 * Set this to 1 to toggle starting with descending sort rather than ascending.<br/>
		 * This is set automatically. 
		 * */
		[Bindable]
		public var lastSortDirection:int = -1;
		
		/**
		 * @copy spark.collections.SortField
		 * */
		public var numeric:Object;
		
		/**
		 * @copy spark.collections.SortField
		 * */
		public var locale:String = "en-US";
		
		/**
		 * Apply sort immediately after sort function is set
		 * */
		public var refresh:Boolean = true;
		
		/**
		 * Indicates to use the defaultNestedXMLCompare function
		 * This is set to true if the field is a string and contains periods
		 * */
		public var nestedXML:Boolean;
		
		/**
		 * Default XML sort function
		 * 
		 * */
		public function defaultSortFunction(a:Object, b:Object):int {
				var stringCollator:SortingCollator = new SortingCollator();
				var fieldNames:Array = [];
				var field:Object;
				var fieldName:String;// = field.name;
				var sa:String = "";
				var sb:String = "";
				var length:int = 0;
				var o:Object = 0;
				var i:int = 0;
				
				// Pull the values out of the XML object, then compare
				//  using the string or numeric comparator depending
				//  on the numeric flag.
				// Lifted from SortField xmlCompare() private method
				// Not thoroughly tested
				// There may easily be a better way to do this
				fieldNames = fieldName ? String(fieldName).split("."):fieldNames;
				length = fieldNames.length;
				
				try {
					if (fieldName==null) {
						sa = a.toString();
					}
					else {
						if (length>0) {
							o = a;
							for (i=0;i<length;i++) {
								o = o[fieldNames[i]];
							}
							sa = o.toString();
						}
						else {
							sa = a[fieldName].toString();
						}
					}
				}
				catch(error:Error) {
					
				}
				
				try {
					
					if (fieldName==null) {
						sa = b.toString();
					}
					else {
						if (length>0) {
							o = b;
							for (i=0;i<length;i++) {
								o = o[fieldNames[i]];
							}
							sb = o.toString();
						}
						else {
							sb = b[fieldName].toString();
						}
					}
				}
				catch(error:Error) {
					
				}
				
				if (numeric == true) {
					return ObjectUtil.numericCompare(parseFloat(sa), parseFloat(sb));
				}
				else {
					return stringCollator.compare(sa, sb);
				}
			}
			
	}
}