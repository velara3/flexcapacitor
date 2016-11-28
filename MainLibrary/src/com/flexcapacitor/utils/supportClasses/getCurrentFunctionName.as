package com.flexcapacitor.utils.supportClasses
{
	
	/**
	 * Gets the current function name you are in
	 * */
	public function getCurrentFunctionName():String {
		var object:Object = getCurrentLocation(2);
		var functionName:String = object ? object.functionName: null;
		
		return functionName;
	}
}