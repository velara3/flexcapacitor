

package com.flexcapacitor.effects.gestures.supportClasses {
	import com.flexcapacitor.effects.gestures.Swipe;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	
	
	/**
	 *  @copy Swipe
	 * */  
	public class SwipeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SwipeInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:Swipe = Swipe(effect);
			var gestureEvent:TransformGestureEvent = triggerEvent as TransformGestureEvent;
			var offsetX:int = gestureEvent ? gestureEvent.offsetX :0;
			var offsetY:int = gestureEvent ? gestureEvent.offsetY :0;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (!gestureEvent) {
					dispatchErrorEvent("The trigger event cannot be null. This can only be called during a swipe gesture event flow.");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			if (gestureEvent.offsetX==-1) {
				if (action.hasEventListener(Swipe.SWIPE_LEFT)) {
					dispatchActionEvent(new Event(Swipe.SWIPE_LEFT));
				}
				if (action.swipeLeftEffect) {
					playEffect(action.swipeLeftEffect);
				}
			}
			else if (gestureEvent.offsetX==1) {
				if (action.hasEventListener(Swipe.SWIPE_RIGHT)) {
					dispatchActionEvent(new Event(Swipe.SWIPE_RIGHT));
				}
				if (action.swipeRightEffect) {
					playEffect(action.swipeRightEffect);
				}
			}
			
			
			// VERTICAL SWIPE
			if (gestureEvent.offsetY==-1) {
				if (action.hasEventListener(Swipe.SWIPE_UP)) {
					dispatchActionEvent(new Event(Swipe.SWIPE_UP));
				}
				if (action.swipeUpEffect) {
					playEffect(action.swipeUpEffect);
				}
			}
			
			else if (gestureEvent.offsetY==1) {
				if (action.hasEventListener(Swipe.SWIPE_DOWN)) {
					dispatchActionEvent(new Event(Swipe.SWIPE_DOWN));
				}
				if (action.swipeDownEffect) {
					playEffect(action.swipeDownEffect);
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