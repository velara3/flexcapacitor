

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.SortCollection;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.collections.ICollectionView;
	import mx.collections.ISort;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.globalization.SortingCollator;
	
	/**
	 * @copy SortCollection
	 * */  
	public class SortCollectionInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function SortCollectionInstance(target:Object) {
			super(target);
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:SortCollection = SortCollection(effect);
			var sort:ISort = action.sort;
			var fields:Array = action.fields;
			var length:uint = fields ? fields.length : 0;
			var sortFields:Array = [];
			var descending:Boolean = action.descending;
			var previousSortDirection:int = action.lastSortDirection;
			var numeric:Object = action.numeric;
			var locale:String = action.locale;
			var compareFunction:Function = action.compareFunction;
			var defaultXMLCompareFunction:Function = action.defaultSortFunction;
			var collection:ICollectionView;
			var stringCollator:SortingCollator = new SortingCollator();
			var nestedXML:Boolean = action.nestedXML;
			var field:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (target==null) {
					dispatchErrorEvent("The target cannot be null");
				}
				
				if (!(target is ICollectionView)) {
					dispatchErrorEvent("Target must be of type collection view");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			collection = ICollectionView(action.target);
			
			if (sort==null) {
				sort = new Sort();
			}
			
			// toggle sorting option
			if (action.toggleSortDirection) {
				// -1 - not set
				// 0 - descending
				// 1 - ascending
				
				// has sort direction been called before?
				if (previousSortDirection==-1) {
					previousSortDirection = descending ? 0 : 1;
				}
				else {
					descending = previousSortDirection==0 ? false : true;
					previousSortDirection = previousSortDirection==0 ? 1 : 0;
				}
				
				action.lastSortDirection = previousSortDirection;
			}
			
			/*
			// Pull the values out of the XML object, then compare
			//  using the string or numeric comparator depending
			//  on the numeric flag.
			// Lifted from SortField xmlCompare() private method
			// Not thoroughly tested
			// There may easily be a better way to do this
			defaultXMLCompareFunction = function xmlCompare(a:Object, b:Object):int {
				var sa:String = "";
				var sb:String = "";
				var length:int = 0;
				var o:Object = 0;
				var fieldNames:Array = [];
				var fieldName:String = field.name;
				var i:int = 0;
				
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
			}*/
			
			if (fields) {
				// we accept strings or sort fields
				for (var i:uint;i<length;i++) {
					field = fields[i];
					
					if (field is SortField) {
						sortFields.push(field);
						
						// only apply to the first item
						if (i==0 && action.toggleSortDirection) {
							SortField(field).descending = descending;
						}
						
						if (locale) field.setStyle("locale", locale);
						if (nestedXML) field.compareFunction = defaultXMLCompareFunction;
						if (compareFunction!=null) field.compareFunction = compareFunction;
					}
					else if (field is String) {
						nestedXML = String(field).indexOf(".")>0;
						field = new SortField(String(field), descending, numeric);
						
						// only apply to the first item
						// if only strings are set then the second sort is ascending
						// for more accurate sorting use a SortField
						if (i==0) {
							SortField(field).descending = descending;
						}
						else {
							SortField(field).descending = false;
						}
						
						sortFields.push(field);
						if (locale) field.setStyle("locale", locale);
						if (nestedXML) field.compareFunction = defaultXMLCompareFunction;
						if (compareFunction!=null) field.compareFunction = compareFunction;
					}
				}
			}
			else {
				field = new SortField(null, descending, numeric);
				sortFields.push(field);
				if (locale) field.setStyle("locale", locale);
				if (nestedXML) field.compareFunction = defaultXMLCompareFunction;
				if (compareFunction!=null) field.compareFunction = compareFunction;
			}
			
			sort.fields = sortFields;
			collection.sort = sort;
			
			if (action.refresh) {
				collection.refresh();
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}