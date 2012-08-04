

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.SaveContentsToFile;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.DateUtils;
	import com.flexcapacitor.utils.StringUtils;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	
	/**
	 *  @copy SaveContentsToFile
	 * */  
	public class SaveContentsToFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		private var completeCalled:Boolean;
		
		/**
		 *  Constructor.
		 * */
		public function SaveContentsToFileInstance(target:Object) {
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
			
			var action:SaveContentsToFile = SaveContentsToFile(effect);
			var directory:String = action.directory;
			var fileName:String = action.fileName;
			var base:String = action.baseFilePath;
			var data:Object = action.data;
			var fileExtension:String = action.fileExtension;
			var overwrite:String = action.overwrite;
			var digitLength:int = action.digitLength;
			var async:Boolean = action.async;
			var findFile:Boolean = true;
			var fileLocation:String;
			var fileExists:Boolean;
			var stream:FileStream;
			var file:File;
			var dateFileNameDelimiter:String = action.dateFileNameDelimiter;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// check that contents exist
				if (!data) {
					dispatchErrorEvent("The content is null");
				}
				
				// check that file name is defined
				/*if (!fileName) {
					dispatchErrorEvent("The file name is not set");
				}*/
				
				// check that file name is defined
				/*if (!fileExtension) {
					dispatchErrorEvent("The file extension is not set");
				}*/
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check filename
			// if not set use reverse date
			if (!fileName) {
				fileName = DateUtils.dateName(dateFileNameDelimiter);
			}
			
			// check if file or file name is available
			for (var i:int;findFile;i++) {
				var paddingValue:String = i>0 ? StringUtils.padLeft(String(i), digitLength): "";
				
				// add directory path if defined
				if (directory) {
					
					if (directory.charAt(directory.length-1)!=File.separator) {
						directory = directory + File.separator;
					}
				
					fileLocation = directory + fileName + paddingValue;
				}
				else {
					fileLocation = fileName + paddingValue;
				}
				
				// append file extension
				if (fileExtension) {
					fileLocation += "." + fileExtension;
				}
				
				// get base file path
				if (base==SaveContentsToFile.APPLICATION_STORAGE) {
					file = File.applicationStorageDirectory.resolvePath(fileLocation);
				}
				else if (base==SaveContentsToFile.APPLICATION) {
					file = File.applicationDirectory.resolvePath(fileLocation);
				}
				else if (base==SaveContentsToFile.DESKTOP) {
					file = File.desktopDirectory.resolvePath(fileLocation);
				}
				else if (base==SaveContentsToFile.DOCUMENTS) {
					file = File.documentsDirectory.resolvePath(fileLocation);
				}
				else if (base==SaveContentsToFile.USER) {
					file = File.userDirectory.resolvePath(fileLocation);
				}
				else if (base==SaveContentsToFile.ROOT) {
					file = new File(fileLocation);
				}
				
				// check file exists
				fileExists = file && file.exists;
				
				
				// If file does not exist check if we should create it
				if (!fileExists && !action.createFile) {
					cancel("Please create the file before hand or enable option to create file automatically");
					return;
				}
				
				// if file does exist check if we can overwrite it
				if (fileExists) {
					
					// get next available filename
					if (overwrite=="increment") {
						continue;
					}
					
					// do not overwrite
					else if (overwrite=="false") {
						findFile = false;
						cancel("File exists but option to overwrite is disabled");
						return;
					}
					else {
						findFile = false;
					}
				}
				else {
					findFile = false;
				}
			}
			
			// set the file contents
			stream = new FileStream();
			
			addFileStreamListeners(stream);
			
			
			// maybe we need to put a try catch around this mofo
			if (action.async) {
				stream.openAsync(file, FileMode.WRITE);
			}
			else {
				stream.open(file, FileMode.WRITE);
			}
			
			if (data is XML) {
				stream.writeUTFBytes(data.toXMLString());
			}
			else if (data is ByteArray) {
				stream.writeBytes(ByteArray(data));
			}
			else {
				stream.writeUTFBytes(data.toString());
			}
			
			//if (!async) {
				stream.close();
			//}
			
			action.savedFilePath = file.url;
			action.savedNativeFilePath = file.nativePath;
			action.savedRelativeFilePath = fileLocation;
			
			if (action.traceFileURL) {
				trace(action.className + " File URL: " + file.url);
			}
			
			if (action.traceNativeFilePath) {
				trace(action.className + " Native File Path: " + file.nativePath);
			}
			
			if (action.traceRelativeFilePath) {
				trace(action.className + " Relative File Path: " + fileLocation);
			}
			
			// complete event hasn't been called in tests
			// but we need to dispatch events and run effects
			if (!completeCalled) {
				removeFileStreamListeners(stream);
			
				
				if (hasEventListener(SaveContentsToFile.SUCCESS)) {
					dispatchEvent(new Event(SaveContentsToFile.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
				
				completeCalled = true;
				
			}
			
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
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			//trace("closeHandler: name=" + file.name);
			
			removeFileStreamListeners(file);
			
			if (hasEventListener(SaveContentsToFile.CLOSE)) {
				dispatchEvent(new Event(SaveContentsToFile.CLOSE));
			}
			
			if (action.closeEffect) {
				playEffect(action.closeEffect);
			}
		}
		
		private function outputProgressHandler(event:OutputProgressEvent):void {
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(SaveContentsToFile.OUTPUT_PROGRESS)) {
				dispatchEvent(new Event(SaveContentsToFile.OUTPUT_PROGRESS));
			}
			
			if (action.outputProgressEffect) {
				playEffect(action.outputProgressEffect);
			}
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(SaveContentsToFile.PROGRESS)) {
				dispatchEvent(new Event(SaveContentsToFile.PROGRESS));
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function completeHandler(event:Event = null):void {
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			completeCalled = true;
			//trace("completeHandler: name=" + file.name);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			if (hasEventListener(SaveContentsToFile.SUCCESS)) {
				dispatchEvent(new Event(SaveContentsToFile.SUCCESS));
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
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			//trace("ioErrorHandler: name=" + file.name);
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(SaveContentsToFile.FAULT)) {
				dispatchEvent(new Event(SaveContentsToFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			cancel("ioErrorHandler: text=" + event.text);
		}
		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:SaveContentsToFile = SaveContentsToFile(event);
			var file:FileStream = FileStream(event.target);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(SaveContentsToFile.FAULT)) {
				dispatchEvent(new Event(SaveContentsToFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			cancel("securityErrorHandler: text=" + event.text);
			
		}
		//--------------------------------------------------------------------------
		//  File Helper Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Adds file stream listeners
		 * */
		private function addFileStreamListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CLOSE, 						closeHandler);
			dispatcher.addEventListener(Event.COMPLETE,				 		completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, outputProgressHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			progressHandler);
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