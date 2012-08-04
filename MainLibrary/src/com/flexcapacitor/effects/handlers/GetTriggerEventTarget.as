

package com.flexcapacitor.effects.handlers {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.handlers.EventHandler;
	
	import flash.events.Event;
	
	/**
	 * Gets the target of the event this action is part of
	 * */
	public class GetTriggerEventTarget extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 */
		public function GetTriggerEventTarget(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = GetTriggerEventTargetInstance;
		
		}
		/**
		 * Name of property on next effect. Used with the 
		 * copy target to next option.
		 * Default value is target.
		 * */
		public var targetPropertyName:String = "target";
		
		/**
		 * If true then copies the event current target to the next effect target property 
		 * */
		public var copyCurrentTargetToNext:Boolean;
		
		/**
		 * If true then copies the event target to the next effect target property 
		 * */
		public var copyTargetToNext:Boolean;
		
		/**
		 * The handler that initiated this effect
		 * */
		public var handler:EventHandler;
		
		/**
		 * The trigger event. The event that was triggered.
		 * */
		public var event:Event;
		
		/**
		 * The currentTarget of the event. 
		 * */
		public var eventCurrentTarget:Object;
		
		/**
		 * The target of the event. This is not the currentTarget.
		 * */
		public var eventTarget:Object;
		
	}
	
}

import com.flexcapacitor.effects.handlers.GetTriggerEventTarget;
import com.flexcapacitor.effects.supportClasses.ActionEffect;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
import com.flexcapacitor.handlers.EventHandler;

import flash.events.Event;

import mx.effects.IEffect;

/**
 * @copy GetTriggerEventTarget
 * */  
internal class GetTriggerEventTargetInstance extends ActionEffectInstance {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 * 
	 * */
	public function GetTriggerEventTargetInstance(target:Object) {
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
	 */
	override public function play():void {
		// Dispatch an effectStart event
		super.play();
		
		var action:GetTriggerEventTarget = GetTriggerEventTarget(effect);
		var effect:IEffect = getNextEffect();
		var handler:EventHandler = action.handler;
		var event:Event;
		
		///////////////////////////////////////////////////////////
		// Verify we have everything we need before going forward
		///////////////////////////////////////////////////////////
		
		if (validate) {
			
			// if handler is not set trigger event must not be null 
			if (!handler && !triggerEvent) {
				dispatchErrorEvent("The handler property needs to be set to the parent event handler");
			}
			
			// event will be null if handler is not set and keep event is false
			if (handler && !handler.keepEvent) {
				dispatchErrorEvent("The handler needs the keep event property to be set to true");
			}
			
			// check if we are copying target to next effect
			if (action.copyCurrentTargetToNext || action.copyTargetToNext) {
				
				// no effect found
				if (!effect) {
					dispatchErrorEvent("The copy target to next effect property is requested but no effect is found.");
				}
				
				// no property with that name in next effect
				if (!(action.targetPropertyName in effect)) {
					dispatchErrorEvent("The effect "+ effect.className+ " does not contain the property " + action.targetPropertyName + ".");
				}
			}
		}
		
		///////////////////////////////////////////////////////////
		// Continue with action
		///////////////////////////////////////////////////////////
		
		
		// if the handler is set then get the event target from there
		if (handler) {
			event = handler.event;
		}
		
		// 1008: Attribute is invalid.	GetTriggerEventTarget.as	/effects/handlers	line 167	Flex Problem
		/*else (this.triggerEvent) {
		event = triggerEvent;
		}*/
		
		// get sweet event goodness
		action.event				= event;
		action.eventTarget 			= event.target;
		action.eventCurrentTarget 	= event.currentTarget;
		action.target 				= event.currentTarget; // for good luck
		
		// copy to next effect if requested
		if (action.copyCurrentTargetToNext) {
			effect[action.targetPropertyName] = event.currentTarget;
		}
		else if (action.copyTargetToNext) {
			effect[action.targetPropertyName] = event.target;
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