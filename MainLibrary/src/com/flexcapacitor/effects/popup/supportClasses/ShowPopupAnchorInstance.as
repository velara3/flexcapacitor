

package com.flexcapacitor.effects.popup.supportClasses {
	import com.flexcapacitor.effects.popup.ShowPopupAnchor;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import spark.components.PopUpAnchor;
	
	
	/**
	 *  @copy ShowPopupAnchor
	 */  
	public class ShowPopupAnchorInstance extends ActionEffectInstance {
		
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
		public function ShowPopupAnchorInstance(target:Object) {
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
			super.play(); // dispatches startEffect
			
			var action:ShowPopupAnchor = ShowPopupAnchor(effect);
			var popup:PopUpAnchor = PopUpAnchor(action.target);
			var hideIfOpen:Boolean = action.hideIfOpen;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!popup) {
					cancel("Target is required");
					throw new Error("Target is required");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// if hiding through a mouse out somewhere event this may be updated before we get here
			if (hideIfOpen && popup.popUp.parent!=null) {
				popup.displayPopUp = false;
				finish();
				return;
			}
			
			
			if (action.popUpHeightMatchesAnchorHeight) 	popup.popUpHeightMatchesAnchorHeight = action.popUpHeightMatchesAnchorHeight;
			if (action.popUpWidthMatchesAnchorWidth) 	popup.popUpWidthMatchesAnchorWidth = action.popUpWidthMatchesAnchorWidth;
			if (action.popUpPosition) 					popup.popUpPosition = action.popUpPosition;
			if (action.popUp) 							popup.popUp = action.popUp;
			if (action.updatePopUpTransform) 			popup.updatePopUpTransform();
			
			popup.displayPopUp = true;
			
			
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