package com.flexcapacitor.effects.popup.supportClasses
{
	
	import com.flexcapacitor.effects.popup.ClosePopUp;
	import com.flexcapacitor.effects.popup.OpenPopUp;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	
	
	/**
	 *
	 * @copy ClosePopUp
	 * @copy mx.effects.effectClasses.TweenEffectInstance
	 */ 
	public class ClosePopUpInstance extends ActionEffectInstance {
		
		
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
		public function ClosePopUpInstance(target:Object) {
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
			
			var action:ClosePopUp = ClosePopUp(effect);
			var popUp:Object = action.popUp;
			var popUpCanBeNull:Boolean = action.popUpCanBeNull;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!popUp && !popUpCanBeNull) {
					dispatchErrorEvent("The pop up is null. Please set the pop up or set popUpCanBeNull to true.");
				}
				
				if (popUp && !(popUp is IFlexDisplayObject)) {
					dispatchErrorEvent("The pop up class type must be of a type 'IFlexDisplayObject'");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// can't use popUp call later so using top level application call later
			// TypeError: Error #1009: Cannot access a property or method of a null object reference.
			// 		at mx.effects::EffectManager$/http://www.adobe.com/2006/flex/mx/internal::eventHandler()[E:\dev\4.y\frameworks\projects\framework\src\mx\effects\EffectManager.as:605]
			
			// adding trigger event if not set otherwise we get errors if effect is still playing at 
			// the time other code in EffectManager is called
			// if using EventHandler the trigger event must be set on each effect playing. 
			if (triggerEvent==null) {
				triggerEvent = new Event(Event.REMOVED);
			}
			
			// dispatch event so our OpenPopUp effect can dispatch close events
			if (popUp is IEventDispatcher) {
				IEventDispatcher(popUp).dispatchEvent(new Event(OpenPopUp.CLOSING));
			}
			
			if (FlexGlobals.topLevelApplication && triggerEvent) {
				// causes flicker when effects are used in pop up because 
				// it is removed then added back so effects can run
				// so we wait a frame
				//PopUpManager.removePopUp(popUp as IFlexDisplayObject);
				UIComponent(FlexGlobals.topLevelApplication).callLater(PopUpManager.removePopUp, [(popUp as IFlexDisplayObject)]);
			}
			else {
				try {
					PopUpManager.removePopUp(popUp as IFlexDisplayObject);
				}
				catch (error:Error) {
					// sometimes the pop up is already closed or something 
					// or there's a bug in PopUpManager or EffectManager	
				}
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
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