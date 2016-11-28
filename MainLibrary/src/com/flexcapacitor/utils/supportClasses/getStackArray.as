package com.flexcapacitor.utils.supportClasses
{
	
	/**
	 * Returns an array of objects containing the name of the current class, 
	 * function, line number, document, and file path to the document. 
	 * 
	 * If running in the release version
	 * this method does not return the file path, the document or the line number.   
	 * */
	public function getStackArray(results:int = 0, offset:int = 0):Array {
		var error:Error = new Error();
		var value:String;
		var stackTrace:Array;
		var object:Object;
		var className:String;
		var functionName:String;
		var fileLocation:String;
		var lineNumber:String;
		var message:String;
		var components:Object;
		var matchPattern:RegExp;
		var path:String;
		var stack:Array;
		var locations:Array;
		
		matchPattern = /^at\s(.+?)\(\)\[(.*?):(.*)]/;
		
		if ("getStackTrace" in error) {
			value = error.getStackTrace();
			value = value.replace(/\t/g, "");
			//value = value.replace(/\[.*\]/g, "");
			//value = value.replace(/.*?::/g, "");
			stackTrace = value.split("\n");
			stackTrace.shift();// removes Error at
			stackTrace.shift(); // removes this function
			
			for (; offset >0 && stackTrace.length; offset--) {
				stackTrace.shift();
			}
			
			stack = [];
			
			for (var i:int = 0; i < stackTrace.length; i++) {
				object = {};
				message = stackTrace[i];
				components = message.match(matchPattern);
				
				// matches 
				// "at TransformTests/drawLayer_clickHandler()[/Documents/Project/src/TransformTests.mxml:244]"
				if (components) {
					locations = components[1].split(/[\\|\/]/);
					
					// class and method
					if (locations.length>1) {
						path = locations[0];
						object.className = path && path.indexOf("::")!=-1 ? path.split("::").pop() : path;
						object.functionName = locations[1];
					}
						// global method - has no class
					else if (locations.length) {
						object.functionName = locations[0];
					}
					
					path = components[2];
					
					object.location = path;
					object.document = path ? path.split(/[\\|\/]/).pop() : null;
					object.lineNumber = components[3];
					stack.push(object);
				}
				else {
					// matches "at Transform/drawLayer_clickHandler()" or "at drawLayer_clickHandler()"
					components = message.match(/^at\s(.*)\(\)/);
					
					// runtime has no file path or line number
					if (components) {
						path = components[1];
						locations = path.split(/[\\|\/]/);
						
						// class and method
						if (locations.length>1) {
							path = locations[0];
							object.className = path && path.indexOf("::")!=-1 ? path.split("::").pop() : path;
							object.functionName = locations[1];
						}
							// global method - no class
						else if (locations.length) {
							object.functionName = locations[0];
						}
						
						stack.push(object);
					}
					
				}
				
				if (results==i+1) {
					break;
				}
			}
			
			return stack;
		}
		
		return null;
	}
}