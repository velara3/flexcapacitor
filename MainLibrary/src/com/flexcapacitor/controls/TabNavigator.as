package com.flexcapacitor.controls
{
	import flash.events.KeyboardEvent;
	
	import mx.containers.TabNavigator;
	
	/**
	 * Extends mx TabNavigator but fixes the null focusManager bug; 
	 * 
	 * TypeError: Error #1009: Cannot access a property or method of a null object reference.
	 * 	at mx.containers::TabNavigator/keyDownHandler()[E:\dev\4.y\frameworks\projects\mx\src\mx\containers\TabNavigator.as:895]
	 * */
	public class TabNavigator extends mx.containers.TabNavigator
	{
		public function TabNavigator()
		{
			super();
		}
		
		
		/**
		 *  @private
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (focusManager && focusManager.getFocus() == this)
			{
				// Redispatch the event from the TabBar so that it can handle it.
				tabBar.dispatchEvent(event);
			}
		}
	}
}