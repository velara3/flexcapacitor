
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Closes a callout
	 * */
	public class CloseCallout extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 * 
		 */
		public function CloseCallout(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = CloseCalloutInstance;
		}
		
		/**
		 * Callout Button or Callout
		 * @see spark.components.Callout
		 * @see spark.components.CalloutButton
		 * */
		public var callout:Object;
		
		/**
		 * In a Callout specifies if the return data should be committed by the application. 
		 * The value of this argument is written to the commit property of the PopUpEvent event object.<br/><br/>
		 * @copy spark.components.Callout#close
		 * */
		public var commit:Boolean;
		
		/**
		 * In a Callout specifies any data returned to the application. 
		 * The value of this argument is written to the data property of the PopUpEvent event object.<br/><br/>
		 * @copy spark.components.Callout#close
		 * */
		public var data:Object;
	}
}



/////////////////////////////////////////////////////////////////////////
//
// EFFECT INSTANCE
//
/////////////////////////////////////////////////////////////////////////

import com.flexcapacitor.effects.popup.CloseCallout;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;

import mx.core.IFlexDisplayObject;
import mx.effects.EffectInstance;
import mx.managers.PopUpManager;


/**
 * @copy CloseCallout
 */ 
class CloseCalloutInstance extends ActionEffectInstance {
	
	
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
	public function CloseCalloutInstance(target:Object) {
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
		
		var action:CloseCallout = CloseCallout(effect);
		var callout:Object = action.callout;
		var data:Object = action.data;
		var commit:Boolean = action.commit;
		
		///////////////////////////////////////////////////////////
		// Verify we have everything we need before going forward
		///////////////////////////////////////////////////////////
		
		if (validate) {
			if (!callout) {
				dispatchErrorEvent("The callout cannot be null");
			}
			
			if (!("closeDropDown" in callout) && !("close" in callout)) {
				dispatchErrorEvent("The callout must have the method close or closeDropDown");
			}
		}
		
		
		///////////////////////////////////////////////////////////
		// Continue with action
		///////////////////////////////////////////////////////////
		
		if ("closeDropDown" in callout) {
			callout.closeDropDown();
		}
		else if ("close" in callout) {
			callout.close(commit, data);
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