

package com.flexcapacitor.effects.list.supportClasses {
	
	import com.flexcapacitor.effects.list.ScrollItemIntoView;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.ListCollectionView;
	

	/**
	 * @copy ScrollItemIntoView
	 * */  
	public class ScrollItemIntoViewInstance extends ActionEffectInstance {
		
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
		public function ScrollItemIntoViewInstance(target:Object) {
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
			
			var action:ScrollItemIntoView = ScrollItemIntoView(effect);
			
			// we were checking for ListBase but DataGrid doesn't use ListBase so list is an object
			var list:Object = target;
			var dataProvider:ListCollectionView;
			var item:Object;
			var itemIndex:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (list==null) {
					dispatchErrorEvent("The target must be set to a list or datagrid type of component.");
				}
				
				if (!list.hasOwnProperty("selectedItem") 
					|| !list.hasOwnProperty("selectedIndex")) {
					dispatchErrorEvent("The target must be set to a list typed component with selectedItem and selectedIndex properties");
				}
				
				if (!list.hasOwnProperty("ensureIndexIsVisible")) {
					dispatchErrorEvent("The target must have the ensureIndexIsVisible function");
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
				if (action.hasEventListener(ScrollItemIntoView.ITEM_NOT_SET)) {
					dispatchActionEvent(new Event(ScrollItemIntoView.ITEM_NOT_SET));
				}
				
				if (action.itemNotSetEffect) { 
					playEffect(action.itemNotSetEffect);
				}
				
			}
			else if (dataProvider==null) {
				
				// data provider is null
				if (action.hasEventListener(ScrollItemIntoView.DATAPROVIDER_NOT_SET)) {
					dispatchActionEvent(new Event(ScrollItemIntoView.DATAPROVIDER_NOT_SET));
				}
				
				if (action.dataProviderNotSetEffect) { 
					playEffect(action.dataProviderNotSetEffect);
				}
			}
			else {
				
				if (dataProvider) {
					itemIndex = dataProvider.getItemIndex(item);
					
					if (itemIndex>=0) {
						list.ensureIndexIsVisible(itemIndex);
						
						// item is found
						if (action.hasEventListener(ScrollItemIntoView.ITEM_FOUND)) {
							dispatchActionEvent(new Event(ScrollItemIntoView.ITEM_FOUND));
						}
						
						if (action.itemFoundEffect) { 
							playEffect(action.itemFoundEffect);
						}
					}
					else {
						
						
						// item is not found
						if (action.hasEventListener(ScrollItemIntoView.ITEM_NOT_FOUND)) {
							dispatchActionEvent(new Event(ScrollItemIntoView.ITEM_NOT_FOUND));
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
		
	}
	
	
}