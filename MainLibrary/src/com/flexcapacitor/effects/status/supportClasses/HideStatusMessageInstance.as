

package com.flexcapacitor.effects.status.supportClasses {
	import com.flexcapacitor.effects.status.HideStatusMessage;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	/**
	 * @copy HideStatusMessage
	 * */
	public class HideStatusMessageInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function HideStatusMessageInstance(target:Object) {
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
			super.play();
			
			var action:HideStatusMessage = HideStatusMessage(effect);
			var statusMessage:IStatusMessage;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (action.statusMessagePopUp==null && !action.allowNullReference) {
				dispatchErrorEvent("The reference to the status message is null. Set keep reference on the ShowStatusMessage class or set allow null reference to true to ignore this error."); 
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			statusMessage = action.statusMessagePopUp as IStatusMessage;
			
			if (statusMessage) {
				statusMessage.fadeInDuration = action.fadeOutDuration;
				PopUpManager.removePopUp(statusMessage as IFlexDisplayObject);
			}
			
			if (action.closeHandler!=null) {
				action.closeHandler();
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
	}
}