
package com.flexcapacitor.utils.supportClasses {
	
	/**
	 * Used to store previous value of group property when adding drag listeners
	 * */
	public class GroupOptions {
		
		public function GroupOptions(mouseEnabled:Object):void {
			mouseEnabledWhereTransparent = mouseEnabled;
		}
		
		public var mouseEnabledWhereTransparent:Boolean;
		
	}
}