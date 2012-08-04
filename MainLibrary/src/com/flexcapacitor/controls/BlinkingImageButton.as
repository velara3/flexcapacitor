
package com.flexcapacitor.controls {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.Image;
	
	/**
	 * Blinks or dims the control at a specific interval. 
	 * 
	 * Used to annoy people. Or use it for things like play / pause button or 
	 * switch between alternate states. 
	 * */
	public class BlinkingImageButton extends Image {
		
		/**
		 * Timer used to control the on and off state
		 * */
		private var blinkTimer:Timer;
		
		/**
		 * When true sets the alpha to the dim alpha value instead of setting the visibility.
		 * */
		public var dim:Boolean;
		
		/**
		 * When true enables the blinking effect
		 * */
		public var enableBlink:Boolean = true;
		
		/**
		 * Alpha value to use when in dim state
		 * */
		public var dimAlpha:Number = .5;
		
		/**
		 * Alternate image source if supplied
		 * */
		public var alternateSource:Object;
		
		/**
		 * Original source
		 * */
		public var originalSource:Object;
		
		/**
		 * Constructor
		 * */
		public function BlinkingImageButton():void {            
			blinkTimer = new Timer( interval , 0 );
			blinkTimer.addEventListener( "timer" , toggleControl );
			blinkTimer.start();
		}
		
		/**
		 * Timer handler
		 * */
		public function toggleControl( event:TimerEvent ):void {
			
			if (enableBlink) {
					
				if (dim) {
					if (alpha != dimAlpha) {
						alpha = dimAlpha;
					}
					else {
						alpha = 1;
					}
				}
				else if (alternateSource) {
					if (source!=alternateSource) {
						originalSource = source;
						source = alternateSource;
					}
					else {
						source = originalSource;
					}
				}
				else {
					if (visible) {
						visible = false;
					}
					else {
						visible = true;
					}
				}
			}
			else {
				
				if (dim) {
					alpha = 1;
				}
				else if (alternateSource) {
					source = originalSource;
				}
				else {
					visible = true;
				}
			}
		}
		
		/**
		 * @private
		 * */
		public var _interval:uint = 1000;
		
		/**
		 * Length of time in off and on state
		 * */
		public function get interval():uint {
			return _interval;
		}
		
		/**
		 * @private
		 * */
		public function set interval( value:uint ):void {
			blinkTimer.delay = value;        
		}
	}
}