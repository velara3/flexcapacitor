package com.flexcapacitor.utils.supportClasses
{
	
	/**
	 * Returns the current class name you are in. If you are in a global method 
	 * then returns null. 
	 * */
	public function getCurrentClassName():String {
		var object:Object = getCurrentLocation(2);
		var className:String = object ? object.className: null;
		
		return className;
	}
	
}