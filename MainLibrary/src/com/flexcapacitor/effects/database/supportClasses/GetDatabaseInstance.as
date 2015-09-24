

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.effects.database.GetDatabase;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	
	/**
	 * @copy GetDatabase
	 * */  
	public class GetDatabaseInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function GetDatabaseInstance(target:Object) {
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
			
			var action:GetDatabase = GetDatabase(effect);
			var directory:String = action.directory;
			var fileName:String = action.fileName;
			var base:String = action.baseFilePath;
			var fileExtension:String = action.fileExtension;
			var connection:SQLConnection = action.connection;
			var traceFilePaths:Boolean = action.traceFilePaths;
			var backupPath:String = action.backupPath;
			var useBackup:String = action.useBackup;
			var fileMode:String = action.fileMode;
			var async:Boolean = action.async;
			var findFile:Boolean = true;
			var fileContents:Object;
			var fileLocation:String;
			var fileExists:Boolean;
			var stream:FileStream;
			var backupDatabaseFile:File;
			var databaseFile:File;
			var backupModifiedDate:Date;
			var databaseModifiedDate:Date;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!fileName) {
					dispatchErrorEvent("The file name is required.");
				}
				
				if (useBackup==GetDatabase.NEWER && backupPath==null) {
					dispatchErrorEvent("Use backup database if newer is set but the path to the backup database is not.");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			///////////// GET DATABASE FILE /////////////
			
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
			
			// get file path to database
			if (base==GetDatabase.APPLICATION_STORAGE) {
				databaseFile = File.applicationStorageDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.APPLICATION) {
				databaseFile = File.applicationDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.DESKTOP) {
				databaseFile = File.desktopDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.DOCUMENTS) {
				databaseFile = File.documentsDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.USER) {
				databaseFile = File.userDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.ROOT) {
				databaseFile = new File(fileLocation);
			}
			
			// check file exists
			fileExists = databaseFile && databaseFile.exists;
			
			// modified date
			if (fileExists) {
				databaseModifiedDate = new Date(databaseFile.modificationDate);
			}
			else {
				databaseModifiedDate = new Date();
			}
			
			// store file
			action.file = databaseFile;
			
			// get file location
			action.filePath = databaseFile.url;
			action.nativeFilePath = databaseFile.nativePath;
			action.relativeFilePath = fileLocation;
			
			if (traceFilePaths) {
				traceMessage(" Database File Exists: " + (fileExists?"true":"false"));
				traceMessage(" Database Defined File Path: " + fileLocation);
				traceMessage(" Database File URL: " + databaseFile.url);
				traceMessage(" Database Native File Path: " + databaseFile.nativePath);
				traceMessage(" Database Space Available: " + formatSize(databaseFile.spaceAvailable) + "GB");
				traceMessage(" Database File Mode: " + fileMode);
				traceMessage(" Database Modified Date: " + databaseModifiedDate);
			}
			
			// If a writable DB doesn't exist, we then copy it into the app folder so it's writeable
			// copy backup database if it doesn't exist
			if (backupPath) {
				var backupIsNewer:Boolean;
				backupDatabaseFile = File.applicationDirectory.resolvePath(backupPath);
				if (backupDatabaseFile.exists) {
					backupModifiedDate = new Date(backupDatabaseFile.modificationDate);
				}
				
				if (traceFilePaths) {
					traceMessage("");
					traceMessage(" Backup File Exists: " + (backupDatabaseFile.exists ? "true":"false"));
					traceMessage(" Backup Defined File Path: " + backupPath);
					traceMessage(" Backup File URL: " + backupDatabaseFile.url);
					traceMessage(" Backup Native File Path: " + backupDatabaseFile.nativePath);
					traceMessage(" Backup File Space Available: " + formatSize(backupDatabaseFile.spaceAvailable) + "GB");
					if (backupDatabaseFile.exists) traceMessage(" Backup Modified Date: " + backupModifiedDate);
				}
				
				if (fileExists && backupDatabaseFile.exists && 
					backupDatabaseFile.modificationDate > databaseFile.modificationDate) {
					backupIsNewer = true;
					
					if (traceFilePaths) {
						traceMessage(" Backup is newer than saved. ");
					}
				}
				
				if ((!fileExists && (useBackup==GetDatabase.AUTO || useBackup==GetDatabase.DOES_NOT_EXIST)) 
					|| (useBackup==GetDatabase.NEWER && backupIsNewer) 
					|| useBackup==GetDatabase.ALWAYS) {
					
					if (backupDatabaseFile.exists) {
						try {
							backupDatabaseFile.copyTo(databaseFile, true);
							fileExists = true;
							
							// backup file used
							if (action.hasEventListener(GetDatabase.BACKUP_FILE_USED)) {
								dispatchActionEvent(new Event(GetDatabase.BACKUP_FILE_USED));
							}
							
							if (action.backupFileUsedEffect) {
								playEffect(action.backupFileUsedEffect);
							}
							
							if (traceFilePaths) {
								traceMessage(" Backup file was copied to: " + databaseFile.nativePath);
							}
						}
						catch (ee:Error) {
							// Error #3012: Cannot delete file or directory.
							
							// IOError - The source does not exist; or the destination exists and overwrite is false; 
							// or the source could not be copied to the target; or the source and destination refer 
							// to the same file or folder and overwrite is set to true. On Windows, you cannot copy 
							// a file that is open or a directory that contains a file that is open.
							
							// SecurityError - The application does not have the necessary permissions to write to 
							// the destination.
	
							action.errorEvent = ee;
							action.errorMessage = ee.message;
							
							if (action.traceErrors) {
								traceMessage(" Database Error: " + ee.message);
							}
							
							// file not found
							if (action.hasEventListener(GetDatabase.ERROR)) {
								dispatchActionEvent(new Event(GetDatabase.ERROR));
							}
							
							if (action.errorEffect) {
								playEffect(action.errorEffect);
							}
							
							if (traceFilePaths) {
								traceMessage(" Backup file was not copied to: " + databaseFile.nativePath);
							}
						}
						
					}
					else {
						
						// file not found
						if (action.hasEventListener(GetDatabase.BACKUP_FILE_NOT_FOUND)) {
							dispatchActionEvent(new Event(GetDatabase.BACKUP_FILE_NOT_FOUND));
						}
						
						if (action.backupFileNotFoundEffect) {
							playEffect(action.backupFileNotFoundEffect);
						}
						
						if (traceFilePaths) {
							traceMessage(" Backup database does not exist at the location: " + backupDatabaseFile.nativePath);
						}
					}
				}
			}
			
			
			////////////// CREATE CONNECTION /////////////
			
			// create connection
			if (!connection) {
				connection = new SQLConnection();
			}
			
			// add async support
			try {
				if (!async) {
					// open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null)
					connection.open(databaseFile, action.fileMode, action.autoCompact, action.pageSize, action.encryptionKey);
				}
				else {
					// openAsync(reference:Object=null, openMode:String="create", responder:Responder=null, autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null)
					connection.openAsync(databaseFile, action.fileMode, action.responder, action.autoCompact, action.pageSize, action.encryptionKey);
				}
				//trace("connection opened");
			}
			catch(error:Error) {
				//trace(error.message);
				action.errorEvent = error;
				action.errorMessage = error.message;
			
				if (action.traceErrors) {
					traceMessage(" Database Error: " + error.message);
				}
				
				// file not found
				if (action.hasEventListener(GetDatabase.ERROR)) {
					dispatchActionEvent(new Event(GetDatabase.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
			}
			
			action.connection = connection;
			
			// file found
			if (fileExists) {
			
				if (action.hasEventListener(GetDatabase.SUCCESS)) {
					dispatchActionEvent(new Event(GetDatabase.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// file not found
				if (action.hasEventListener(GetDatabase.FILE_NOT_FOUND)) {
					dispatchActionEvent(new Event(GetDatabase.FILE_NOT_FOUND));
				}
				
				if (action.notCreatedEffect) {
					playEffect(action.notCreatedEffect);
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
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			
			removeFileStreamListeners(file);
			
			if (action.hasEventListener(GetDatabase.CLOSE)) {
				dispatchActionEvent(new Event(GetDatabase.CLOSE));
			}
			
			if (action.closeEffect) {
				playEffect(action.closeEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		private function outputProgressHandler(event:OutputProgressEvent):void {
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			
			if (action.hasEventListener(GetDatabase.OUTPUT_PROGRESS)) {
				dispatchActionEvent(new Event(GetDatabase.OUTPUT_PROGRESS));
			}
			
			if (action.outputProgressEffect) {
				playEffect(action.outputProgressEffect);
			}
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			
			if (action.hasEventListener(GetDatabase.PROGRESS)) {
				dispatchActionEvent(new Event(GetDatabase.PROGRESS));
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function completeHandler(event:Event = null):void {
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			//trace("completeHandler: name=" + file.name);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			if (action.hasEventListener(GetDatabase.SUCCESS)) {
				dispatchActionEvent(new Event(GetDatabase.SUCCESS));
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
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			//trace("ioErrorHandler: name=" + file.name);
			removeFileStreamListeners(file);
			
			file.close();
			
			action.errorEvent = event;
			action.errorMessage = event.text;
			
			if (action.hasEventListener(GetDatabase.FAULT)) {
				dispatchActionEvent(new Event(GetDatabase.FAULT));
			}
			
			if (action.faultEffect) {
				playEffect(action.faultEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			
			removeFileStreamListeners(file);
			
			file.close();
			
			action.errorEvent = event;
			action.errorMessage = event.text;
			
			
			if (action.hasEventListener(GetDatabase.FAULT)) {
				dispatchActionEvent(new Event(GetDatabase.FAULT));
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
		
		/**
		 * Get size in format
		 * */
		public function formatSize(value:Number, format:String="GB", decimalPlaces:int = 3):String {
			
			if (format.toLowerCase()=="kb") {
				value = value/1024;
			}
			
			else if (format=="MB") {
				value = value/1024/1024;
			}
			
			else if (format=="GB") {
				value = value/1024/1024/1024;
			}
			
			else if (format=="TB") {
				value = value/1024/1024/1024/1024;
			}
			

			return value.toFixed(decimalPlaces);;
		}
	}
}