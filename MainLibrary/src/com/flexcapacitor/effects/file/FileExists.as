

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.FileExistsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.filesystem.FileMode;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Event dispatched when file is found
	 * */
	[Event(name="fileFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file not found
	 * */
	[Event(name="fileNotFound", type="flash.events.Event")]
	
	/**
	 * Checks if the file exists. AIR ONLY
	 * 
	 * @see BrowseForFile
	 * @see GetFile
	 * @see LoadFile
	 * @see PromptSaveAs
	 * @see SaveDataToFile
	 * @see UploadFile
	 * */
	public class FileExists extends ActionEffect {
		
		public static const APPLICATION_STORAGE:String = "applicationStorage";
		public static const APPLICATION:String = "application";
		public static const DESKTOP:String = "desktop";
		public static const DOCUMENTS:String = "documents";
		public static const USER:String = "user";
		public static const ROOT:String = "root";
		public static const FILE_FOUND:String = "fileFound";
		public static const FILE_NOT_FOUND:String = "fileNotFound";
		
		/**
		 *  Constructor.
		 * */
		public function FileExists(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = FileExistsInstance;
			
		}
		
		
		/**
		 * Name of file or directory and file name.
		 * If the directory property is set it is prepended to the file name.
		 * */
		public var fileName:String;
		
		/**
		 * Directory of the file. Optional.
		 * The file name property can include the file path.
		 * */
		public var directory:String;
		
		/**
		 * File extension.
		 * */
		public var fileExtension:String = "";
		
		/**
		 * Location of path that other files will be relative to if not specified.
		 * Includes applicationStorageDirectory, applicationDirectory, userDirectory,
		 * desktopDirectory, documentsDirectory or root directory.
		 * Default is applicationStorage
		 * */
		[Inspectable(enumeration="application,applicationStorage,user,desktop,documents,root")]
		public var baseFilePath:String = "applicationStorage";
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * */
		public var traceNativeFilePath:Boolean;
		
		/**
		 * Prints the relative file path to the console.
		 * */
		public var traceRelativeFilePath:Boolean;
		
		/**
		 * Reference to the file. You do not set this. 
		 * */
		public var file:Object;
		
		/**
		 * @copy flash.filesystem.FileMode
		 * */
		[Inspectable(enumeration="read,write,append,update")]
		public var fileMode:String = FileMode.READ;
		
		/**
		 * Effect played if file found  
		 * */
		public var fileFoundEffect:IEffect;
		
		/**
		 * Effect played if file not found. 
		 * */
		public var fileNotFoundEffect:IEffect;
		
		/**
		 * Opens the file asyncronous
		 * */
		public var async:Boolean;
		
		/**
		 * Path to saved file. You do not set this. 
		 * It is set after file is retrieved. 
		 * */
		[Bindable]
		public var filePath:String;
		
		/**
		 * Path to saved file
		 * */
		[Bindable]
		public var nativeFilePath:String;
		
		/**
		 * Relative path to saved file
		 * */
		[Bindable]
		public var relativeFilePath:String;
	}
}