

package com.flexcapacitor.effects.gestures {
	
	import com.flexcapacitor.effects.gestures.supportClasses.SwipeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.events.Event;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Event dispatched on swipe left
	 * */
	[Event(name="swipeLeft", type="flash.events.Event")]
	
	/**
	 * Event dispatched on swipe right
	 * */
	[Event(name="swipeRight", type="flash.events.Event")]
	
	/**
	 * Event dispatched on swipe up
	 * */
	[Event(name="swipeUp", type="flash.events.Event")]
	
	/**
	 * Event dispatched on swipe down
	 * */
	[Event(name="swipeDown", type="flash.events.Event")]
	
	/**
	 * Plays the left, right, up or down effect based on swipe gesture values
	 * Note that swipe events can dispatch at the beginning of a swipe, during a swipe and at the end of a swipe. 
	 * Choose the option(s) you desire in the gesturePhase property.
	 * */
	public class Swipe extends ActionEffect {
		
		public static const SWIPE_LEFT:String = "swipeLeft";
		public static const SWIPE_RIGHT:String = "swipeRight";
		public static const SWIPE_UP:String = "swipeUp";
		public static const SWIPE_DOWN:String = "swipeDown";
		
		/**
		 *  Constructor.
		 * */
		public function Swipe(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SwipeInstance;
		}
		
		/**
		 * Effect to play when swyping left
		 * */
		public var swipeLeftEffect:IEffect;
		
		/**
		 * Effect to play when swyping right
		 * */
		public var swipeRightEffect:IEffect;
		
		/**
		 * Effect to play when swyping up
		 * */
		public var swipeUpEffect:IEffect;
		
		/**
		 * Effect to play when swyping down
		 * */
		public var swipeDownEffect:IEffect;
		
		/**
		 * Gesture state to run on.
		 * Options include begin,update,end,all
		 * */
		[Inspectable(enumeration="begin,update,end,all")]
		public var gesturePhase:String = "end";
	}
}