

package com.flexcapacitor.effects.nativeProcess {
	
	import com.flexcapacitor.effects.nativeProcess.supportClasses.RunProcessInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	
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
	 * Event dispatched when an error occurs when starting a native process .
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Runs a process on the system. You must set the profile to "extendedDesktop" profile or "extendedMobile". 
	 * Order of tag value matters and "extendedDesktop" or "extendedMobile" must be defined first.<br/><br/>
	 * 
	 * Ensure "extendedDesktop" is defined in the supported profiles tag in the application descriptor file like so:
	 * 
<pre>
&lt;supportedProfiles&gt;extendedDesktop desktop&lt;/supportedProfiles&gt;
</pre>
	 * 
	 * <b>The following example runs a script that starts the screen saver:</b> 
<pre>
&lt;nativeProcess:RunProcess id="runProcess"
	  executablePath="/usr/bin/osascript"
	  arguments="StartScreenSaver.scpt"
	  standardOutputData="trace('StandardOutput:' + runProcess.outputData)"
	  standardErrorData="trace('Error Data:' + runProcess.errorData)"
	  standardErrorIOError="trace('Error IO Error:' + event.toString())"
	  standardOutputIOError="trace('Output IO Error:' + event.toString())"
	  error="runAProcess_errorHandler(event)"
	  exit="trace('Process exited with: ' + event.exitCode)">
	&lt;nativeProcess:notSupportedEffect>
		&lt;status:ShowStatusMessage message="Native process not supported"/>
	&lt;/nativeProcess:notSupportedEffect>
	&lt;nativeProcess:processNotFoundEffect>
		&lt;status:ShowStatusMessage message="Process not found"/>
	&lt;/nativeProcess:processNotFoundEffect>
	&lt;nativeProcess:processFoundEffect>
		&lt;status:ShowStatusMessage message="Process found"/>
	&lt;/nativeProcess:processFoundEffect>
&lt;/nativeProcess:RunProcess>
</pre>
 * 
 * StartScreenSaver.scpt (create the file and include it in your Application directory): 
<pre>
tell application "System Events" 
	start current screen saver
end tell
</pre>
 * OpenDisplayPreferences.scpt (create the file and include it in your Application directory): 
<pre>
tell application "System Preferences"
	set current pane to pane "com.apple.preference.displays"
	activate
end tell
</pre>
	 * <b>The following example runs the ant process.</b><br/><br/>
	 * 
	 * We've copied Ant into a folder in our application directory, "Ant/bin/ant".
	 * And we've set permissions to execute the ant command (right click, select file properties).
	 * The working directory is the application directory by default. 
	 * We pass in our build.xml file in the arguments.  
<pre>
&lt;nativeProcess:RunProcess id="runAntProcess"
		  startDelay="60"
		  repeatCount="1" 
		  repeatDelay="500"
		  executablePath		="./Ant/bin/ant"
		  standardOutputData	="runProcess_standardOutputDataHandler(event)"
		  standardErrorData		="runProcess_standardErrorDataHandler(event)"
		  standardErrorIOError	="runProcess_standardErrorIOErrorHandler(event)"
		  standardOutputIOError	="runProcess_standardOutputIOErrorHandler(event)"
		  exit					="runProcess_exitHandler(event)"
		  error					="runAntProcess_errorHandler(event)">
	
	&lt;nativeProcess:arguments>
		&lt;fx:Array>
			&lt;fx:String>-f&lt;/fx:String>
			&lt;fx:String>TestAnt.xml&lt;/fx:String>
		&lt;/fx:Array>
	&lt;/nativeProcess:arguments>
&lt;/nativeProcess:RunProcess>

protected function runAntButton_clickHandler(event:MouseEvent):void
{
	runAntProcess.play();
}

protected function runAntProcess_errorHandler(event:Event):void
{
	trace(runAntProcess.errorEvent);
	trace(runAntProcess.errorMessage);
}

protected function runProcess_standardOutputDataHandler(event:ProgressEvent):void {
	trace('StandardOutput:' + runAntProcess.outputData);
	var output:String = runAntProcess.outputData as String;
	
	if (output && output.indexOf("-1")!=-1) {
		trace("Error");
	}
	
	if (output && output.indexOf("{")!=-1) {
		//var user:Object = JSON.parse(output);
	}
}
</pre>
 * 
 * In the previous example, if you put the file in your application directory you must give it execute permissions. 
 * Otherwise you will get a Error #3219. <br/><br/>
	 * 
	 * <b>COMMON EXECUTABLES:</b><br/>
	 * OSAScript - used for running applescript scpt scripts on Mac. Path is /usr/bin/osascript.<br/>
	 * Ditto - used to copy files to another directory. Path is /usr/bin/ditto. <br/><br/>
	 * 
	 * <b>ERROR</b><br/>
	 * Error: Error #3219: The NativeProcess could not be started. 'Not supported in current profile.'<br/>
	 * The Native Process is not supported on this platform. You may need to add extendedDesktop option to your application profile.
	 * If you have done that you may need set the execute bit on the file. Right click on the file and set the execute bit.<br/><br/>
	 * 
	 * <b>SOLUTION</b><br/>
	 * Add <supportedProfiles>extendedDesktop desktop</supportedProfiles> to the application descriptor file<br/><br/>
	 * 
	 * <b>SOLUTION</b><br/>
	 * You will get this error if the file you are attempting to execute doesn't have the execute bit set.
	 * In Flash Builder right click on the file and choose properties. Then set the execute bit. <br/><br/>
	 * 
	 * <b>ERROR</b><br/>
	 * ArgumentError: Error #3214: NativeProcessStartupInfo.executable does not specify a valid executable file.<br/><br/>
	 * 
	 * <b>SOLUTION</b><br/>
	 * Path to executable incorrect. For example, on Mac, the script executable, "usr/bin/osascript" or a executable
	 * you've placed in your application directory, "./MyExectuable/do.exe" or "./MyExecutable/do".<br/>
	 * */
	public class RunProcess extends ActionEffect {
		
		/**
		 * Event name constant when an error occurs at start.
		 * */
		public static const ERROR:String = "error";
		
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
		 * Convenience path to command that runs scripts. Currently set to AppleScript executable on Mac. 
		 * Need to update path to support other OS.
		 * */
		public var scriptOrigin:String = "/usr/bin/osascript";
		
		/**
		 * Path to executable. For example, the path to the AppleScript executable is "/usr/bin/osascript".
		 * If an executable is in the path you can use something like this: 
		 * 
<pre>
"/myCommand"   - same directory as the application
"./myCommand"  - same directory as the application
"../myCommand" - a directory up from the application
</pre>
		 * Also, if you are including a command in your application directory make sure it is getting packaged
		 * with your application. Check Project Properties > Flex Build Packaging > Package Contents
		 * @see scriptOrigin 
		 * */
		public var executablePath:String = "";
		
		/**
		 * Array of arguments to pass to the executable. 
		 * 
		 * For example, if you want to run an AppleScript set the executablePath to 
		 * "/usr/bin/osascript" and the arguments to the path of the file, typically
		 * "myScript.scpt". The full path does not need to be set if the script is in the
		 * application directory since the working directory is set to the application directory 
		 * by default. 
		 * 
		 * For multiple arguments, 
<pre>
arguments="{['-f','myFile.xml']}"
</pre>
		 * @see workingDirectory
		 * */
		[Bindable]
		public var arguments:Array = [];
		
		/**
		 * Working directory. If not set then the File.applicationDirectory path is used.
		 * 
		 * @see arguments
		 * */
		[Bindable]
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
		 * Exit code.<br/>
		 * @copy flash.events.NativeProcessExitEvent.exitCode
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
		 * Effect that is played on native process error during startup. 
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Effect that is played when run process is not supported. 
		 * */
		public var notSupportedEffect:Effect;
		
		/**
		 * Reference to the Error Event when an error occurs during startup
		 * */
		public var errorEvent:Error;
		
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