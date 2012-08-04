



package com.flexcapacitor.handlers {
	
	import flash.events.IEventDispatcher;
	
	
	/**
	 * Adds an keyboard event listener on the target for the specified event.
	 * To Use: &lt;KeyboardEventHandler keyCode="{Keyboard.MENU}" target="{this}" actions="{sequence}"/>
	 * */
	public class KeyboardEventHandler extends EventHandler {
		
		
		public function KeyboardEventHandler(target:IEventDispatcher=null) {
			super(target);
		}
		
	}
}