

package com.flexcapacitor.effects.list.supportClasses {
	
	import com.flexcapacitor.effects.list.GetSelectedItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	

	/**
	 * @copy GetSelectedItem
	 * */  
	public class GetSelectedItemInstance extends ActionEffectInstance {
		
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
		public function GetSelectedItemInstance(target:Object) {
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
			
			var action:GetSelectedItem = GetSelectedItem(effect);
			// was checking for ListBase but DataGrid doesn't use ListBase so list is object
			var list:Object = action.target;
			
			
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
				
				if (!list.hasOwnProperty("selectedItem") 
					|| !list.hasOwnProperty("selectedIndex")) {
					dispatchErrorEvent("The target must be set to a list typed component with selectedItem and selectedIndex properties");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check if the property is set
			if (list.selectedItem==null) { 
				
				if (action.hasEventListener(GetSelectedItem.NO_SELECTED_ITEM)) {
					action.dispatchEvent(new Event(GetSelectedItem.NO_SELECTED_ITEM));
				}
				
				if (action.noSelectedItemEffect) { 
					playEffect(action.noSelectedItemEffect);
				}
				
			}
			else {
				action.data = list.selectedItem;
				action.dataIndex = list.selectedIndex;
				
				if (action.hasEventListener(GetSelectedItem.SELECTED_ITEM)) {
					action.dispatchEvent(new Event(GetSelectedItem.SELECTED_ITEM));
				}
				
				if (action.selectedItemEffect) { 
					playEffect(action.selectedItemEffect);
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