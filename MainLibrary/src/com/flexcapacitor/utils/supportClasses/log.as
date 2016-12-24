package com.flexcapacitor.utils.supportClasses
{
	
	/**
	 * Logs a message to the console and includes the class name, function name and line number if available.
	 * 
	 * Use the LogSettings class to set options.    
	 * */
	public function log(...args):void {
		const LINEBREAK:String = "\n";
		var braces:String = "():";
		var defaultOffset:int = LogSettings.lastLogFunction==logTarget ? 4 : 2;
		var object:Object = getCurrentLocation(defaultOffset);
		var className:String = object.className;
		var functionName:String = object.functionName;
		var lineNumber:String = object.lineNumber;
		var out:String = "";
		var sameClass:Boolean;
		var sameFunction:Boolean;
		var sameMessage:Boolean;
		var stringSpace:String = "";
		var message:String;
		
		if (className==LogSettings.lastClassName) {
			sameClass = true;
			//for (var i:int;i<className.length;i++) stringSpace += " ";
		}
		
		if (functionName==LogSettings.lastFunctionName) {
			sameFunction = true;
		}
		
		if (!sameClass && LogSettings.showClassName) {
			out = className ? className : "";
		}
		
		if (!sameFunction && LogSettings.showFunctionName) {
			if (functionName && sameClass) {
				out += stringSpace + "." + functionName;
			}
			else {
				out += "." + functionName;
			}
			
			out += braces;
		}
		
		
		if (lineNumber && LogSettings.showLineNumber) {
			if (sameFunction) {
				out = " Line " + lineNumber + ":" + out + LINEBREAK;
			}
			else {
				out += lineNumber + LINEBREAK;
			}
		}
		else {
			if (out!="" && args.length) {
				out += LINEBREAK;
			}
		}
		
		if (args) {
			if (args.length) {
				args = [out].concat(args);
			}
			else {
				args = [out];
			}
		}
		
		message = args.join("\n");
		
		if (message==LogSettings.lastMessage) {
			sameMessage = true;
		}
		
		if (sameClass && sameFunction && sameMessage) {
			LogSettings.messageShownCount++;
		}
		else {
			LogSettings.messageShownCount = 1;
			LogSettings.maxMessageShown = false;
		}
		
		if (LogSettings.messageShownCount>=LogSettings.maxMessageRepeat) {
			if (!LogSettings.maxMessageShown) {
				args = args.concat(["."+functionName+"(...repeated more than " +LogSettings.maxMessageRepeat+"x)"]);
				LogSettings.maxMessageShown = true;
			}
			else {
				return;
			}
		}
		
		LogSettings.lastClassName = className;
		LogSettings.lastFunctionName = functionName;
		LogSettings.lastMessage = message;

		trace.apply(this, args);
	}
}