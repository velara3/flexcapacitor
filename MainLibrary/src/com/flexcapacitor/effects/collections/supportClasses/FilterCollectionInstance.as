

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.FilterCollection;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.collections.ICollectionView;
	
	/**
	 * @copy FilterCollection
	 * */  
	public class FilterCollectionInstance extends ActionEffectInstance {
		
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
		public function FilterCollectionInstance(target:Object) {
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
			
			var action:FilterCollection = FilterCollection(effect);
			var collection:ICollectionView;
			var filterFunction:Function = action.filterFunction;
			var caseSensitive:Boolean = action.caseSensitive;
			var searchAtStart:Boolean = action.searchAtStart;
			var fieldName:String = action.fieldName;
			var showAllItemsOnEmpty:Boolean = action.showAllItemsOnEmpty;
			var defaultFilterFunction:Function = action.defaultFilterFunction;
			
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

			/*
			defaultFilterFunction = function(item:Object):Boolean {
				var filterValue:String;
				var itemValue:String;
				var valueLength:int;

				filterValue = action.sourcePropertyName ? action.source[action.sourcePropertyName] : String(action.source);
				itemValue = fieldName ? item[fieldName] : String(item);
				valueLength = filterValue ? filterValue.length : 0;
				
				// show all items if search is empty
				if (showAllItemsOnEmpty && valueLength==0) {
					return true;
				}
				
				if (!caseSensitive) { 
					filterValue = filterValue ? filterValue.toLowerCase() : filterValue;
					itemValue = itemValue ? itemValue.toLowerCase() : itemValue;
				}
				
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
				
				if (itemValue.indexOf(filterValue)!=-1) {
					return true;
				}
				
				return false;
			}*/
			
			collection = ICollectionView(action.target);
			
			if (filterFunction!=null) {
				collection.filterFunction = filterFunction;
			}
			else {
				if (collection.filterFunction!=defaultFilterFunction) {
					collection.filterFunction = defaultFilterFunction;
				}
			}
			
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
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/*protected function defaultFilterFunction(item:Object):Boolean {
			var itemName:String = item.attribute("name") ? item.attribute("name") : "";
			var value:String = searchPropertyInput.text;
			var valueLength:int = value.length;
			var itemNameLength:int = itemName.length;
			var valueLowerCase:String = value.toLowerCase();
			var itemNameLowerCase:String = itemName.toLowerCase();
			
			// show all items if search is empty
			if (valueLength==0) {
				return true;
			}
			
			// show custom item in case of style
			if (item.@search=="true") {
				item.@name = CUSTOM_ITEM_SORT_CHARACTER + value;
				filteredPropertiesCollection.enableAutoUpdate();
				return true;
			}
			else {
				filteredPropertiesCollection.disableAutoUpdate();
			}
			
			// if we type a period or a space at the end of the word then 
			// the value and the name have to match exactly (case-insensitive)
			if (value.lastIndexOf(".")==valueLength-1 || value.lastIndexOf(" ")==valueLength-1) {
				if (itemNameLowerCase+"."==valueLowerCase || itemNameLowerCase+" "==valueLowerCase) {
					return true;
				}
				else {
					return false;
				}
			}
			
			// we filter from any index
			if (itemNameLowerCase.indexOf(valueLowerCase) != -1) {
				return true;
			}
			
			return false;
		}*/
		
	}
}