

package com.flexcapacitor.effects.supportClasses {
	
	import com.flexcapacitor.events.EffectEvent;
	import com.flexcapacitor.performance.PerformanceMeter;
	import com.flexcapacitor.performance.ProfileTest;
	import com.flexcapacitor.performance.Timestamp;
	import com.flexcapacitor.utils.VectorUtils;
	
	import flash.events.EventDispatcher;
	
	import mx.core.mx_internal;
	import mx.effects.Effect;
	import mx.effects.IEffectInstance;
	
	use namespace mx_internal;
	
	/**
	 *  Dispatched when the effect has been canceled,
	 *  which only occurs when the effect calls the 
	 *  <code>cancel()</code> method.
	 *  The EFFECT_END event is also dispatched to indicate that
	 *  the effect has ended. This extra event is sent first, as an
	 *  indicator to listeners that the effect did not reach its
	 *  end state.
	 *
	 *  @eventType com.flexcapacitor.events.EffectEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="effectCancel", type="com.flexcapacitor.events.EffectEvent")]
	
	/**
	 *  Dispatched when the effect has timed out,
	 *  which only occurs when an effect has event listeners 
	 *  and has reached the time set in the timeout property.
	 *  The EFFECT_END event is also dispatched to indicate that
	 *  the effect has ended. This extra event is sent first, as an
	 *  indicator to listeners that the effect did not reach its
	 *  end state.
	 *  If the timeout is 0 (default) then a timeout event never 
	 *  dispatches.
	 *
	 *  @eventType com.flexcapacitor.events.EffectEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="effectTimeout", type="com.flexcapacitor.events.EffectEvent")]
	
	/**
	 * Base class for enhanced Effect classes. <br/><br/>
	 * 
	 * In Action Effects you need to explicitly pause or end the effect instance. <br/><br/>
	 * 
	 * Call finish() at the end of the play method to end the effect immediately.<br/>
	 * 
	 * Call waitForHandlers() to wait until some actions have finished. 
	 * When the actions have finished then call finish(). Usually you call this method 
	 * in event handlers you've added. <br/><br/>
	 * 
	 * Call cancel() to end the effects and end the parent effect if part of one. 
	 * By default cancel will end all parent effects up the chain. If you don't
	 * want to cancel out of all ancestor effects set cancelAncestorEffects to false.
	 * */
	public class ActionEffect extends Effect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ActionEffect(target:Object = null)
		{
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			// set this to 0 to end the effect immediately
			duration = 0;
			
			instanceClass = ActionEffectInstance;
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
		
		/** 
		 * Name of event that Pause is waiting on before ending. 
		 * This parameter must be used in conjunction with the
		 * <code>target</code> property, which must be of type
		 * IEventDispatcher; all events must originate
		 * from some dispatcher.
		 * 
		 * <p>Listening for <code>eventName</code> is also related to the
		 * <code>duration</code> property, which acts as a timeout for the
		 * event. If the event is not received in the time period specified
		 * by <code>duration</code>, the effect will end, regardless.</p>
		 * 
		 * <p>This property is optional; the default
		 * action is to play without waiting for any event.</p>
		 *  
		 * NOTE: This has been deprecated. Dispatch events or play child effects from within the effect instance methods.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var continueAfterEvent:String
		
		/** 
		 * The duration property controls the amount of time that this effect
		 * will pause. The duration also serves as a timeout on waiting for
		 * the event to be fired, if <code>eventName</code> was set on this
		 * effect. If duration is less than 0, the effect will wait
		 * indefinitely for the event to fire. If it is set to any other time,
		 * including 0, the effect will end either when that duration has elapsed
		 * or when the named event fires, whichever comes first.
		 * 
		 * @default 500
		 * 
		 * @see mx.effects.IEffect#duration
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get duration():Number {
			return super.duration;
		}
		
		/**
		 * Removes or disables the effect after it's been played once
		 * */
		public var removeOncePlayed:Boolean;
		
		/**
		 * Indicates if the effect has been played once
		 * @see removeOncePlayed
		 * */
		public var playcount:int;
		
		/**
		 * Describes this action for code readability. No functional use.
		 * */
		public var description:String;
		
		
		/**
		 * Start time. Time the action instance is created. 
		 * */
		public var profileStartTime:int;
		
		/**
		 * Record the time from when play is called until when finish is called. 
		 * Values are stored in the profileData property
		 * */
		public var profile:Boolean;
		
		/**
		 * Sends profile time to the console
		 * */
		public var profileToConsole:Boolean;
		
		private var _profileData:Array;
		
		/**
		 * When set to true calls enterDebugger method right before the effect is played
		 * */
		public var stepInto:Boolean;
		
		/**
		 * Gets the performance data. 
		 * No profile data is available if the profile property is false.
		 * */
		[Bindable]
		public function get profileData():Array {
			var test:ProfileTest = PerformanceMeter.getTest(className);
			
			if (test && test.timestamps.length) {
				var array:Array = test.timestamps as Array;
				return VectorUtils.vectorToArray(test.timestamps, Timestamp);
			}
			return [];
		}
		
		public function set profileData(value:Array):void {
			_profileData = value; // trigger data binding
		}
		
		/**
		 * Gets the performance test. 
		 * No profile test is available if the profile property is false.
		 * */
		public function get profileTest():ProfileTest {
			return PerformanceMeter.getTest(className);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 */
		override protected function initInstance(instance:IEffectInstance):void {
			//trace("init instance");
			if (removeOncePlayed && playcount==1) {
				super.deleteInstance(instance);
				return;
			}
			super.initInstance(instance);
			
			var actionInstance:ActionEffectInstance = ActionEffectInstance(instance);
			
			actionInstance.eventName = continueAfterEvent;
			actionInstance.stepInto = stepInto;
		}
		
		/**
		 * This is so we can listen and dispatch effect cancel and timeout events.
		 * */
		override public function createInstance(target:Object=null):IEffectInstance {
			//trace("create instance");
			var newInstance:IEffectInstance = super.createInstance(target);
			
			EventDispatcher(newInstance).addEventListener(EffectEvent.EFFECT_CANCEL, effectCancelHandler);
			EventDispatcher(newInstance).addEventListener(EffectEvent.EFFECT_TIMEOUT, effectTimeoutHandler);
			
			return newInstance;
		}
		
		/**
		 * @private
		 * */
		override public function createInstances(targets:Array = null):Array /* of EffectInstance */ {
			//trace("create instances");
			
			return super.createInstances(targets);
		}
		
		/**
		 *  We are extending this method to remove the effect cancel and timeout events.
		 *  @copy mx.effects.IEffect#deleteInstance()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function deleteInstance(instance:IEffectInstance):void {
			//trace("delete instance");
			EventDispatcher(instance).removeEventListener(EffectEvent.EFFECT_CANCEL, effectCancelHandler);
			EventDispatcher(instance).removeEventListener(EffectEvent.EFFECT_TIMEOUT, effectTimeoutHandler);
			
			super.deleteInstance(instance);
		}
		
		
		/**
		 *  @private
		 * Used to copy values from the action to the action instance
		 */
		public function reinitializeInstance(instance:IEffectInstance):void {
			initInstance(instance);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Dispatches an effect cancel event.
		 * */
		protected function effectCancelHandler(event:EffectEvent):void {
			hasEventListener(EffectEvent.EFFECT_CANCEL) ? dispatchEvent(new EffectEvent(EffectEvent.EFFECT_CANCEL, event.bubbles, event.cancelable, event.effectInstance)):void;
		}
		
		/**
		 * Dispatches an effect timeout event.
		 * */
		protected function effectTimeoutHandler(event:EffectEvent):void {
			hasEventListener(EffectEvent.EFFECT_TIMEOUT)?dispatchEvent(new EffectEvent(EffectEvent.EFFECT_TIMEOUT, event.bubbles, event.cancelable, event.effectInstance)):void;
		}
		
		
		
	}
}