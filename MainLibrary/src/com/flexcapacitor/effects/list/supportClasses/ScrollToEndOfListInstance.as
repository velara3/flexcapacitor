

package com.flexcapacitor.effects.list.supportClasses {
	
	import com.flexcapacitor.effects.list.ScrollToEndOfList;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import spark.components.supportClasses.ListBase;
	import spark.core.NavigationUnit;
	

	/**
	 * @copy ScrollToEndOfList
	 * */  
	public class ScrollToEndOfListInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ScrollToEndOfListInstance(target:Object) {
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
			
			var action:ScrollToEndOfList = ScrollToEndOfList(effect);
			var list:ListBase = action.target as ListBase;
			var delta:Number = 0;
			var count:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!list) {
					dispatchErrorEvent("The target must be set to a list based component.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (!list.dataProvider || list.dataProvider.length==0) { 
				
				if (action.hasEventListener(ScrollToEndOfList.NO_ITEMS)) {
					action.dispatchEvent(new Event(ScrollToEndOfList.NO_ITEMS));
				}
				
				if (action.noItemsEffect) { 
					playEffect(action.noItemsEffect);
				}
				
			}
			else {
			
				// update the verticalScrollPosition to the end of the List
				// virtual layout may require us to validate a few times
				
				while (count++ < 10){
					list.validateNow();
					delta = list.layout.getVerticalScrollPositionDelta(NavigationUnit.END);
					list.layout.verticalScrollPosition += delta;
					
					if (delta == 0) {
						break;
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