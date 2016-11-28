package com.flexcapacitor.utils.supportClasses
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.NameUtil;
	
	/**
	 * Logs a message to the console and includes the class name, function name and line number if available.
	 * 
	 * Use the LogSettings class to set options.    
	 * */
	public function logTarget(target:Object, ...args):void {
		var targetName:String;
		var out:String;
		
		if (LogSettings.showQualifiedClassNames) {
			targetName = getQualifiedClassName(target);
		}
		else {
			targetName = NameUtil.getUnqualifiedClassName(target);
		}
		
		out = " Target: " + targetName;
		
		if (args) {
			if (args.length) {
				args = [out].concat(args);
			}
			else {
				args = [out];
			}
		}
		
		LogSettings.lastLogFunction = logTarget;
		
		log.apply(this, args);
		
		LogSettings.lastLogFunction = null;
	}
}