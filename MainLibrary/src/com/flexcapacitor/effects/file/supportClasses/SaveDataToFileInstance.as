

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.SaveDataToFile;
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
	public class SaveDataToFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		private var completeCalled:Boolean;
		
		/**
		 *  Constructor.
		 * */
		public function SaveDataToFileInstance(target:Object) {
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
			
			var action:SaveDataToFile = SaveDataToFile(effect);
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
			
			///////
			// SO after much more experience with errors and the file system
			// we could probably write this better...
			///////
			
			
			// check filename
			// if not set use reverse date
			if (!fileName) {
				fileName = DateUtils.dateName(dateFileNameDelimiter);
			}
			
			// check if file or file name is available
			for (var i:int;findFile;i++) {
				var paddingValue:String = i>0 ? "_" + StringUtils.padLeft(String(i), digitLength): "";
				
				// add directory path if defined
				if (directory) {
					
					try {
						// check for and create directory 
						if (base==SaveDataToFile.APPLICATION_STORAGE) {
							file = File.applicationStorageDirectory.resolvePath(directory);
						}
						else if (base==SaveDataToFile.APPLICATION) {
							// fileWriteResource
							// SecurityError
							file = File.applicationDirectory.resolvePath(directory);
						}
						else if (base==SaveDataToFile.DESKTOP) {
							file = File.desktopDirectory.resolvePath(directory);
						}
						else if (base==SaveDataToFile.DOCUMENTS) {
							file = File.documentsDirectory.resolvePath(directory);
						}
						else if (base==SaveDataToFile.USER) {
							file = File.userDirectory.resolvePath(directory);
						}
						else if (base==SaveDataToFile.ROOT) {
							//  ArgumentError: Error #2004: One of the parameters is invalid.
							// at Error$/throwError()
							// at flash.filesystem::File/set nativePath()
							file = new File(directory);
						}
					
						if (file && !file.exists) {
							file.createDirectory();
						}
					}
					catch(eee:Error) {
						action.errorEvent = eee;
						action.errorMessage = eee.message;
					
						// See SaveDataToFile ASDoc for errors
						if (action.traceErrors) {
							traceMessage(" Create parent directory error: " + eee.message);
						}
						
						// file not found
						if (action.hasEventListener(SaveDataToFile.ERROR)) {
							dispatchEvent(new Event(SaveDataToFile.ERROR));
						}
						
						if (action.errorEffect) {
							playEffect(action.errorEffect);
						}
						
						finish();
						return;
					}
					
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
					var position:int = fileLocation.lastIndexOf(fileExtension);
					var lastPosition:int = fileLocation.length-fileExtension.length;
					if (position!=lastPosition) {
						fileLocation += "." + fileExtension;
					}
				}
				
				// get base file path 
				// - duplicating code to test if directory needs to be 
				// created first. todo: clean up
				
				try {
					if (base==SaveDataToFile.APPLICATION_STORAGE) {
						file = File.applicationStorageDirectory.resolvePath(fileLocation);
					}
					else if (base==SaveDataToFile.APPLICATION) {
						file = File.applicationDirectory.resolvePath(fileLocation);
					}
					else if (base==SaveDataToFile.DESKTOP) {
						file = File.desktopDirectory.resolvePath(fileLocation);
					}
					else if (base==SaveDataToFile.DOCUMENTS) {
						file = File.documentsDirectory.resolvePath(fileLocation);
					}
					else if (base==SaveDataToFile.USER) {
						file = File.userDirectory.resolvePath(fileLocation);
					}
					else if (base==SaveDataToFile.ROOT) {
						file = new File(fileLocation);
					}
					
					// check file exists
					fileExists = file && file.exists;
					
					
					// If file does not exist check if we should create it
					if (!fileExists && !action.createFile) {
						traceMessage("File does not exist. Please create the file before hand or enable option to create file automatically");
						finish();
						return;
					}
				}
				catch(eee:Error) {
					action.errorEvent = eee;
					action.errorMessage = eee.message;
				
					// See SaveDataToFile ASDoc for errors
					if (action.traceErrors) {
						traceMessage(" Create file error: " + eee.message);
					}
					
					// file not found
					if (action.hasEventListener(SaveDataToFile.ERROR)) {
						dispatchEvent(new Event(SaveDataToFile.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					finish();
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
						traceMessage("File exists but option to overwrite is disabled");
						finish();
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
			
			// end loop to find free file
			
			////////////////////////////////////////
			// Android
			////////////////////////////////////////
			
			// documents
			// File URL:        file:///storage/emulated/0/AsciiArtMaker 
			// NativePath:      /storage/emulated/0/AsciiArtMaker
			
			// applicationStorage
			// File URL:        app-storage:/AsciiArtMaker/125326802100573636_tuOH6kPh_c.txt
			// NativePath:      /data/data/air.AsciiArtMaker.debug/AsciiArtMaker.debug/Local Store/AsciiArtMaker/125326802100573636_tuOH6kPh_c.txt
			
			// desktop and user and documents
			// File URL:         file:///storage/emulated/0/AsciiArtMaker/125326802100573636_tuOH6kPh_c.txt
			// Native File Path: /storage/emulated/0/AsciiArtMaker/125326802100573636_tuOH6kPh_c.txt

			// root
			// ArgumentError: Error #2004: One of the parameters is invalid.
			// at Error$/throwError()
			// at flash.filesystem::File/set nativePath()
			
			// application
			// SecurityError
			// fileWriteResource
			
			
			if (action.traceFilePaths) {
				traceMessage(" Target File Exists: " + (fileExists?"true":"false"));
				traceMessage(" Target Defined File Path: " + fileLocation);
				traceMessage(" Target File URL: " + file.url);
				traceMessage(" Target Native File Path: " + file.nativePath);
				traceMessage(" Target Space Available: " + file.spaceAvailable);
			}
			
			
			try {
				// set the file contents
				stream = new FileStream();
				
				addFileStreamListeners(stream);
				
			
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
			
				// NEED to handle ASYNC HERE
				//if (!async) {
				stream.close();
				
				// if space available is not 0 then that is good indication file was created or saved
				action.spaceAvailable = file.spaceAvailable;
				
				if (action.traceFilePaths) {
					traceMessage(" Target File stream written");
					traceMessage(" Target File Exists: " + (file.exists?"true":"false"));
					traceMessage(" Target Space Available: " + file.spaceAvailable);
				}
			}
			catch (error:Error) {
				action.errorEvent = error;
				action.errorMessage = error.message;
			
				// See SaveDataToFile ASDoc for errors
				if (action.traceErrors) {
					traceMessage(" Save Error: " + error.message);
				}
				
				// file not found
				if (action.hasEventListener(SaveDataToFile.ERROR)) {
					dispatchEvent(new Event(SaveDataToFile.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
				
				removeFileStreamListeners(stream);
				finish();
				return;
			}
			
			
			action.savedFilePath = file.url;
			action.savedNativeFilePath = file.nativePath;
			action.savedRelativeFilePath = fileLocation;
			
			
			
			// complete event hasn't been called in tests
			// but we need to dispatch events and run effects
			if (!completeCalled) {
				removeFileStreamListeners(stream);
				
				if (hasEventListener(SaveDataToFile.SUCCESS)) {
					dispatchEvent(new Event(SaveDataToFile.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
				
				completeCalled = true;
				
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// this should call wait if we use async?!
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
		
		/**
		 * File Stream close event
		 * */
		private function closeHandler(event:Event):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeFileStreamListeners(file);
			
			if (hasEventListener(SaveDataToFile.CLOSE)) {
				dispatchEvent(new Event(SaveDataToFile.CLOSE));
			}
			
			if (action.closeEffect) {
				playEffect(action.closeEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			// ???????
			//finish();
		}
		
		/**
		 * File Stream output progress event
		 * */
		private function outputProgressHandler(event:OutputProgressEvent):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(SaveDataToFile.OUTPUT_PROGRESS)) {
				dispatchEvent(new Event(SaveDataToFile.OUTPUT_PROGRESS));
			}
			
			if (action.outputProgressEffect) {
				playEffect(action.outputProgressEffect);
			}
			
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		/**
		 * File Stream progress event
		 * */
		private function progressHandler(event:ProgressEvent):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(SaveDataToFile.PROGRESS)) {
				dispatchEvent(new Event(SaveDataToFile.PROGRESS));
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		/**
		 * 
		 * */
		private function completeHandler(event:Event = null):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			completeCalled = true;
			
			removeFileStreamListeners(file);
			
			file.close();
			
			if (hasEventListener(SaveDataToFile.SUCCESS)) {
				dispatchEvent(new Event(SaveDataToFile.SUCCESS));
			}
			
			if (action.successEffect) {
				playEffect(action.successEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * File Stream IOError handler
		 * */
		private function ioErrorHandler(event:IOErrorEvent):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(SaveDataToFile.FAULT)) {
				dispatchEvent(new Event(SaveDataToFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * File Stream SecurityError handler
		 * */
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:SaveDataToFile = SaveDataToFile(event);
			var file:FileStream = FileStream(event.target);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			removeFileStreamListeners(file);
			
			file.close();
			
			
			if (hasEventListener(SaveDataToFile.FAULT)) {
				dispatchEvent(new Event(SaveDataToFile.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
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