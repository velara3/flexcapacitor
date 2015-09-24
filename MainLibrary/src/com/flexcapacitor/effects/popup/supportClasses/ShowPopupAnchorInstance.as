

package com.flexcapacitor.effects.popup.supportClasses {
	import com.flexcapacitor.effects.popup.OpenPopUp;
	import com.flexcapacitor.effects.popup.ShowPopupAnchor;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
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
			var popUp:PopUpAnchor = PopUpAnchor(action.target);
			var hideIfOpen:Boolean = action.hideIfOpen;
			var closeOnMouseOut:Boolean = action.closeOnMouseOut;
			var displayObjectExceptions:Array = action.displayObjectExceptions;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!popUp) {
					dispatchErrorEvent("Target is required");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// if hiding through a mouse out somewhere event this may be updated before we get here
			if (hideIfOpen && popUp.popUp.parent!=null) {
				popUp.displayPopUp = false;
				finish();
				return;
			}
			
			if (closeOnMouseOut) { // this is not detecting mouse out events
				IFlexDisplayObject(popUp).addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			}
			
			
			if (action.popUpHeightMatchesAnchorHeight) 	popUp.popUpHeightMatchesAnchorHeight = action.popUpHeightMatchesAnchorHeight;
			if (action.popUpWidthMatchesAnchorWidth) 	popUp.popUpWidthMatchesAnchorWidth = action.popUpWidthMatchesAnchorWidth;
			if (action.popUpPosition) 					popUp.popUpPosition = action.popUpPosition;
			if (action.popUp) 							popUp.popUp = action.popUp;
			if (action.updatePopUpTransform) 			popUp.updatePopUpTransform();
			
			popUp.displayPopUp = true;
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			// if (closeOnMouseOut) { waitForHandlers() } else {
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Mouse out pop up
		 * */
		protected function mouseOutHandler(event:Event):void {
			var action:ShowPopupAnchor = ShowPopupAnchor(effect);
			var popUp:PopUpAnchor = PopUpAnchor(action.target);
			var displayObjectExceptions:Array = action.displayObjectExceptions;
			var exceptionFound:Boolean;
			var mouseOverObject:DisplayObject;
			//var currentTarget:DisplayObject = event.currentTarget;
			
			if (action.closeOnMouseOut) {
				IFlexDisplayObject(popUp).removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
				
				var length:int = displayObjectExceptions.length;
				for (var j:int;j<length;j++) {
					
					if (mouseOverObject == displayObjectExceptions[j]) {
						exceptionFound = true;
					}
				}
				
			}
			
			if (!exceptionFound && action.closeOnMouseOut) {
				popUp.displayPopUp = false;
				// REMOVE LISTENERS
				//removeEventListeners();
			}
			
			if (action.hasEventListener(ShowPopupAnchor.MOUSE_OUT)) {
				dispatchActionEvent(new Event(ShowPopupAnchor.MOUSE_OUT));
			}
			
			if (action.mouseOutEffect) { 
				playEffect(action.mouseOutEffect);
				//return;
			}
			
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			!exceptionFound?finish():-(1);
		}
		
		
	}
}