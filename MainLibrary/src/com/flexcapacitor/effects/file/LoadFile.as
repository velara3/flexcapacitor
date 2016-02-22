

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.LoadFileInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.effects.IEffect;
	
	
	
	/**
	 * Dispatched when all files have loaded and all the loaders have
	 * loaded. 
	 * */
	[Event(name="loaderTotalComplete", type="flash.events.Event")]
	
	/**
	 * Dispatched when all files have loaded. You may still be loading 
	 * additional files if you enable loadIntoLoader option. 
	 * */
	[Event(name="totalComplete", type="flash.events.Event")]
	
	/**
	 * @copy file.net.FileReference#complete
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @copy file.net.FileReference#ioError
	 * */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * @copy file.net.FileReference#open
	 * */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * @copy file.net.FileReference#progress
	 * */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	
	
	//--------------------------------------------------------------------------
	//  Loader related events
	//--------------------------------------------------------------------------
	
	
	/**
	 * @copy flash.events.AsyncErrorEvent#asyncError
	 * */
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	
	/**
	 * 
	 * */
	[Event(name="init", type="flash.events.Event")]
	
	/**
	 * 
	 * */
	[Event(name="loaderIOError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 
	 * */
	[Event(name="loaderComplete", type="flash.events.Event")]
	
	/**
	 * 
	 * */
	[Event(name="loaderOpen", type="flash.events.Event")]
	
	/**
	 * 
	 * */
	[Event(name="loaderProgress", type="flash.events.ProgressEvent")]
	
	/**
	 * 
	 * */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * 
	 * */
	[Event(name="unload", type="flash.events.Event")]
	
	/**
	 * Given a file reference, a file reference list or an array of files, it loads those files. 
	 * You can use the BrowseForFile or similar action to select a file reference or file reference list.
	 * In AIR you can pass in an array of file objects into the files array property. 
	 * To get the bitmapData property you need to enable loadIntoLoader and listen to the
	 * loaderComplete event rather than the complete event.<br/><br/>
	 * 
	 * It is a good idea to call loadFile.removeReferences() on 
	 * totalComplete or loaderTotalComplete if you do not plan to save references to the files.<br/><br/>
	 * 
	 * Note: This class is in beta.<br/><br/>
	 * 
	 * It is a good idea to call removeReferences() when you have finished using this class.
	 * This removes any references to the previous loaded or referenced files<br/><br/>
	 * 
	 * The loadWithLoader option is used to convert the bytes from a file into a bitmap object.
	 * It may be moved to another class. <br/><br/>
	 * 
	 * When in the browser IT MUST be called within the scope of a click event. 
	 * If it is part of an event handler it must be called within the call stack of a click event.
	 * Set the targetAncestor property to the parent of the button that will trigger this event.
	 * Must not have any effects before it that have any duration.<br/><br/>
	 * 
	 * How to use:  <br/>
	 * 1. Use browse for file effect and let the user select one or more files. <br/>
	 * 2. Use LoadFile effect to load one or more files in using the fileReference, fileReferenceList or filesArray property: 
<pre>
&lt;file:BrowseForFile id="browseForFile"
					fileTypes="png,jpg,jpeg,gif"
					targetAncestor="{this}"
					allowMultipleSelection="false">
	&lt;file:selectionEffect>
		&lt;file:LoadFile id="loadFile"  
					   loadIntoLoader="true"
					   fileReference="{browseForFile.fileReference}"
					   complete="trace('file loaded')"
					   totalComplete="trace('all files loaded')"/>
					   loaderTotalComplete="trace('all loaders have loaded');loadFile.removeReferences();"/>
	&lt;/file:selectionEffect>
&lt;/file:BrowseForFile>
 </pre>
 * To allow multiple selection
<pre>
&lt;file:BrowseForFile id="browseForFile"
					fileTypes="png,jpg,jpeg,gif"
					targetAncestor="{this}"
					allowMultipleSelection="true">
	&lt;file:selectionEffect>
		&lt;file:LoadFile id="loadFile"  
					   fileReference="{browseForFile.fileReferenceList}"
					   complete="trace('file loaded')"
					   totalComplete="trace('all files loaded');loadFile.removeReferences();"/>
	&lt;/file:selectionEffect>
&lt;/file:BrowseForFile>
 </pre>
	 * You can also manually pass in an array of files into the filesArray property 
	 * and then call loadFile.play():
<pre>
&lt;file:LoadFile id="loadFile"  
		   loadIntoLoader="true"
		   filesArray="{[file1, file2, file3]}"
		   complete="loadFile_completeHandler(event)" 
		   totalComplete="trace('all files loaded')"
		   loaderTotalComplete="trace('all loaders have loaded');loadFile.removeReferences();"/>
&lt;/file:selectionEffect>
 

// File load complete
var myFiles:Array = [];

protected function loadFile_completeHandler(event:Event):void {
	var data:Object = new Object();
	data.file = loadFile.currentFileReference;
	data.name = loadFile.currentFileReference.name;
	data.bitmapData = loadFile.bitmapData;
	data.byteArray = loadFile.data;
	data.dataAsString = loadFile.dataAsString;
	data.contentType = loadFile.loaderContentType;
	myFiles.push(data);
	
	// if multiple files pass in the file reference to get the string value
	var value:String = loadFile.fileStringDictionary[loadFile.currentFileReference];
}
</pre>

	 * 
	 * @see BrowseForFile
	 * @see GetFile
	 * @see LoadFile
	 * @see PromptSaveAs
	 * @see SaveDataToFile
	 * @see UploadFile
	 * */
	public class LoadFile extends ActionEffect {
		
		// file reference event names
		public static const LOADER_TOTAL_COMPLETE:String 	= "loaderTotalComplete";
		public static const TOTAL_COMPLETE:String 	= "totalComplete";
		public static const COMPLETE:String 		= "complete";
		public static const IO_ERROR:String 		= "ioError";
		public static const OPEN:String 			= "open";
		public static const PROGRESS:String 		= "progress";
		public static const ERROR:String			= "error";
		
		
		
		// loader event names
		public static const ASYNC_ERROR:String 		= "asyncError";
		public static const LOADER_COMPLETE:String 	= "loaderComplete";
		public static const INIT:String 			= "init";
		public static const LOADER_IO_ERROR:String 	= "loaderIOError";
		public static const LOADER_OPEN:String 		= "loaderOpen";
		public static const LOADER_PROGRESS:String 	= "loaderProgress";
		public static const SECURITY_ERROR:String 	= "securityError";
		public static const UNLOAD:String 			= "unload";
		
		/**
		 *  Constructor.
		 * */
		public function LoadFile(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = LoadFileInstance;
			
		}
		
		/**
		 * The data of the file.
		 * @copy flash.net.FileReference.data
		 * @see loaderData
		 * @see dataAsString
		 * */
		[Bindable]
		public var data:ByteArray;
		
		/**
		 * The data of the file converted to a string
		 * @copy flash.net.FileReference.data
		 * @see data
		 * @see loaderData
		 * */
		[Bindable]
		public var dataAsString:String;
		
		/**
		 * @copy flash.net.FileReference.type
		 * @see loaderContentType
		 * */
		public var type:String;
		
		/**
		 * Prints the file URL to the console.
		 * Available on AIR.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * Available on AIR.
		 * */
		public var traceFileNativePath:Boolean;
		
		private var _fileReferenceList:FileReferenceList;

		/**
		 * Reference to the selected list of files. You 
		 * can set this to load these files.
		 * 
		 * @see #fileReference
		 * @see #filesArray
		 * */
		[Bindable]
		public function get fileReferenceList():FileReferenceList {
			return _fileReferenceList;
		}

		/**
		 * @private
		 */
		public function set fileReferenceList(value:FileReferenceList):void {
			_fileReferenceList = value;
			
			if (value) {
				_fileReference = null;
				_filesArray = null;
			}
		}
		
		private var _fileReference:FileReference;

		/**
		 * Reference to the selected file. Use fileReferenceList if
		 * multiple files were expected. 
		 * 
		 * @see #fileReferenceList
		 * @see #filesArray
		 * */
		[Bindable]
		public function get fileReference():FileReference {
			return _fileReference;
		}

		/**
		 * @private
		 */
		public function set fileReference(value:FileReference):void {
			_fileReference = value;
			
			if (value) {
				_fileReferenceList = null;
				_filesArray = null;
			}
		}

		private var _filesArray:Array;

		/**
		 * Array of selected files. You can set this an array of files to load.
		 * Use fileReference to load a single file, fileReferenceList if you 
		 * have browsed for multiple files or this property if you 
		 * have selected multiple files by some other means.  
		 * 
		 * @see #fileReference
		 * @see #fileReferenceList
		 * */
		[Bindable]
		public function get filesArray():Array {
			return _filesArray;
		}

		/**
		 * @private
		 */
		public function set filesArray(value:Array):void {
			_filesArray = value;
			
			if (value) {
				_fileReference = null;
				_fileReferenceList = null;
			}
		}

		/**
		 * File name of the last file loaded
		 * */
		[Bindable]
		public var fileName:String;
		
		/**
		 * Number of files.  
		 * */
		[Bindable]
		public var numOfFiles:int;
		
		/**
		 * Total number of files processed.
		 * */
		[Bindable]
		public var totalFilesProcessed:int;
		
		/**
		 * Total number of loaders processed.
		 * */
		[Bindable]
		public var totalLoadersProcessed:int;
		
		//--------------------------------------------------------------------------
		//  Loader related properties
		//--------------------------------------------------------------------------
		
		
		/**
		 * Loads the file reference raw data (byte array) with a loader. 
		 * This allows you to get and set the bitmapData when the file is an image.
		 * */
		public var loadIntoLoader:Boolean;
		
		/**
		 * This is the value of the loaderInfo.contents property.
		 * @copy flash.display.LoaderInfo.contents
		 * @see #data
		 * @see #dataAsString
		 * */
		[Bindable]
		public var loaderContents:Object;
		
		/**
		 * The bytes of the file. 
		 * This is the value of the loaderInfo.bytes property.
		 * @copy flash.display.LoaderInfo.bytes
		 * */
		[Bindable]
		public var loaderByteArray:ByteArray;
		
		/**
		 * @copy flash.display.LoaderInfo
		 * */
		public var loaderInfo:LoaderInfo;
		
		/**
		 * @copy flash.display.LoaderInfo.contentType
		 * */
		public var loaderContentType:String;
		
		/**
		 * The bitmapData of the file. You must enable loadIntoLoader for this to be set. 
		 * This is the value of the Bitmap(loaderInfo.contents).bitmapData property.
		 * @copy flash.display.Bitmap.bitmapData
		 * @see #loadIntoLoader
		 * */
		[Bindable]
		public var bitmapData:BitmapData;
		
		/**
		 * When using loaders the file related to the loaders are populated here.
		 * This is only populated when loadIntoLoader is true. 
		 * */
		public var filesDictionary:Dictionary = new Dictionary(true);
		
		//--------------------------------------------------------------------------
		//  File related effects
		//--------------------------------------------------------------------------
		
		/**
		 * Effect played when all files have loaded. 
		 * The files may still be loading after this effect is played if you enable loadIntoLoader
		 * @see #loadIntoLoader
		 * @see #totalCompleteEffect
		 * @see #completeEffect
		 * */
		public var loaderTotalCompleteEffect:IEffect;
		
		/**
		 * Effect played when all files have loaded. 
		 * The files may still be loading after this effect is played if you enable loadIntoLoader
		 * @see #loadIntoLoader
		 * @see #loaderTotalCompleteEffect
		 * @see #completeEffect
		 * */
		public var totalCompleteEffect:IEffect;
		
		/**
		 * Effect played on a file load complete event
		 * 
		 * @see #loadIntoLoader
		 * @see #totalCompleteEffect
		 * @see #loaderCompleteEffect
		 * */
		public var completeEffect:IEffect;
		
		/**
		 * Effect played on a file io error
		 * */
		public var ioErrorEffect:IEffect;
		
		/**
		 * Effect played on a file open event
		 * */
		public var openEffect:IEffect;
		
		/**
		 * Effect played on a file progress event
		 * */
		public var progressEffect:IEffect;
		
		//--------------------------------------------------------------------------
		//  Loader related effects
		//--------------------------------------------------------------------------
		
		/**
		 * Effect played on the loader async error
		 * */
		public var asyncErrorEffect:IEffect;
		
		/**
		 * Effect played on the loader complete event
		 * */
		public var loaderCompleteEffect:IEffect;
		
		/**
		 * Effect played on the loader init event
		 * */
		public var initEffect:IEffect;
		
		/**
		 * Effect played on the loader io error
		 * */
		public var loaderIOErrorEffect:IEffect;
		
		/**
		 * Effect played on the loader open event
		 * */
		public var loaderOpenEffect:IEffect;
		
		/**
		 * Effect played on the loader progress event
		 * */
		public var loaderProgressEffect:IEffect;
		
		/**
		 * Effect played on the loader security error
		 * */
		public var securityErrorEffect:IEffect;
		
		/**
		 * Effect played on the loader unload event
		 * */
		public var unloadEffect:IEffect;
		
		/**
		 * Effect played when an error occurs on file load
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * Reference to the current file as the files are loading. <br/><br/>
		 * 
		 * THIS CHANGES FREQUENTLY. If multiple files are loaded
		 * it will be set to the last one after all of them
		 * have loaded. 
		 * */
		[Bindable]
		public var currentFileReference:FileReference;
		
		/**
		 * Reference to the current file 
		 * */
		[Bindable]
		public var currentFileReferenceList:FileReferenceList;
		
		/**
		 * Reference to the current loader info
		 * */
		public var currentLoaderInfo:LoaderInfo;
		
		/**
		 * Reference to the current ProgressEvent
		 * */
		public var currentProgressEvent:ProgressEvent;
		
		/**
		 * Error event that may occur when trying to load a file
		 * */
		public var error:Error;
		
		/**
		 * Removes references after the last file has loaded and events have
		 * been dispatched and any effects have run. Default is false.
		 * 
		 * You should call removeReferences manually or enable this to help clean up references.
		 * */
		public var removeReferencesOnComplete:Boolean;
		
		/**
		 * References to the string data of the file 
		 * */
		public var fileStringDictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Remove references
		 * */
		public function removeReferences(includeFileReferences:Boolean = false):void {
			
			currentFileReference = null;
			currentFileReferenceList = null;
			currentLoaderInfo = null;
			currentProgressEvent = null;
			error = null;
			
			for each(var key:Object in fileStringDictionary) {
				fileStringDictionary[key] = null;
				delete fileStringDictionary[key];
			}
			
			for each(key in filesDictionary) {
				filesDictionary[key] = null;
				delete filesDictionary[key];
			}
			
			totalFilesProcessed = 0;
			totalLoadersProcessed = 0;
			
			
			if (includeFileReferences) { 
				fileReference = null;
				fileReferenceList = null;
				filesArray = [];
			}
			
			data = null;
			dataAsString = "";
			bitmapData = null;
			loaderContents = null;
			loaderInfo = null;
			loaderContentType = "";
			loaderByteArray = null;
			fileName = null;
		}
		
		/**
		 * Get file reference from loader
		 * */
		public function getFileFromLoader(loader:Loader):FileReference {
			return filesDictionary[loader];
		}
		
		/**
		 * Get string data from reference from loader
		 * */
		public function getStringFromFile(fileReference:FileReference):String {
			
			if (!(fileReference in fileStringDictionary)) {
				fileStringDictionary[fileReference] = fileReference.data.readUTFBytes(fileReference.data.length);
			}
			
			return fileStringDictionary[fileReference];
		}
	}
}