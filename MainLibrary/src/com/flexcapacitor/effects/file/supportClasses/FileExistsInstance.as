

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.FileExists;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	
	/**
	 * @copy FileExists
	 * */  
	public class FileExistsInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function FileExistsInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:FileExists = FileExists(effect);
			var directory:String = action.directory;
			var fileName:String = action.fileName;
			var base:String = action.baseFilePath;
			var fileExtension:String = action.fileExtension;
			var async:Boolean = action.async;
			var findFile:Boolean = true;
			var fileMode:String = action.fileMode;
			var fileContents:Object;
			var fileLocation:String;
			var fileExists:Boolean;
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
			if (base==FileExists.APPLICATION_STORAGE) {
				file = File.applicationStorageDirectory.resolvePath(fileLocation);
			}
			else if (base==FileExists.APPLICATION) {
				file = File.applicationDirectory.resolvePath(fileLocation);
			}
			else if (base==FileExists.DESKTOP) {
				file = File.desktopDirectory.resolvePath(fileLocation);
			}
			else if (base==FileExists.DOCUMENTS) {
				file = File.documentsDirectory.resolvePath(fileLocation);
			}
			else if (base==FileExists.USER) {
				file = File.userDirectory.resolvePath(fileLocation);
			}
			else if (base==FileExists.ROOT) {
				file = new File(fileLocation);
			}
			
			// check file exists
			fileExists = file && file.exists;
			
			
			if (!fileExists) {
				
				if (hasEventListener(FileExists.FILE_NOT_FOUND)) {
					dispatchEvent(new Event(FileExists.FILE_NOT_FOUND));
				}
				
				if (action.fileNotFoundEffect) {
					playEffect(action.fileNotFoundEffect);
				}
			}
			else {
				
				
				if (action.traceFileURL) {
					trace(action.className + " File URL: " + file.url);
				}
				
				if (action.traceNativeFilePath) {
					trace(action.className + " Native File Path: " + file.nativePath);
				}
				
				if (action.traceRelativeFilePath) {
					trace(action.className + " Relative File Path: " + fileLocation);
				}
				
				action.filePath = file.url;
				action.nativeFilePath = file.nativePath;
				action.relativeFilePath = fileLocation;
				
				if (hasEventListener(FileExists.FILE_FOUND)) {
					dispatchEvent(new Event(FileExists.FILE_FOUND));
				}
				
				if (action.fileFoundEffect) {
					playEffect(action.fileFoundEffect);
				}
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
		
		
	}
}