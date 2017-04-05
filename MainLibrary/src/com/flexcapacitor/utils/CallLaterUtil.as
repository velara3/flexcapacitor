package com.flexcapacitor.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Will call a specific function on the next frame or after a set amount of time. 
	 * */
	public class CallLaterUtil {
		
		public function CallLaterUtil() {
			
		}
		
		private var sprite:Sprite;
		
		/**
		 * Calls a function after a set amount of time. 
		 * */
		public static function callAfter(time:int, method:Function, ...Arguments):void {
			var sprite:Sprite;
			var callTime:int;
			
			if (sprite==null) {
				sprite = new Sprite();
			}
			
			callTime = getTimer() + time;
			
			// todo: find out if this causes memory leaks
			sprite.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				var difference:int = getTimer()-callTime-time;
				if (getTimer()>=callTime) {
					//trace("callAfter: time difference:" + difference);
					sprite.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					method.apply(this, Arguments);
					method = null;
				}
			});
		}
		
		/**
		 * Calls a function after a frame 
		 * */
		public static function callLater(method:Function, ...Arguments):void {
			var sprite:Sprite = new Sprite();
			var startTime:int = getTimer();
			
			// todo: find out if this causes memory leaks
			sprite.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				var difference:int = getTimer()-startTime;
				//trace("callLater: time difference:" + difference);
				sprite.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				method.apply(this, Arguments);
				method = null;
			});
		}
	}
}