
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Closes a pop up.<br/><br/>
	 * 
	 * Typically you use it with OpenPopUp or ShowStatusMessage.
	 * 
	 * Opening a pop up:<br/>
	 * <pre>
&lt;popup:OpenPopUp id="openExportToImageEffect" 
		 popUpType="{ExportToImage}" 
		 modalDuration="250"
		 showDropShadow="true"
		 modalBlurAmount="1"
		 keepReference="true"
		 options="{{source:myImage.source, data:dataGrid.selectedItem}}">
&lt;/popup:OpenPopUp>
					 
	 * </pre>
	 * 
	 * To Use:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{openExportToImageEffect.popUp}" />
	 * </pre>
	 * 
	 * To Use when inside the pop up use:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{this}" />
	 * </pre>
	 * 
	 * Note: If there is flicker when closing then be sure to set the triggerEvent of this 
	 * effect. 
	 * */
	public class ClosePopUp extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 * 
		 */
		public function ClosePopUp(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ClosePopUpInstance;
		}
		
		/**
		 * Popup instance
		 * */
		public var popUp:Object;
		
		/**
		 * Since a popup can be removed by clicking outside of it's self the 
		 * callout may be null. To throw an error when it's null set this to false.
		 * */
		public var popUpCanBeNull:Boolean = true;
	}
}



/////////////////////////////////////////////////////////////////////////
//
// EFFECT INSTANCE
//
/////////////////////////////////////////////////////////////////////////

import com.flexcapacitor.effects.popup.ClosePopUp;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;

import flash.events.Event;

import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.managers.PopUpManager;



/**
 *
 * @copy ClosePopUp
 * @copy mx.effects.effectClasses.TweenEffectInstance
 */ 
class ClosePopUpInstance extends ActionEffectInstance {
	
	
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