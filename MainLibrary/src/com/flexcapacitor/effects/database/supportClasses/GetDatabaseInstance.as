

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
			var fileMode:String = action.fileMode;
			var connection:SQLConnection = action.connection;
			var async:Boolean = action.async;
			var findFile:Boolean = true;
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
			
			// get base file path
			if (base==GetDatabase.APPLICATION_STORAGE) {
				file = File.applicationStorageDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.APPLICATION) {
				file = File.applicationDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.DESKTOP) {
				file = File.desktopDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.DOCUMENTS) {
				file = File.documentsDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.USER) {
				file = File.userDirectory.resolvePath(fileLocation);
			}
			else if (base==GetDatabase.ROOT) {
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
			
			////////////// CREATE CONNECTION /////////////
			
			// create connection
			if (!connection) {
				connection = new SQLConnection();
			}
			
			// add async support
			try {
				if (!async) {
					// open(reference:Object=null, openMode:String="create", autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null)
					connection.open(file);
				}
				else {
					// openAsync(reference:Object=null, openMode:String="create", responder:Responder=null, autoCompact:Boolean=false, pageSize:int=1024, encryptionKey:ByteArray=null)
					connection.openAsync(file);
				}
				trace("connection opened");
			} catch(error:Error) {
				trace(error.message);
			}
			
			action.connection = connection;
			
			// file found
			if (fileExists) {
			
				if (hasEventListener(GetDatabase.SUCCESS)) {
					dispatchEvent(new Event(GetDatabase.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// file not found
				if (hasEventListener(GetDatabase.FILE_NOT_FOUND)) {
					dispatchEvent(new Event(GetDatabase.FILE_NOT_FOUND));
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
			
			if (hasEventListener(GetDatabase.CLOSE)) {
				dispatchEvent(new Event(GetDatabase.CLOSE));
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
			
			if (hasEventListener(GetDatabase.OUTPUT_PROGRESS)) {
				dispatchEvent(new Event(GetDatabase.OUTPUT_PROGRESS));
			}
			
			if (action.outputProgressEffect) {
				playEffect(action.outputProgressEffect);
			}
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var action:GetDatabase = GetDatabase(event);
			var file:FileStream = FileStream(event.target);
			
			if (hasEventListener(GetDatabase.PROGRESS)) {
				dispatchEvent(new Event(GetDatabase.PROGRESS));
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
			
			if (hasEventListener(GetDatabase.SUCCESS)) {
				dispatchEvent(new Event(GetDatabase.SUCCESS));
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
			
			
			if (hasEventListener(GetDatabase.FAULT)) {
				dispatchEvent(new Event(GetDatabase.FAULT));
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
			
			
			if (hasEventListener(GetDatabase.FAULT)) {
				dispatchEvent(new Event(GetDatabase.FAULT));
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
	}
}