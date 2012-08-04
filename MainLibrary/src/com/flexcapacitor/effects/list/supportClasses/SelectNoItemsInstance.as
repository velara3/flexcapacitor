

package com.flexcapacitor.effects.list.supportClasses {
	
	import com.flexcapacitor.effects.list.SelectNoItems;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	

	/**
	 * @copy SelectNoItems
	 * */  
	public class SelectNoItemsInstance extends ActionEffectInstance {
		
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
		public function SelectNoItemsInstance(target:Object) {
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
			
			var action:SelectNoItems = SelectNoItems(effect);
			
			// we were checking for ListBase but DataGrid doesn't use ListBase so list is an object
			var list:Object = target;
			
			
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
				
				if (!list.dataProvider) {
					dispatchErrorEvent("The list data provider is not set");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// no items in the data provider
			if (list.dataProvider.length==0) { 
				// should work ?
				//list.selectedIndex = -1;
				
				if (action.hasEventListener(SelectNoItems.NO_ITEMS)) {
					action.dispatchEvent(new Event(SelectNoItems.NO_ITEMS));
				}
				
				if (action.noItemsEffect) { 
					playEffect(action.noItemsEffect);
				}
				
			}
			else {
				
				if (action.setSelectedIndex) {
					list.selectedIndex = -1;
				}
				
				if (action.setSelectedItem) {
					list.selectedItem = null;
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