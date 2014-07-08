

package com.flexcapacitor.effects.nativeProcess.supportClasses {
	
	import com.flexcapacitor.effects.nativeProcess.RunProcess;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import mx.managers.SystemManager;
	import mx.utils.StringUtil;

	/**
	 * @copy RunProcess
	 * */  
	public class RunProcessInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function RunProcessInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play(); // dispatch startEffect
			
			var action:RunProcess = RunProcess(effect);
			var applicationDomain:ApplicationDomain;
			var nativeProcessDefinition:String = "flash.desktop.NativeProcessStartupInfo";
			var nativeProcessStartupInfo:NativeProcessStartupInfo;
			var processArgs:Vector.<String> = new Vector.<String>();
			var processFound:Boolean;
			var supported:Boolean;
			var runScriptFile:File;
			var scriptFile:File;
			var executableFile:File;
			var workingDirectory:File;
			var process:NativeProcess;
			var isError:Boolean;
			
			// update for bindings
			action.errorData = null;
			action.outputData = null;
			action.errorDataArray = [];
			action.outputDataArray = [];
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// if we are in the browser we must run our code during a click event
			if (validate) {
				
				// check for required properties
				if (!nativeProcessDefinition) {
					dispatchErrorEvent("The class definition is not defined.");
				}
				
				// From SystemManager: var domain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info()["currentDomain"] as ApplicationDomain;
				//applicationDomain = SystemManager.getSWFRoot(this).loaderInfo.applicationDomain;
				//supported = applicationDomain.hasDefinition(nativeProcessDefinition);
				
				// check if the NativeProcess class is found
				if (!action.ignoreUnsupportedDevices && !NativeProcess.isSupported) {
					dispatchErrorEvent("The Native Process is not supported on this platform. You may need to add extendedDesktop option to your application profile.");
				}
				
				// ArgumentError: Error #2007: Parameter  must be non-null.
				if (!action.executablePath && !action.commands) {
					dispatchErrorEvent("You must provide a path to an executable or commands. Set scriptPath or executablePath.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check if the NativeProcess class is found
			if (!NativeProcess.isSupported) {
				
				if (action.hasEventListener(RunProcess.NOT_SUPPORTED)) {
					dispatchActionEvent(new Event(RunProcess.NOT_SUPPORTED));
				}
				
				if (action.notSupportedEffect) { 
					playEffect(action.notSupportedEffect);
				}
				
				finish();
				return;
			}
			
			
			// Start Native Process
			nativeProcessStartupInfo = new NativeProcessStartupInfo();
			
			// if script is required check file path
			if (action.executablePath) {
				executableFile = File.applicationDirectory.resolvePath(action.executablePath);
				nativeProcessStartupInfo.executable = executableFile;
			}
			else if (action.scriptOrigin) {
				// used to run sh and scpt files
				runScriptFile = File.applicationDirectory.resolvePath(action.scriptOrigin);
				nativeProcessStartupInfo.executable = runScriptFile;
			}
			else if (action.commands) {
				runScriptFile = File.applicationDirectory.resolvePath(action.scriptOrigin);
				nativeProcessStartupInfo.executable = runScriptFile;
			}
			
			// get working directory
			if (action.workingDirectory) {
				workingDirectory = File.applicationDirectory.resolvePath(action.workingDirectory);
				nativeProcessStartupInfo.workingDirectory = workingDirectory;
			}
			else {
				nativeProcessStartupInfo.workingDirectory = File.applicationDirectory;
			}
			
			// get arguments
			var processArguments:Array = action.arguments;
			var length:int = processArguments ? processArguments.length : 0;
			
			// this is not returning a value
			if (action.commands) {
				processArgs.push( "-e" );
				processArgs.push( 'tell application "Terminal" to activate & do script "'+ action.commands +'"'+'\n' );
				processArgs.push( 'end tell' );
			}
			else {
				for (var i:int;i<length;i++) {
					processArgs[i] = processArguments[i];
				}
			}
			
			nativeProcessStartupInfo.arguments = processArgs;
			
			process = new NativeProcess();
				
			// add event listeners
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData, false, 0, true);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData, false, 0, true);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardOutputIOError, false, 0, true);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onStandardOutputIOError, false, 0, true);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit, false, 0, true);
			
			action.process = process;
			
			
			try {
				process.start(nativeProcessStartupInfo);
			}
			catch (error:Error) {
				isError = true;
			}
			
			
			// ArgumentError: Error #3214: NativeProcessStartupInfo.executable does not specify a valid executable file.
			// "usr/bin/osascript" 
			if (isError) {
				if (action.hasEventListener(RunProcess.PROCESS_NOT_FOUND)) {
					dispatchActionEvent(new Event(RunProcess.PROCESS_NOT_FOUND));
				}
				
				if (action.processNotFoundEffect) { 
					playEffect(action.processNotFoundEffect);
				}
				
			}
			else {
				
				if (action.hasEventListener(RunProcess.PROCESS_FOUND)) {
					dispatchActionEvent(new Event(RunProcess.PROCESS_FOUND));
				}
				
				if (action.processFoundEffect) { 
					playEffect(action.processFoundEffect);
				}
			}
		
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		/**
		 * Inspectable bindable pattern RegEx
		 * */
		public var bindingPattern:RegExp = /\${(.*?)}/g;
		
		/**
		 * Formats
		 * */
		public var formats:Array = ["file","folder","color","string","text","number"];
		
		/**
		 * Error parsing arguments
		 * */
		public var parseError:String;
		
		/**
		 * Parses the arguments input 
		 * */
		public function parseInput(value:String):void {
			var rawCommand:String = value;
			var executable:String;
			var arguments:Array;
			
			if (rawCommand) {
				rawCommand = rawCommand.replace(/(^\s+)/g, "");// removes spaces before text
				arguments = getArguments(rawCommand);
				executable = getNameFromArguments(arguments);
			}
		}
		
		/**
		 * Gets the text up to the first white space character or end of the text
		 * */
		public function getName(value:String):String {
			var index:int = value ? value.indexOf(" ") : -1;
			var commandName:String = value.substring(0, index);
			
			return commandName;
		}
		
		/**
		 * Gets first argument that is a string
		 * */
		public function getNameFromArguments(array:Array):String {
			if (array) {
				for (var i:int;i<array.length;i++) {
					if (array[i] is String) {
						return StringUtil.trim(array[i]);
					}
				}
			}
			return null;
		}
			
		/**
		 * Returns an array of text or bindings objects.
		 * If the text is "ditto path -h" the returned array would be
		 * ['ditto','path','-h'];
		 * If the text is "ditto ${"name","test"} -h" the returned array would be 
		 * ['ditto', {name,"test"}, '-h']. 
		 * */
		public function getArguments(value:String):Array {
			var match:Array = value.split(bindingPattern);
			var incrementValue:int = 2;
			var o:Object;
			var string:String;
			var form:Array = [];
			var length:int;
			var index:int;
			
			//match.splice(0,1);
			length = match.length;
			
			for (var i:int;i<length;i++) {
				string = match[i];
				
				if (i%2) {
					index = formats.indexOf(string.toLowerCase());
					
					if (index!=-1) {
						o = {type:formats[index]};
						var s:String = JSON.stringify(o);
						o = JSON.parse(JSON.stringify(o));
						form.push(o);
					}
					else {
						try {
							o = JSON.parse("{"+string+"}");
							
							if (!o.name) {
								parseError = "Name must be specified.";
							}
							else if (!o.type) {
								parseError = "Type must be specified.";
							}
							else {
								parseError = "";
							}
							
							form.push(o);
						}
						catch (e:Error) {
							parseError = e.message;
							form.push(string);
						}
					}
					
				}
				else {
					form.push(string);
				}
			}
			
			
			return form;
			
		}
		
			
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
	
		/**
		 * Event handler of output data 
		 * */
		public function onOutputData(event:ProgressEvent):void {
			var action:RunProcess = RunProcess(effect);
			var process:NativeProcess = action.process as NativeProcess;
			var standardOutput:IDataInput = process.standardOutput as IDataInput;
			
			///////////////////////////////////////////////////////////
			// Continue with effect
			///////////////////////////////////////////////////////////
			
			
			// Error: Error #3212: Cannot perform operation on a NativeProcess that is not running.
			// - error happens when reading the bytes the second time??
			if (process.running && action.acquireOutputBytes && standardOutput.bytesAvailable) {
				action.outputData = process.standardOutput.readUTFBytes(standardOutput.bytesAvailable);
				action.outputDataArray.push(action.outputData);
			}
			
			if (action.hasEventListener(event.type)) {
				dispatchActionEvent(event);
			}
			
			if (action.standardOutputIOErrorEffect) { 
				playEffect(action.standardOutputIOErrorEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			//finish();
		}
		
		/**
		 * Event handler of output data 
		 * */
		public function onErrorData(event:ProgressEvent):void {
			var action:RunProcess = RunProcess(effect);
			var process:NativeProcess = action.process as NativeProcess;
			var standardError:IDataInput = process.standardError;
			
			
			///////////////////////////////////////////////////////////
			// Continue with effect
			///////////////////////////////////////////////////////////
			
			// Error: Error #3212: Cannot perform operation on a NativeProcess that is not running.
			// - error happens when reading the bytes the second time??
			// Answer - 
			// [Read Only] Returns the number of bytes of data available for reading in the input buffer. 
			// User code must call bytesAvailable to ensure that sufficient data is available 
			// before trying to read it with one of the read methods.
			if (process.running && action.acquireErrorBytes && standardError.bytesAvailable) {
				action.errorData = standardError.readUTFBytes(standardError.bytesAvailable);
				action.errorDataArray.push(action.errorData);
			}
			
			if (action.hasEventListener(event.type)) {
				dispatchActionEvent(event);
			}
			
			if (action.standardOutputIOErrorEffect) { 
				playEffect(action.standardOutputIOErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		
		/**
		 * Event handler of output IO error
		 * */
		public function onStandardOutputIOError(event:IOErrorEvent):void {
			var action:RunProcess = RunProcess(effect);
			var process:NativeProcess = action.process as NativeProcess;
			
			
			///////////////////////////////////////////////////////////
			// Continue with effect
			///////////////////////////////////////////////////////////
			if (action.hasEventListener(event.type)) {
				dispatchActionEvent(event);
			}
			
			if (event.type==IOErrorEvent.STANDARD_ERROR_IO_ERROR) {
				
				// Standard Error
				if (action.standardErrorIOErrorEffect) { 
					playEffect(action.standardErrorIOErrorEffect);
				}
			}
			else if (event.type==IOErrorEvent.STANDARD_OUTPUT_IO_ERROR) {
				
				// Standard Output Error
				if (action.standardOutputIOErrorEffect) { 
					playEffect(action.standardOutputIOErrorEffect);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Event handler on native process exit
		 * */
		public function onExit(event:NativeProcessExitEvent):void {
			var action:RunProcess = RunProcess(effect);
			var process:NativeProcess = action.process as NativeProcess;
			
			
			///////////////////////////////////////////////////////////
			// Continue with effect
			///////////////////////////////////////////////////////////
			
			//trace("Process exited with ", event.exitCode);
			action.exitCode = event.exitCode;
			
			if (action.hasEventListener(NativeProcessExitEvent.EXIT)) {
				dispatchActionEvent(event);
			}
			
			if (action.exitEffect) { 
				playEffect(action.exitEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
	}
	
	
}