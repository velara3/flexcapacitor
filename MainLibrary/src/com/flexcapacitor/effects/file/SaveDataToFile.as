

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.SaveDataToFileInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched on close event
	 * */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Event dispatched on progress event
	 * */
	[Event(name="progress", type="flash.events.Event")]
	
	/**
	 * Event dispatched on output progress event
	 * */
	[Event(name="outputProgress", type="flash.events.Event")]
	
	/**
	 * Event dispatched when save is successful
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when save is unsuccessful
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Save the data you supply to a file. Requires AIR.
	 * @see PromptSaveAs
	 * */
	public class SaveDataToFile extends ActionEffect {
		
		public static const APPLICATION_STORAGE:String = "applicationStorage";
		public static const APPLICATION:String = "application";
		public static const DESKTOP:String = "desktop";
		public static const DOCUMENTS:String = "documents";
		public static const USER:String = "user";
		public static const ROOT:String = "root";
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		public static const ERROR:String = "error";
		public static const PROGRESS:String = "progress";
		public static const OUTPUT_PROGRESS:String = "outputProgress";
		public static const CLOSE:String = "close";
		
		/**
		 *  Constructor.
		 * */
		public function SaveDataToFile(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = SaveDataToFileInstance;
			
		}
		
		
		/**
		 * Name of file or directory and file name.
		 * If the directory property is set it is prepended to the file name.
		 * */
		public var fileName:String;
		
		/**
		 * The contents of the file
		 * */
		public var data:Object;
		
		/**
		 * Directory of the file. Optional.
		 * The file name property can include the file path.
		 * */
		public var directory:String;
		
		/**
		 * Overwrite the file if it exists. Default is true
		 * */
		[Inspectable(enumeration="true,false,increment")]
		public var overwrite:String = "increment";
		
		/**
		 * Create the file if it doesn't exist. Default is true
		 * */
		public var createFile:Boolean = true;
		
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
		public var baseFilePath:String = APPLICATION_STORAGE;
		
		/**
		 * Prints the file URL, native path and relative file path to the console.
		 * */
		public var traceFilePaths:Boolean;
		
		/**
		 * Prints the errors to the console.
		 * */
		public var traceErrors:Boolean;
		
		/**
		 * Effect played on error during opening of database
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:Error;
		
		/**
		 * Reference to the error message
		 * */
		[Bindable]
		public var errorMessage:String;
		
		/**
		 * Reference to the file
		 * */
		public var file:Object;
		
		/**
		 * Effect played if save is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if save is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Effect played on progress event  
		 * */
		public var progressEffect:IEffect;
		
		/**
		 * Effect played on output progress event  
		 * */
		public var outputProgressEffect:IEffect;
		
		/**
		 * Effect played on close event
		 * */
		public var closeEffect:IEffect;
		
		/**
		 * Specifies the length of digits when renaming a file 
		 * during auto incrementing. 
		 * Overwrite must be set to increment
		 * */
		public var digitLength:int = 3;
		
		/**
		 * Opens the file asyncronous
		 * */
		public var async:Boolean;
		
		/**
		 * Delimiter for auto generated file name
		 * */
		public var dateFileNameDelimiter:String = "-";
		
		/**
		 * Space available
		 * */
		[Bindable]
		public var spaceAvailable:int;
		
		/**
		 * Path to saved file
		 * */
		[Bindable]
		public var savedFilePath:String;
		
		/**
		 * Path to saved file
		 * */
		[Bindable]
		public var savedNativeFilePath:String;
		
		/**
		 * Relative path to saved file
		 * */
		[Bindable]
		public var savedRelativeFilePath:String;
	}
}