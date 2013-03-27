

package com.flexcapacitor.effects.supportClasses {
	import com.flexcapacitor.events.EffectEvent;
	import com.flexcapacitor.performance.PerformanceMeter;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	import mx.effects.CompositeEffect;
	import mx.effects.EffectInstance;
	import mx.effects.IEffect;
	import mx.effects.IEffectInstance;
	import mx.effects.Sequence;
	import mx.effects.effectClasses.SequenceInstance;
	import mx.effects.effectClasses.TweenEffectInstance;
	
	use namespace mx_internal;
	
	/**
	 * The ActionEffectInstance class is the instance class for Action Effects.
	 * 
	 * In Action Effects you need to explicitly pause or end the effect instance. 
	 * Call finish() at the end of the play method to end the effect immediately.
	 * Call waitForHandlers() to wait until some actions have finished. 
	 * When the actions have finished then call finish(). Usually you call this method 
	 * in event handlers you've added. 
	 * Call cancel() to end the effects and end the parent effect if part of one. 
	 * By default cancel will end all parent effects up the chain. If you don't
	 * want to cancel out of all ancestor effects set cancelAncestorEffects to false.
	 * */
	public class ActionEffectInstance extends TweenEffectInstance {
		
		
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
		public function ActionEffectInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * We cache the source for the event "eventName" to remove
		 * the listener for it when the effect ends.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var eventSource:IEventDispatcher;
		
		/**
		 * If we have added an event listener 
		 * then we need to wait until that event is dispatched before
		 * ending the effect and continuing on to the next effect. 
		 * We use the timeout property to cancel and end the effect 
		 * if the event does not occur in the specified time. 
		 * By default there is no timeout set. 
		 * If no event listeners are specified then this property has no
		 * function.
		 * */
		public var timeout:int;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Name of event that the effect is waiting on before ending. 
		 * This parameter must be used in conjunction with the
		 * <code>target</code> property, which must be of type
		 * IEventDispatcher; all events must originate
		 * from some dispatcher.
		 * 
		 * <p>Listening for <code>eventName</code> is also related to the
		 * <code>timeout</code> property, which acts as a timeout for the
		 * event. If the event is not received in the time period specified
		 * by <code>timeout</code>, the effect will end, regardless.</p>
		 * 
		 * <p>This property is optional; the default
		 * action is to play without waiting for any event.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var eventName:String
		
		/**
		 * Effect to play when a timeout occurs.
		 * */
		public var timeoutEffect:ActionEffect;
		
		/**
		 * Effect to play when an effect is canceled. 
		 * Can be called by calling the cancel method. 
		 * */
		public var cancelEffect:ActionEffect;
		
		/**
		 * When cancel is called recursively cancels all 
		 * parent composite effects 
		 * Can be called by calling the cancel method. 
		 * In the Cancel effect the property is called cancelAncestorEffects
		 * */
		public var recursiveCancel:Boolean;
		
		/**
		 * The effect is disabled or removed after it has played once
		 * */
		public var removeOncePlayed:Boolean;
		
		/**
		 * Property that holds the error message if an error occurs.
		 * */
		public var errorMessage:String;
		
		
		private var _validate:Boolean = true;
		
		private static var seperator:String = " > ";
		
		/**
		 * When set to true enters the debugger right before
		 * the play method is called. 
		 * */
		public var stepInto:Boolean;
		
		/**
		 * Hook to handle errors
		 * */
		public static var errorFunction:Function;
		
		/**
		 * Hook to handle trace messages
		 * */
		public static var traceFunction:Function;
		
		/**
		 * Last duration value. Used when calling WaitForHandlers. 
		 * */
		public var lastDuration:Number;
		
		/**
		 * Timeout used when duration is 0 or -1 (recheck)
		 * */
		private var delayTimeout:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		

		
		/**
		 * Enables runtime validation on the effect. 
		 * Disable this to skip runtime validation. This may provide a small performance increase.
		 * Enabled by default. 
		 * */
		public function get validate():Boolean
		{
			return _validate;
		}

		/**
		 * @private
		 * */
		public function set validate(value:Boolean):void
		{
			_validate = value;
		}

		/**
		 * @copy ActionEffectInstance
		 * */
		override public function play():void {
			// Dispatch an effectStart event from the target.
			super.play();
			
			// UPDATE: this can and should all be refactored...
			
			// if we listen for an event then we don't want to end the effect right away
			if (eventName && target is IEventDispatcher) {
				eventSource = IEventDispatcher(target);
				eventSource.addEventListener(eventName, eventHandler);
				
				if (timeout>0) {
					tween = createTween(this, 0, 0, timeout);
				}
			}
			else {
				// TODO
				// I'd like to remove this but it would require effect authors
				// to call finish at the end of the play method if duration is 0
				// Update: Calling finish is required
				
				// DO THIS!
				// wait for classes that override play to run
				// before creating a tween or ending the effect
				// we do this because... 
				delayTimeout = setTimeout(delayEffectEnd, 1);
				
				
				// ...after the tween ends the finishEffect is automatically called
				// by the tween that is created
				/*if (duration > 0) {
					tween = createTween(this, 0, 0, duration);
				}
				else if (duration==0) {
					finish();
				}*/
			}
			
			// keep track of time instance starts (from call to play)
			// there may be an time duration variable that already does this 
			// -- learned about it after the fact
			//if (effect is ActionEffect && ActionEffect(effect).profile) {
			if (ActionEffect(effect).profile || ActionEffect(effect).profileToConsole) {
				//ActionEffect(effect).startTime = getTimer();
				PerformanceMeter.start(effect.className);// may use className in the future
			}
			
			// Attention Developer: Press step into a few times
			if (stepInto) {
				traceMessage("\nStepping into " + effect.className + " > Press step into");
				enterDebugger();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Created to ensure the effect end is called after code in the 
		 * play method in subclasses has been run
		 * */
		protected function delayEffectEnd():void {
			
			clearTimeout(delayTimeout);
			
			// set duration to -1 or call waitForHandler() in your play method 
			// to prevent the effect from ending. 
			
			// after the tween ends the finishEffect is automatically called
			// by the tween that is created
			if (duration > 0) {
				tween = createTween(this, 0, 0, duration);
			}
			else if (duration==0) {
				finish();
			}
			
			// we may be able to call finishRepeat here if duration is 0 or less than 0
			
		}
		
		
		/**
		 * This function is called by the target if the named event
		 * is dispatched before the duration expires.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function eventHandler(event:Event):void {
			if (duration >= 0) {
				// Non-negative duration means we must have started
				// a tween; let it end normally
				// NOTE!!! should this be finishEffect?????
				end();
			}
			
			// We didn't start a tween, so finish the effect manually
			if (eventSource)
				eventSource.removeEventListener(eventName, eventHandler);
			finishRepeat();
		}
		
		/**
		 * Override this function so that we can remove the listener for the
		 * event named in the <code>eventName</code> attribute, if it exists
		 * 
		 * @private
		 */
		override public function onTweenEnd(value:Object):void  {
			if (eventSource)
				eventSource.removeEventListener(eventName, eventHandler);
			super.onTweenEnd(value);
		}
		
		/**
		 * Cancels the effect and calls stop. No further effects in the sequence after this effect 
		 * are called.
		 */
		public function cancel(message:String=""):void {
			cancelAll(false, message);
		}
		
		private function cancelAll(fromTimeout:Boolean = false, message:String=""):void {
			var parentInstance:EffectInstance;
			
			/////////////////////////////////////////////
			// timeout code
			/////////////////////////////////////////////
			if (fromTimeout) {
				if (hasEventListener(EffectEvent.EFFECT_TIMEOUT)) {
					dispatchEvent(new EffectEvent(EffectEvent.EFFECT_TIMEOUT, false, false, this, message));
				}
				
				if (target && (target is IEventDispatcher) && IEventDispatcher(target).hasEventListener(EffectEvent.EFFECT_TIMEOUT)) {
					target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_TIMEOUT, false, false, this, message));
				}
				
				if (timeoutEffect) { 
					playEffect(timeoutEffect);
				}
			}
			
			
			/////////////////////////////////////////////
			// cancel code
			/////////////////////////////////////////////
			
			// Dispatch CANCEL event in case listeners need to handle this situation
			// The Effect class may hinge setting final state values on whether
			// the effect was stopped or ended.
			else {
				if (hasEventListener(EffectEvent.EFFECT_CANCEL)) {
					dispatchEvent(new EffectEvent(EffectEvent.EFFECT_CANCEL, false, false, this));
				}
				
				if (target && (target is IEventDispatcher) && IEventDispatcher(target).hasEventListener(EffectEvent.EFFECT_CANCEL)) {
					target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_CANCEL, false, false, this));
				}
				
				if (cancelEffect) {
					playEffect(cancelEffect);
				}
			}
			
			
			// if part of a composite effect end it from there
			if (parentEffectInstance) {
				parentEffectInstance.stop();
				parentEffectInstance.end();
				
				/** 
				 * For this to work the effect needs to be called like this
				 * May not be safe or recommended
				if (action.invalidEffect) {
					var instance:IEffectInstance = action.invalidEffect.createInstance();
					instance.mx_internal::parentCompositeEffectInstance = parentEffectInstance;
					instance.startEffect();
					//playEffect(action.invalidEffect);
				}
				 * */
				if (recursiveCancel) {
					parentInstance = parentEffectInstance.parentCompositeEffectInstance;
					
					while (parentInstance) {
						parentInstance.stop();
						parentInstance.end();
						parentInstance = parentInstance.parentCompositeEffectInstance;
					}
				}
				
				return;
			}
			else {
				// this should be all we need if not part of a composite effect
				//super.stop();
				super.end();
				return;
			}
			
			
			
			// NEED to check the above
			// the above methods call stop and I believe that calls end()
			// looks like we end here
			
			
			
			
			/////////////////////////////////////////////
			// code from effectInstance.stop()
			/////////////////////////////////////////////
			/*if (mx_internal::delayTimer)
				mx_internal::delayTimer.reset();
			mx_internal::stopRepeat = true;
			
			// Dispatch STOP event in case listeners need to handle this situation
			// The Effect class may hinge setting final state values on whether
			// the effect was stopped or ended.
			if (hasEventListener(EffectEvent.EFFECT_STOP))
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_STOP, false, false, this));
			
			if (target && (target is IEventDispatcher) && IEventDispatcher(target).hasEventListener(EffectEvent.EFFECT_STOP))
				target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_STOP, false, false, this));
			
			
			/////////////////////////////////////////////
			// code from effectInstance.finishEffect()
			/////////////////////////////////////////////
			playCount = 0;
			
			if (hasEventListener(EffectEvent.EFFECT_END))
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END, false, false, this));
			
			if (target && (target is IEventDispatcher) && IEventDispatcher(target).hasEventListener(EffectEvent.EFFECT_END))
				target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END, false, false, this));
			
			if (target is UIComponent) {
				UIComponent(target).effectFinished(this);
			}
			
			EffectManager.mx_internal::effectFinished(this);
			
			
			/////////////////////////////////////////////
			// code from tweenEffectInstance.stop();
			/////////////////////////////////////////////
			if (tween)
				tween.stop();*/
			
		}
		
		/**
		 * Call this to wait for internal handlers before continuing. 
		 * It set's duration to -1. This is how the Spark Pause effect works. 
		 * If this effect is in a sequence you must call finish() in your handler
		 * to move to the next effect or call cancel() to prevent the next effect
		 * from playing and cancel out of a parent sequence.
		 * Note: Remember to remove the listeners in the event handlers.
		 * */
		public function waitForHandlers():void {
			if (duration!=-1) {
				lastDuration = duration;
			}
			duration = -1;
		}
		
		/**
		 * Call this to restore previous duration 
		 * */
		public function restorePreviousDuration():void {
			if (lastDuration!=-1) {
				duration = lastDuration;
			}
		}
		
		/**
		 * Call this to proceed to the next effect if duration is 0 or less
		 * otherwise the next effect in the sequence (if part of one) will not play
		 * This also updates the profile information
		 * */
		public function finish():void {
			clearTimeout(delayTimeout);
			
			updateProfileBindings();
			
			finishRepeat();
		}
		
		
		/**
		 * Gets a reference to the previous effect or null if no effect is before 
		 * this.
		 * */
		public function getPreviousEffect():IEffect {
			var index:int = getEffectIndex(effect);
			var effect:IEffect = getEffectByIndex(index-1);
			
			return effect;
		}
		
		/**
		 * Gets a reference to the next effect or null if it is the last effect
		 * */
		public function getNextEffect():IEffect
		{
			var index:int = getEffectIndex(effect);
			var effect:IEffect = getEffectByIndex(index+1);
			
			return effect;
		}
		
		/**
		 * Gets a reference to the next effect or null if it is the last effect
		 * */
		public function getEffectByIndex(index:int, targetParentEffect:IEffect = null):IEffect
		{
			var length:int;
			var compositeEffect:CompositeEffect;
			
			if (targetParentEffect!=null && targetParentEffect is CompositeEffect) {
				compositeEffect = targetParentEffect as CompositeEffect;
			}
			else {
				compositeEffect = parentEffect as CompositeEffect;
			}
			
			length = compositeEffect && compositeEffect.children ? compositeEffect.children.length:0;
			
			if (index<length&&length>0) {
				return compositeEffect.children[index];
			}
			
			return null;
		}
		
		/**
		 * Returns the number of effects in the parent effect
		 * If the parent effect is null then returns 0. 
		 * */
		public function getParentEffectCount():int {
			return parentEffect && parentEffect is CompositeEffect && CompositeEffect(parentEffect).children ? CompositeEffect(parentEffect).children.length:0;
		}
		
		/**
		 * Gets the index of the effect
		 * */
		public function getEffectIndex(effect:IEffect):int {
			if (parentEffect is CompositeEffect) {
				return CompositeEffect(parentEffect).children.indexOf(effect); // children can be null?
			}
			else {
				return -1;
			}
		}
		
		/**
		 * Gets a reference to the parent effect or null if it does not exist
		 * */
		public function get parentEffect():IEffect {
			if (parentEffectInstance) {
				return parentEffectInstance.effect;
			}
			return null;
		}
		
		/**
		 * Gets a reference to the parent effect instance or null
		 * Wrapper around mx_internal::parentCompositeEffectInstance
		 * */
		public function get parentEffectInstance():EffectInstance {
			return mx_internal::parentCompositeEffectInstance;
		}
		
		/**
		 * Indicates if this effect has a parent composite effect 
		 * */
		public function isPartOfSequence():Boolean {
			return mx_internal::parentCompositeEffectInstance!=null && mx_internal::parentCompositeEffectInstance is Sequence;
		}
		
		/**
		 * Updates profile data and dispatch bindings
		 * */
		protected function updateProfileBindings():void {
			var action:ActionEffect = effect as ActionEffect;
			
			// keep track of time instance starts
			if (action && 
				(action.profile || action.profileToConsole)) {
				var length:uint = PerformanceMeter.stop(action.className);
				action.profileData = []; // trigger data binding
				
				// temporary method to get execution duration of an instance
				if (action.profileToConsole) {
					//traceMessage(" ran in \t" + length + "ms");
				}
			}
			
		}
		
		/**
		 * Utility method to dispatch an event on the effect not on the instance. 
		 * */
		public function dispatchActionEvent(event:Event):void {
			effect.dispatchEvent(event);
		}
		
		
		/**
		 * Attempts to play the effect and sets the parent composite effect so cancel ancestors effect works
		 * Note: Does not take into account if the effect is already playing...
		 * */
		public function playEffect(effectToStart:IEffect, targets:Array=null, playReversedFromEnd:Boolean=false):Array {
			var instance:IEffectInstance;
			
			/*var instance:IEffectInstance = action.invalidEffect.createInstance();
			instance.mx_internal::parentCompositeEffectInstance = parentEffectInstance;
			instance.startEffect();*/
			
			// this may need refactoring
			// in fact it might better to use composite effects instead of this
			if (effectToStart) {
				
				waitForHandlers();
				
				effectToStart.addEventListener(EffectEvent.EFFECT_END, playEffectEndHandler, false, 0, true);
				
				instance = effectToStart.createInstance(targets);
				
				if (instance) {
					// note: no support of play reversed
					Object(instance).mx_internal::parentCompositeEffectInstance = parentEffectInstance;
					instance.startEffect();
					return [instance];
				}
				else {
					return effectToStart.play(targets, playReversedFromEnd);
				}
				//effectToStart.play(targets, playReversedFromEnd);
				//return null;
			}
			
			return null;
		}
		
		/**
		 * Handle playEffect end
		 * */
		public function playEffectEndHandler(event:Event):void {
			var parentSequenceEffect:Object = parentCompositeEffectInstance as SequenceInstance;
			
			IEffect(event.currentTarget).removeEventListener(EffectEvent.EFFECT_END, playEffectEndHandler);
			restorePreviousDuration();
			
			finish();
			
			
		}
		
		/**
		 * Get the index of this effect in a parent composite effect.
		 * If not part of a parent composite effect then value is -1.
		 * */
		public function get index():int {
			return getEffectIndex(effect);
		}

		
		/**
		 * Dispatches an Error event. 
		 * 
		 * If this effect is part of a sequence it prints out a list of effects leading up this one. 
		 * */
		protected function dispatchErrorEvent(message:String):void {
			var previousEffect:IEffect;
			var index:int;
			var previousEffectName:String;
			var info:String;

			
			if (errorFunction!=null) {
				errorFunction.apply(this, [message]);
			}
			else {
				previousEffect = getPreviousEffect();
				index = previousEffect ? getEffectIndex(previousEffect): getEffectIndex(effect);
				index = index==-1 ? 0:index;
				previousEffectName = previousEffect ? "[" + index + "] " + previousEffect.className + seperator +  "[" + int(index+1) + "] " : "[" + index + "] ";
				info = previousEffectName + effect.className + seperator + message;
				cancel(info);
				throw new Error(info);
			}
			
		}
		
		
		/**
		 * Traces to console. Override traceFunction to handle trace messages. 
		 * */
		public function traceMessage(message:String):void {
			
			if (traceFunction!=null) {
				traceFunction.apply(effect, [message]);
			}
			else {
				trace(effect.className + ": " + message);
			}
			
		}
	}
}