package com.flexcapacitor.utils.supportClasses
{
	
	/**
	 * Returns an object containing the name of the current class, 
	 * function, line number, document, and file path to the document. 
	 * 
	 * If running in the release version
	 * this method does not return the file path, the document or the line number. 
	 * */
	public function getCurrentLocation(offset:int = 1):Object {
		var stack:Array = getStackArray(1, offset);
		var object:Object = stack && stack.length ? stack[0] : null;
		
		return object;
	}
	
}