

package com.flexcapacitor.effects.list.supportClasses {
	
	import com.flexcapacitor.effects.list.SelectItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.ListCollectionView;
	

	/**
	 * @copy SelectItem
	 * */  
	public class SelectItemInstance extends ActionEffectInstance {
		
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
		public function SelectItemInstance(target:Object) {
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
		 * */
		override public function play():void {
			super.play(); // dispatch startEffect
			
			var action:SelectItem = SelectItem(effect);
			var item:*;
			// we were checking for ListBase but DataGrid doesn't use ListBase so list is an object
			var list:Object = target;
			var dataProvider:ListCollectionView;
			var ensureItemIsVisible:Boolean = action.ensureItemIsVisible;
			var dataPropertyName:String = action.dataPropertyName;
			var setItemToActualItem:Boolean = action.setItemToActualItem;
			var itemIndex:int;
			var value:*;
			var source:Object;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (list==null) {
					dispatchErrorEvent("The target must be set to a list or datagrid type of component.");
				}
				
				if (!list.hasOwnProperty("dataProvider")) {
					dispatchErrorEvent("The list must have a dataProvider property");
				}
				
				if (!list.hasOwnProperty("selectedItem")) {
					dispatchErrorEvent("The list must have a selectedItem property");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			item = action.data;
			dataProvider = list.dataProvider as ListCollectionView;
			
			
			// item is null
			if (item==null) { 
				
				// item is null
				if (action.hasEventListener(SelectItem.ITEM_NOT_SET)) {
					dispatchActionEvent(new Event(SelectItem.ITEM_NOT_SET));
				}
				
				if (action.itemNotSetEffect) { 
					playEffect(action.itemNotSetEffect);
				}
				
			}
			else if (dataProvider==null) {
				
				// data provider is null
				if (action.hasEventListener(SelectItem.DATAPROVIDER_NOT_SET)) {
					dispatchActionEvent(new Event(SelectItem.DATAPROVIDER_NOT_SET));
				}
				
				if (action.dataProviderNotSetEffect) { 
					playEffect(action.dataProviderNotSetEffect);
				}
			}
			else {
				
				// select item
				if (dataPropertyName==null) {
					list.selectedItem = item;
				}
				
				
				// find item - make sure we selected it and dispatch events
				else if (dataProvider) {
					
					// if data property name is set then we search for the item
					if (dataPropertyName) {
						// get array
						source = dataProvider.hasOwnProperty("source") ? dataProvider['source'] : null;
						
						// make sure we have the property
						if (!(item as Object).hasOwnProperty(dataPropertyName)) {
							dispatchErrorEvent("The item does not have the " + dataPropertyName + " property");
						}
						else {
							
							// find item by property name
							if (source) {
								item = indexOfItemWithProp(source, dataPropertyName, item[dataPropertyName]);
							}
							else {
								item = indexOfItemWithProp(dataProvider, dataPropertyName, item[dataPropertyName]);
							}
							
							// select item
							if (item) {
								list.selectedItem = item;
								
								if (setItemToActualItem) {
									action.data = item;
								}
							}
						}

					}
					
					itemIndex = dataProvider.getItemIndex(item);
					
					if (itemIndex>=0) {
						if (ensureItemIsVisible) {
							list.ensureIndexIsVisible(itemIndex);
						}
						
						// item found
						if (action.hasEventListener(SelectItem.ITEM_FOUND)) {
							dispatchActionEvent(new Event(SelectItem.ITEM_FOUND));
						}
						
						if (action.itemFoundEffect) { 
							playEffect(action.itemFoundEffect);
						}
					}
					else {
						
						
						// item is not found
						if (action.hasEventListener(SelectItem.ITEM_NOT_FOUND)) {
							dispatchActionEvent(new Event(SelectItem.ITEM_NOT_FOUND));
						}
						
						if (action.itemNotFoundEffect) { 
							playEffect(action.itemNotFoundEffect);
						}
					}
				}
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
		
		
		/**
		 * Returns the index of an element in an array matching the search element
		 * given the property name of the items to search.
		 * Returns -1 if not found.
		 * @author NBilyk
		 */
		public static function indexOfWithProp(array:Object, prop:String, searchElement:Object):int {
			var i:int = 0;
			for each (var value:Object in array) {
				if (value.hasOwnProperty(prop)) {
					if (value[prop] == searchElement) {
						return i;
					}
				}
				i++;
			}
			
			return -1;
		}
		
		/**
		 * Returns the value of an element in an array matching the search element
		 * given the property name of the items to search.
		 * Returns null if not found.
		 * @author NBilyk
		 */
		public static function indexOfItemWithProp(array:Object, prop:String, searchElement:Object):* {
			var i:int = 0;
			for each (var value:Object in array) {
				if (value.hasOwnProperty(prop)) {
					if (value[prop] == searchElement) {
						return value;
					}
				}
				i++;
			}
			
			return null;
		}
	}
	
	
}