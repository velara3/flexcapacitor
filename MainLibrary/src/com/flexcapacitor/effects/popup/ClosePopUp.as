
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Closes a pop up
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

import mx.core.IFlexDisplayObject;
import mx.effects.EffectInstance;
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
		
		PopUpManager.removePopUp(popUp as IFlexDisplayObject);
		
		
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