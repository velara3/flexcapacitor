



package com.flexcapacitor.handlers {
	
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.GesturePhase;
	import flash.events.IEventDispatcher;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TransformGestureEvent;
	
	
	
	/**
	 * Adds an gesture event listener on the target.
	 * Remember to set the target and the eventName, usually "gesture" plus event name, and additional 
	 * gesture properties such as swipeDirection and gesturePhase (optional for some gestures). <br/><br/>
	 * 
	 * A list of gestures available:<br/><br/>
	 * 
	 * TransformGestureEvent.GESTURE_PAN<br/>
	 * TransformGestureEvent.GESTURE_ROTATE<br/>
	 * TransformGestureEvent.GESTURE_SWIPE<br/>
	 * TransformGestureEvent.GESTURE_ZOOM<br/>
	 * GestureEvent.GESTURE_TWO_FINGER_TAP<br/>
	 * PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP<br/><br/>
	 * 
	 * GesturePhase.All<br/>
	 * GesturePhase.BEGIN<br/>
	 * GesturePhase.UPDATE<br/>
	 * GesturePhase.END<br/><br/>
	 * 
	 * By default the gesture phase is null which means all phases are dispatched.<br/><br/>
	 * 
	 * Note: You can set the stopPropagation or stopImmediatePropagation property to true 
	 * to prevent non desired events from propagating further. For example, a non desired event 
	 * would be swipe event where the swipe is in the right direction and in your application 
	 * you are only concerned with listening for swipes in the left direction.<br/><br/>
	 * Important note: If you enable stopPropagation or stopImmediatePropagation 
	 * other parts of your application may not get the event.<br/><br/>
	 * 
	 * 
	 * To Use: 
	 * 	<pre>
	 * &lt;fc:GestureEventHandler eventName="{TransformGestureEvent.GESTURE_SWIPE}" target="{image}" swipeDirection="left">
	 * 	&lt;fc:Trace message="Swipe Left"/>
	 * &lt;/fc:GestureEventHandler>
	 * </pre>
	 * 	<pre>
	 * &lt;fc:GestureEventHandler id="zoomGestureHandler" eventName="{TransformGestureEvent.GESTURE_ZOOM}" 
	 * 	target="{image}" swipeDirection="left">
	 * 	&lt;s:SetAction target="{image}" property="scaleX" value="{gestureHandler.scaleX}"/>
	 * 	&lt;s:SetAction target="{image}" property="scaleY" value="{gestureHandler.scaleY}"/>
	 * &lt;/fc:GestureEventHandler>
	 * </pre>
	 * */
	public class GestureEventHandler extends EventHandler {
		
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		
		public static const ALL:String = "all";
		public static const BEGIN:String = "begin";
		public static const UPDATE:String = "update";
		public static const END:String = "end";
		
		public function GestureEventHandler(target:IEventDispatcher=null) {
			super(target);
			
		}
		
		/**
		 * @copy TransformGestureEvent.GESTURE_SWIPE
		 * */
		[Inspectable (enumeration="left,right,up,down")]
		public var swipeDirection:String;
		
		/**
		 * By default this is null which means it is not a requirement for the event 
		 * to qualify. Some gestures may dispatch many events for all the different phases.<br/>
		 * 
		 * @copy GesturePhase
		 * */
		[Inspectable (enumeration="all,begin,update,end")]
		public var gesturePhase:String;
		
		/**
		 * 
		 * */
		[Bindable]
		public var rotation:Number;
		
		/**
		 * 
		 * */
		[Bindable]
		public var scaleX:Number = 1;
		
		/**
		 * 
		 * */
		[Bindable]
		public var scaleY:Number = 1;
		
		/**
		 * 
		 * */
		[Bindable]
		public var offsetY:Number;
		
		/**
		 * 
		 * */
		[Bindable]
		public var offsetX:Number;
		
		/**
		 * Current phase
		 * */
		[Bindable]
		public var currentPhase:String;
		
		override public function eventHandler(currentEvent:Event=null):void {
			var transformGestureEvent:TransformGestureEvent = currentEvent as TransformGestureEvent;
			var type:String = currentEvent ? currentEvent.type : null;
			var supportsPhase:Boolean;
			
			currentPhase = currentEvent && currentEvent is GestureEvent ? GestureEvent(currentEvent).phase : currentPhase;
			
			///////////////////////////////////////////////////////////
			// Swipe
			///////////////////////////////////////////////////////////
			
			if (type == TransformGestureEvent.GESTURE_SWIPE) {
				if (currentPhase!=null) supportsPhase = true;
				
				// horizontal swipe
				if (transformGestureEvent.offsetX==-1) {
					
					if (swipeDirection!=LEFT) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				else if (transformGestureEvent.offsetX==1) {
					
					if (swipeDirection!=RIGHT) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				
				
				// vertical swipe
				if (transformGestureEvent.offsetY==-1) {
					
					if (swipeDirection!=UP) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				else if (transformGestureEvent.offsetY==1) {
					
					if (swipeDirection!=DOWN) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
			}
				
				
				///////////////////////////////////////////////////////////
				// PAN
				///////////////////////////////////////////////////////////
				
			else if (type == TransformGestureEvent.GESTURE_PAN) {
				offsetX = transformGestureEvent.offsetX;
				offsetY = transformGestureEvent.offsetY;
				supportsPhase = true;
				
			}
				
				
				///////////////////////////////////////////////////////////
				// ROTATE
				///////////////////////////////////////////////////////////
				
			else if (type == TransformGestureEvent.GESTURE_ROTATE) {
				rotation = transformGestureEvent.rotation;
				supportsPhase = true;
			}
				
				
				///////////////////////////////////////////////////////////
				// ZOOM
				///////////////////////////////////////////////////////////
				
			else if (type == TransformGestureEvent.GESTURE_ZOOM) {
				scaleX = transformGestureEvent.scaleX;
				scaleY = transformGestureEvent.scaleY;
				supportsPhase = true;
			}
				
				
				///////////////////////////////////////////////////////////
				// TWO FINGER TAP
				///////////////////////////////////////////////////////////
				
			else if (type == GestureEvent.GESTURE_TWO_FINGER_TAP) {
				
				
			}
			
			
			///////////////////////////////////////////////////////////
			// PRESS AND TAP
			///////////////////////////////////////////////////////////
				
			else if (type == PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP) {
				
				
			}

			
			// make sure we match the desired phase
			if (supportsPhase && gesturePhase!=null) {
				
				// check what phase we're on to filter out events from phases
				// we're not in
				// not sure why we're not doing currentPhase!=gesturePhase
				if (currentPhase==GesturePhase.ALL) {
					
					// if we're not in the 
					if (gesturePhase!=ALL) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				else if (currentPhase==GesturePhase.BEGIN) {
					
					if (gesturePhase!=BEGIN) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				else if (currentPhase==GesturePhase.UPDATE) {
					
					if (gesturePhase!=UPDATE) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
				else if (currentPhase==GesturePhase.END) {
					
					if (gesturePhase!=END) {
						if (stopPropagation) currentEvent.stopPropagation();
						if (stopImmediatePropagation) currentEvent.stopImmediatePropagation();
						return;
					}
				}
			}
			
			super.eventHandler(currentEvent);
			
		}
		
		
		
		
		
		
	}
}