package com.flexcapacitor.controls.supportClasses
{
	/**
	 * Used when creating a command in AceEditor
Example: 
<pre>
editor.addCommand({
	name: 'find',
	bindKey: {win: "Ctrl-F", "mac": "Cmd-F"},
	exec: findKeyboardHandler});
</pre>
	 * 
	 **/
	public class AceCommand {
		
		public function AceCommand(name:String = null, bindKey:Object = null, exec:Function = null) {
			this.name = name;
			this.bindKey = bindKey;
			this.exec = exec;
		}
		
		/**
		 * Name of command. 
		 * */
		public var name:String;
		
		/**
		 * Keyboard commands to listen for.
		 * Example,  
		 * {win: "Ctrl-F", "mac": "Cmd-F"}
		 * */
		public var bindKey:Object;
		
		/**
		 * Function to execute when command is called
		 * */
		public var exec:Function;
		
		/**
		 * Function name used to when working in the browser. You do not set this. 
		 * */
		public var execName:String;
	}
}