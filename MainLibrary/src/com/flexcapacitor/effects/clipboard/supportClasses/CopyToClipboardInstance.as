

package com.flexcapacitor.effects.clipboard.supportClasses {
	
	import com.flexcapacitor.effects.clipboard.CopyToClipboard;
	import com.flexcapacitor.effects.core.PlayerType;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	/**
	 * @copy CopyToClipboard
	 * */  
	public class CopyToClipboardInstance extends ActionEffectInstance {
		
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
		public function CopyToClipboardInstance(target:Object) {
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
			
			var action:CopyToClipboard = CopyToClipboard(effect);
			var allowNullData:Boolean = action.allowNullData;
			var AIRPlayerType:Boolean = Capabilities.playerType==PlayerType.DESKTOP;
			var data:Object = action.data;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// if we are in the browser we must run our code during a click event
			if (validate) {
				if (!AIRPlayerType && !action.targetAncestor) {
					errorMessage = "The target ancestor must be set";
					dispatchErrorEvent(errorMessage);
				}
				
				if (data==null && !allowNullData) {
					dispatchErrorEvent("Data is required for the clipboard");
				}
				
				// if using EventHandler class you must set the setTriggerEvent property to true
				if (!AIRPlayerType && !(triggerEvent is MouseEvent)) {
					
					if (triggerEvent) {
						errorMessage = "The clipboard code may never get called if the event is not a mouse event (doesn't bubble up)";
					}
					else {
						errorMessage = "The trigger event is not set. Set setTriggerEvent to true or set triggerEvent to the click MouseEvent.";
					}
					dispatchErrorEvent(errorMessage);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check for null data
			if (data==null && allowNullData) {
				
				if (action.noDataEffect) {
					playEffect(action.noDataEffect);
				}
				
				if (action.hasEventListener(CopyToClipboard.NO_DATA)) {
					dispatchActionEvent(new Event(CopyToClipboard.NO_DATA));
				}
				
				finish();
				return;
			}
			
			// if we are in AIR we run the code right away
			if (AIRPlayerType) {
				
				copyToClipboard();
				
			}
			else {
				
				action.invokeCopyToClipboard = true;
				
				// add a click event listener to the parent 
				// so we can attach a click event listeners to the child 
				// while the event is bubbling.
				// we do this to get around a security restriction that prevents copy to clipboard
				// unless triggered by a click event
				action.targetAncestor.addEventListener(triggerEvent.type, buttonHandler);
				
				// NOTE: If nothing is happening make sure that the button or *buttons* 
				// that are triggering this event have the targetAncestor as their ancestor
				// and that there is no pause or duration between the click event and this effect
				// IE no other effect that has a duration can run before this one
				waitForHandlers();
				
				return;
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
		 * Handles the event tied to copying to the clipboard. 
		 * */
		public function buttonHandler(event:MouseEvent):void {
			var action:CopyToClipboard = CopyToClipboard(effect);
			
			// remove event listener
			action.targetAncestor.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			copyToClipboard();
			
			// finish is called in copyToClipboard()
			
		}
		
		/**
		 * Copies data to the clipboard. 
		 * If the value is set but the data is not in the clipboard 
		 * check the Clipboard documentation. The browser security model
		 * requires a click event to be performed before setting the clipboard
		 * */
		private function copyToClipboard():void {
			var action:CopyToClipboard = CopyToClipboard(effect);
			var clipboard:Clipboard = Clipboard.generalClipboard;
			var format:String = action.format;
			var serializable:Boolean = action.serializable;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			// it's recommended to clear the clipboard before setting new content
			if (action.clearClipboard) {
				clipboard.clear();
			}
			
			// Cast data to String
			if (format==ClipboardFormats.TEXT_FORMAT 
				|| format==ClipboardFormats.HTML_FORMAT
				|| format==ClipboardFormats.RICH_TEXT_FORMAT
				|| format==ClipboardFormats.URL_FORMAT) {
				
				try {
					clipboard.setData(format, String(action.data), serializable);
					
					if (action.successEffect) {
						playEffect(action.successEffect);
					}
					
					if (action.hasEventListener(CopyToClipboard.SUCCESS)) {
						dispatchActionEvent(new Event(CopyToClipboard.SUCCESS));
					}
				}
				catch (error:ErrorEvent) {
					
					action.errorEvent = error;
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					if (action.hasEventListener(CopyToClipboard.ERROR)) {
						dispatchActionEvent(new Event(CopyToClipboard.ERROR));
					}
				}
			}
			else {
				
				try {
					clipboard.setData(format, action.data, serializable);
					
					if (action.successEffect) {
						playEffect(action.successEffect);
					}
					
					if (action.hasEventListener(CopyToClipboard.SUCCESS)) {
						dispatchActionEvent(new Event(CopyToClipboard.SUCCESS));
					}
				}
				catch (error:ErrorEvent) {
					
					action.errorEvent = error;
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					if (action.hasEventListener(CopyToClipboard.ERROR)) {
						dispatchActionEvent(new Event(CopyToClipboard.ERROR));
					}
				}
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
	}
	
	
}