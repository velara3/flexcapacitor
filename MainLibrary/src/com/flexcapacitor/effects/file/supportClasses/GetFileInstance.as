

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.GetFile;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	
	/**
	 * @copy GetFile
	 * */  
	public class GetFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function GetFileInstance(target:Object) {
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
			// Dispatch an effectStart event
			super.play();
			
			var action:GetFile = GetFile(effect);
			var directory:String = action.directory;
			var fileName:String = action.fileName;
			var base:String = action.baseFilePath;
			var data:Object = action.data;
			var fileExtension:String = action.fileExtension;
			var async:Boolean = action.async;
			var findFile:Boolean = true;
			var fileMode:String = action.fileMode;
			var fileContents:Object;
			var fileLocation:String;
			var fileExists:Boolean;
			var stream:FileStream;
			var file:File;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!fileName) {
					dispatchErrorEvent("The file name is required");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// add directory path if defined
			if (directory) {
				
				if (directory.charAt(directory.length-1)!=File.separator) {
					directory = directory + File.separator;
				}
				
				fileLocation = directory + fileName;
			}
			else {
				fileLocation = fileName;
			}
			
			// append file extension
			if (fileExtension) {
				fileLocation += "." + fileExtension;
			}
			
			// get base file path
			if (base==GetFile.APPLICATION_STORAGE) {
				file = File.applicationStorageDirectory.resolvePath(fileLocation);
			}
			else if (base==GetFile.APPLICATION) {
				file = File.applicationDirectory.resolvePath(fileLocation);
			}
			else if (base==GetFile.DESKTOP) {
				file = File.desktopDirectory.resolvePath(fileLocation);
			}
			else if (base==GetFile.DOCUMENTS) {
				file = File.documentsDirectory.resolvePath(fileLocation);
			}
			else if (base==GetFile.USER) {
				file = File.userDirectory.resolvePath(fileLocation);
			}
			else if (base==GetFile.ROOT) {
				file = new File(fileLocation);
			}
			
			// check file exists
			fileExists = file && file.exists;
			
			// store file
			action.file = file;
			
			// get file location
			action.filePath = file.url;
			action.nativeFilePath = file.nativePath;
			action.relativeFilePath = fileLocation;
			
			if (action.traceFileURL) {
				trace(action.className + " File URL: " + file.url);
			}
			
			if (action.traceNativeFilePath) {
				trace(action.className + " Native File Path: " + file.nativePath);
			}
			
			if (action.traceRelativeFilePath) {
				trace(action.className + " Relative File Path: " + fileLocation);
			}
			
			
			// file found
			if (fileExists) {
			
				// set the file contents
				stream = new FileStream();
				
				// add listeners
				addFileStreamListeners(stream);
				
				// maybe we need to put a try catch around this mofo
				if (async) {
					stream.openAsync(file, fileMode);
				}
				else {
					stream.open(file, fileMode);
				}
				
				// read in the contents
				action.data = stream.readMultiByte(file.size, File.systemCharset);
				
				stream.close();
				
				// remove listeners
				removeFileStreamListeners(stream);
				
				
				if (hasEventListener(GetFile.SUCCESS)) {
					dispatchEvent(new Event(GetFile.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// file not found
				if (hasEventListener(GetFile.FILE_NOT_FOUND)) {
					dispatchEvent(new Event(GetFile.FILE_NOT_FOUND));
				}
				
				if (action.fileNotFoundEffect) {
					playEffect(action.fileNotFoundEffect);
				}
			}
			
			// NOTE WE MAY NEED TO WAIT FOR ASYNC OPERATIONS
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  File Reference Handlers
		//--------------------------------------------------------------------------
		
		
		private function closeHandler(event:Event):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			//trace("closeHandler: name=" + file.name);
			
			removeFileStreamListeners(file);
			
			if (hasEventListener(GetFile.CLOSE)) {
				dispatchEvent(new Event(GetFile.CLOSE));
			}
			
			if (action.closeEffect) {
				playEffect(action.closeEffect);
			}
		}
		
		private function outputProgressHandler(event:OutputProgressEvent):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(GetFile.OUTPUT_PROGRESS)) {
				dispatchEvent(new Event(GetFile.OUTPUT_PROGRESS));
			}
			
			if (action.outputProgressEffect) {
				playEffect(action.outputProgressEffect);
			}
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(GetFile.PROGRESS)) {
				dispatchEvent(new Event(GetFile.PROGRESS));
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function completeHandler(event:Event = null):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			//trace("completeHandler: name=" + file.name);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			if (hasEventListener(GetFile.SUCCESS)) {
				dispatchEvent(new Event(GetFile.SUCCESS));
			}
			
			if (action.successEffect) {
				playEffect(action.successEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			//trace("ioErrorHandler: name=" + file.name);
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(GetFile.FAULT)) {
				dispatchEvent(new Event(GetFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			cancel("ioErrorHandler: text=" + event.text);
		}
		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:GetFile = GetFile(event);
			var file:FileStream = FileStream(event.target);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(GetFile.FAULT)) {
				dispatchEvent(new Event(GetFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			cancel("securityErrorHandler: text=" + event.text);
			
		}
		
		//--------------------------------------------------------------------------
		//  File Helper Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Adds file stream listeners
		 * */
		private function addFileStreamListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CLOSE, 							closeHandler);
			dispatcher.addEventListener(Event.COMPLETE,				 			completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 					ioErrorHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 		securityErrorHandler);
			dispatcher.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, 	outputProgressHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 				progressHandler);
		}
		
		/**
		 * Removes file stream listeners
		 * */
		private function removeFileStreamListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.CLOSE, 						closeHandler);
			dispatcher.removeEventListener(Event.COMPLETE, 						completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, outputProgressHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, 				progressHandler);
		}
	}
}