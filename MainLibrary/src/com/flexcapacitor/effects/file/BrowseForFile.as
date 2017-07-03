

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.BrowseForFileInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	
	import mx.effects.IEffect;
	
	/**
	 * Dispatched on the file browse select event
	 * @copy file.net.FileReference.select
	 * */
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * Dispatched on the file browse cancel event
	 * @copy file.net.FileReference.cancel
	 * */
	[Event(name="cancel", type="flash.events.Event")]
	
	/**
	 * Dispatched on a file browse error event
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	
	/**
	 * Opens a browse for file dialog to select files. 
	 * In the browser this effect does NOT load the file it only selects it. 
	 * You must use the LoadFile to load the file.
	 * 
	 * The selection effect or multiple selection effect is run 
	 * when files are selected. The file or files are set 
	 * in the fileReference, fileReferenceList or fileList property. 
	 * 
	 * NOTE: In the browser this effect MUST be called within the 
	 * bubbling of a click event. If another effect is run before this one
	 * this effect may not be run in time. 
	 * 
	 * <pre>
	 &lt;file:BrowseForFile id="browseForFile"
							fileTypes="png,jpg,jpeg,gif"
							targetAncestor="{this}"
							allowMultipleSelection="false">
			&lt;file:selectionEffect>
				&lt;file:LoadFile id="loadFile"  
							   loadIntoLoader="true"
							   fileReference="{browseForFile.fileReference}"/>
			&lt;/file:selectionEffect>
		 &lt;/file:BrowseForFile>
	 * </pre>
	 * 
	 * If it is part of an event handler it must be called within the call stack of a click event.
	 * Set the targetAncestor property to a parent of the button that triggers this event.
	 * You can usually bind it to the "this" property or "systemManager".
	 * Must not have any effects before it that have any duration. <br/><br/>
	 * 
	 * <b>Errors:</b> <br/>
	 * Error #2037: Functions called in incorrect sequence, or earlier call was unsuccessful.<br/>
	 * Cause: A file was never selected by the user and we tried to call a method like load().<br/><br/>
	 * For example, the events should be:
	 * <pre>
	 * 1. file = new FileReference();
	 * 2. file.browse(); // user selects a file
	 * 3. file.load()
	 * </pre>
	 * An error occurs when we do this: 
	 * <pre>
	 * 1. file = new FileReference();
	 * 2. file.browse(); // user cancels and does not select a file
	 * 3. file.load(); // error here
	 * </pre>
	 * 
	 * @see FileExists
	 * @see GetFile
	 * @see LoadFile
	 * @see PromptSaveAs
	 * @see SaveDataToFile
	 * @see UploadFile
	 * */
	public class BrowseForFile extends ActionEffect {
		
		public static const APPLICATION_STORAGE:String = "applicationStorage";
		public static const APPLICATION:String = "application";
		public static const DESKTOP:String = "desktop";
		public static const DOCUMENTS:String = "documents";
		public static const USER:String = "user";
		public static const ROOT:String = "root";
		
		// file reference event names
		public static const SELECT:String 		= "select";
		public static const CANCEL:String 		= "cancel";
		public static const ERROR:String 		= "error";
		
		/**
		 *  Constructor.
		 * */
		public function BrowseForFile(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = BrowseForFileInstance;
			
		}
		
		/**
		 * Prints the file URL to the console.
		 * Not available in the browser.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * Not available in the browser.
		 * */
		public var traceFileNativePath:Boolean;
		
		/**
		 * An array of File Filter objects. Optional.
		 * You can also set the fileTypes property which may be easier.
		 * @see FileFilter
		 * @see fileTypes
		 * */
		public var fileFilters:Array;
		
		/**
		 * Allow multiple files to be selected
		 * */
		[Bindable]
		public var allowMultipleSelection:Boolean;
		
		/**
		 * Reference to the selected list of files. 
		 * */
		[Bindable]
		public var fileReferenceList:FileReferenceList;
		
		/**
		 * Reference to the selected file. Use fileReferenceList if
		 * multiple files were expected. 
		 * 
		 * @see allowMultipleSelection
		 * */
		[Bindable]
		public var fileReference:FileReference;
		
		/**
		 * Reference to the selected directory.
		 * */
		[Bindable]
		public var fileObject:*;
		
		/**
		 * Array of selected files
		 * */
		[Bindable]
		public var fileList:Array;
		
		/**
		 * Browse for folder rather than file. Not supported in the browser. 
		 * */
		[Bindable]
		public var browseForFolder:Boolean;
		
		/**
		 * An ancestor of the display object generating the click event. You can most likely 
		 * set this property to the "this" or "systemManager" keyword. 
		 * Note: Browsing for a file while in the browser requires a button event to 
		 * pass the security sandbox. 
		 * */
		[Bindable]
		public function set targetAncestor(value:DisplayObject):void {
			_targetAncestor = value;
		}
		
		public function get targetAncestor():DisplayObject {
			return _targetAncestor;
		}
		private var _targetAncestor:DisplayObject;
		
		/**
		 * Flag indicating to open a file dialog. You do not set this. 
		 * */
		public var invokeBrowseDialog:Boolean;
		
		/**
		 * File filter description
		 * If this value is not set and fileTypes are set then an 2097 error is generated on some operating systems.
		 * */
		public var fileFilterDescription:String = "Files";
		
		/**
		 * Accepted file types separated by commas.
		 * For example, you can enter the following "jpg,jpeg,png,gif" for image types.
		 * @see fileFilters
		 * */
		public var fileTypes:String;
		
		/**
		 * Set to true if more than one file is selected. 
		 * */
		[Bindable]
		public var hasMultipleSelections:Boolean;
		
		/**
		 * Effect played when a single file is selected
		 * */
		public var selectionEffect:IEffect;
		
		/**
		 * Effect played when multiple files are selected
		 * */
		public var multipleSelectionEffect:IEffect;
		
		/**
		 * Effect played on the file cancel event
		 * */
		public var cancelEffect:IEffect;
		
		/**
		 * Effect played on the file browse error
		 * */
		public var errorEffect:IEffect;
		
		//---------------------------------------------
		// 
		// File results
		// 
		//---------------------------------------------
		
		/**
		 * On the desktop, File instances can be created which provide more information. 
		 * Set this to true to use FileReferences rather than Files. 
		 * */
		public var useFileReferences:Boolean;
		
		/**
		 * Reference to the File class
		 * */
		public var FileClass:Class;
		
		/**
		 * Indicates if the File class was found in the current domain.
		 * */
		public var fileClassFound:Boolean;
		
		/**
		 * When set to true no error is thrown when browse for folder is not supported.
		 * Browse for folder is not supported in the browser.
		 *  
		 * @see browseForFolder
		 * */
		public var ignoreBrowseForFolderError:Boolean;
		
		/**
		 * File. Not available in the browser. 
		 * */
		[Bindable]
		public var file:Object;
		
		/**
		 * File URL. Not available in the browser. 
		 * */
		[Bindable]
		public var fileURL:String;
		
		/**
		 * File native path. Not available in the browser. 
		 * */
		[Bindable]
		public var fileNativePath:String;
		
		/**
		 * Title for browse window dialog. Not supported in the browser.
		 * */
		[Bindable]
		public var title:String = "Browse";
		
		/**
		 * Reference to error when using attempting to open browse dialog. 
		 * */
		[Bindable]
		public var error:Error;
		
		/**
		 * Reference to error event when using attempting to open browse dialog. 
		 * */
		[Bindable]
		public var errorEvent:Event;
		
		/**
		 * Name of selected file
		 * */
		[Bindable]
		public var fileName:String;
		
		/**
		 * Number of files selected.
		 * */
		[Bindable]
		public var fileCount:uint;
		
		/**
		 * File size of the selected file or first file if multiple files selected.
		 * */
		[Bindable]
		public var fileSize:Number;
		
		/**
		 * File modification date of the selected file or first file if multiple files selected.
		 * */
		[Bindable]
		public var fileModificationDate:Date;
		
		/**
		 * File creation date of the selected file or first file if multiple files selected.
		 * */
		[Bindable]
		public var fileCreationDate:Date;
		
		/**
		 * File creator of the selected file or first file if multiple files selected.
		 * */
		[Bindable]
		public var fileCreator:String;
		
		/**
		 * File type of the selected file or first file if multiple files selected.
		 * */
		[Bindable]
		public var fileType:String;
		
		/**
		 * File data of the selected file or first file if multiple files selected.
		 * NOTE: This may be null because the file data may not set until a file.load() 
		 * or similar method is called.
		 * */
		[Bindable]
		public var fileData:ByteArray;
	}
}