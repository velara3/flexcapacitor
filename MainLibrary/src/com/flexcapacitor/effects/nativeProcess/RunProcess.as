

package com.flexcapacitor.effects.nativeProcess {
	
	import com.flexcapacitor.effects.nativeProcess.supportClasses.RunProcessInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when native process is not supported.
	 * */
	[Event(name="notSupported", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the process specified is found.
	 * */
	[Event(name="processFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the process specified is not found.
	 * */
	[Event(name="processNotFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when standard output data is received. ProgressEvent.STANDARD_OUTPUT_DATA
	 * */
	[Event(name="standardOutputData", type="flash.events.ProgressEvent")]
	
	/**
	 * Event dispatched when standard error data is received. ProgressEvent.STANDARD_ERROR_DATA
	 * */
	[Event(name="standardErrorData", type="flash.events.ProgressEvent")]
	
	/**
	 * Event dispatched when standard output io error is dispatched. IOErrorEvent.STANDARD_OUTPUT_IO_ERROR
	 * */
	[Event(name="standardOutputIOError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Event dispatched when standard error data is received. IOErrorEvent.STANDARD_ERROR_IO_ERROR
	 * */
	[Event(name="standardErrorIOError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Event dispatched when native process is exited.
	 * */
	[Event(name="exit", type="flash.events.NativeProcessExitEvent")]
	
	/**
	 * Runs a process on the system. Runs on desktop with extendedDesktop profile.<br/><br/>
	 * 
	 * COMMON COMMANDS<br/>
	 * OSAScript - used for running applescript scpt scripts on Mac. Path is /usr/bin/osascript.<br/>
	 * Ditto - used to copy files to another directory. Path is /usr/bin/ditto. <br/><br/>
	 * 
	 * ERROR<br/>
	 * Error: Error #3219: The NativeProcess could not be started. 'Not supported in current profile.'<br/>
	 * 
	 * SOLUTION<br/>
	 * Add 	<supportedProfiles>extendedDesktop desktop</supportedProfiles> to the application descriptor file<br/><br/>
	 * 
	 * ERROR<br/>
	 * ArgumentError: Error #3214: NativeProcessStartupInfo.executable does not specify a valid executable file.<br/><br/>
	 * 
	 * SOLUTION<br/>
	 * Path to executable incorrect. Script executable, "usr/bin/osascript"<br/>
	 * */
	public class RunProcess extends ActionEffect {
		
		/**
		 * Event name constant when a process is found.
		 * */
		public static const PROCESS_FOUND:String = "processFound";
		
		/**
		 * Event name constant when a process is NOT found.
		 * */
		public static const PROCESS_NOT_FOUND:String = "processNotFound";
		
		/**
		 * Event name constant when run process is not supported.
		 * */
		public static const NOT_SUPPORTED:String = "notSupported";
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function RunProcess(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = RunProcessInstance;
			
		}
		
		/**
		 * Path to command that runs scripts on Mac. 
		 * Need to update path to support other OS. 
		 * */
		public var scriptOrigin:String = "/usr/bin/osascript";
		
		/**
		 * Path to executable. The executable must be on the path 
		 * */
		public var executablePath:String;
		
		/**
		 * Array of arguments to pass to the executable. 
		 * */
		[Bindable]
		public var arguments:Array = [];
		
		/**
		 * Working directory. If not set then the File.applicationDirectory path is used.
		 * */
		public var workingDirectory:String;
		
		/**
		 * Reference to the native process of type NativeProcess. You do not set this. 
		 * It is created when the effect is run.
		 * */
		[Bindable]
		public var process:Object;
		
		/**
		 * Commands to send to the command line
		 * */
		[Bindable]
		public var commands:String;
		
		/**
		 * By default a runtime error is thrown if Native Process is not supported on the device. 
		 * Set this to true to ignore that error. 
		 * */
		public var ignoreUnsupportedDevices:Boolean;
		
		/**
		 * Output data.
		 * */
		[Bindable]
		public var outputData:String;
		
		/**
		 * Output data array. 
		 * */
		[Bindable]
		public var outputDataArray:Array;
		
		/**
		 * Standard error data
		 * */
		[Bindable]
		public var errorData:String;
		
		/**
		 * Standard error data array
		 * */
		[Bindable]
		public var errorDataArray:Array;
		
		/**
		 * Standard error message
		 * */
		[Bindable]
		public var errorMessage:String;
		
		/**
		 * Exit code
		 * */
		[Bindable]
		public var exitCode:Number;
		
		/**
		 * Effect that is played if defined if process is found.
		 * */
		public var processFoundEffect:Effect;
		
		/**
		 * Effect that is played if defined if process is NOT found.
		 * */
		public var processNotFoundEffect:Effect;
		
		/**
		 * Effect that is played on standard output data.
		 * */
		public var standardOutputDataEffect:Effect;
		
		/**
		 * Effect that is played on standard error data.
		 * */
		public var standardErrorDataEffect:Effect;
		
		/**
		 * Effect that is played on standard output IO error. 
		 * */
		public var standardOutputIOErrorEffect:Effect;
		
		/**
		 * Effect that is played on standard error IO error. 
		 * */
		public var standardErrorIOErrorEffect:Effect;
		
		/**
		 * Effect that is played on native process exit. 
		 * */
		public var exitEffect:Effect;
		
		/**
		 * Effect that is played when run process is not supported. 
		 * */
		public var notSupportedEffect:Effect;
		
		/**
		 * When true accesses the bytes from the error data and places it in the error data property.
		 * If this is set to false you can acquire this information manually, 
		 * 
<pre>
 if (process.standardError.bytesAvailable) {
 	var errorData:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
 }</pre>
		 * 
		 * @see standardErrorData
		 * */
		[Bindable]
		public var acquireErrorBytes:Boolean = true;
		
		/**
		 * When true accesses the bytes from the output data and places it in the output data property. 
		 * If this is set to false you must acquire it manually. 
		 * 
<pre>
 if (process.standardOutput.bytesAvailable) {
 	var errorData:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
 }</pre>
		 * @see standardOutputData
		 * */
		[Bindable]
		public var acquireOutputBytes:Boolean = true;
	}
}