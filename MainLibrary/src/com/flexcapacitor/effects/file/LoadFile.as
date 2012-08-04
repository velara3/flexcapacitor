

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.LoadFileInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import mx.effects.IEffect;
	import flash.events.ProgressEvent;
	
	
	
	/**
	 * @copy file.net.FileReference#complete
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 
	 * */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 
	 * */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * 
	 * */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	
	
	//--------------------------------------------------------------------------
	//  Loader related events
	//--------------------------------------------------------------------------
	
	
	/**
	 * 
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
	 * Given a file reference or file reference list loads the files. 
	 * You can use the BrowseForFile or similar action to get a file reference 
	 * or file reference list
	 * 
	 * When in the browser IT MUST be called within the scope of a click event. 
	 * If it is part of an event handler it must be called within the call stack of a click event.
	 * Set the targetAncestor property to the parent of the button that will trigger this event.
	 * Must not have any effects before it that have any duration.
	 * 
	 * @see BrowseForFile
	 * */
	public class LoadFile extends ActionEffect {
		
		// file reference event names
		public static const COMPLETE:String 		= "complete";
		public static const IO_ERROR:String 		= "ioError";
		public static const OPEN:String 			= "open";
		public static const PROGRESS:String 		= "progress";
		
		
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
		 * The contents of the file. Same values as the data property
		 * This is the value of the loaderInfo.contents property.
		 * @copy flash.display.LoaderInfo
		 * */
		[Bindable]
		public var contents:Object;
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * */
		public var traceFileNativePath:Boolean;
		
		private var _fileReferenceList:FileReferenceList;

		/**
		 * Reference to the selected list of files. 
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
			}
		}

		
		private var _fileReference:FileReference;

		/**
		 * Reference to the selected file. Use fileReferenceList if
		 * multiple files were expected. 
		 * 
		 * @see allowMultipleSelection
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
			}
		}

		
		/**
		 * The contents of the file. 
		 * This is the value of the loaderInfo.contents property.
		 * @copy flash.display.LoaderInfo.contents
		 * */
		[Bindable]
		public var data:Object;
		
		/**
		 * The bytes of the file. 
		 * This is the value of the loaderInfo.bytes property.
		 * @copy flash.display.LoaderInfo.bytes
		 * */
		public var byteArray:Object;
		
		/**
		 * @copy flash.display.LoaderInfo
		 * */
		public var loaderInfo:LoaderInfo;
		
		/**
		 * @copy flash.display.LoaderInfo.contentType
		 * */
		public var contentType:String;
		
		/**
		 * The bitmapData of the file.  
		 * This is the value of the Bitmap(loaderInfo.contents).bitmapData property.
		 * @copy flash.display.Bitmap.bitmapData
		 * */
		public var bitmapData:BitmapData;
		
		/**
		 * Loads the file reference raw data (byte array) with a loader. 
		 * This allows you to get and set the bitmapData when the file is an image.
		 * */
		public var loadIntoLoader:Boolean;
		
		
		//--------------------------------------------------------------------------
		//  File related effects
		//--------------------------------------------------------------------------
		
		/**
		 * Effect played on the loader complete event
		 * */
		public var completeEffect:IEffect;
		
		/**
		 * Effect played on the loader io error
		 * */
		public var ioErrorEffect:IEffect;
		
		/**
		 * Effect played on the loader open event
		 * */
		public var openEffect:IEffect;
		
		/**
		 * Effect played on the loader progress event
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
		 * Reference to the current file 
		 * */
		public var currentFile:FileReference;
		
		/**
		 * Reference to the current loader info
		 * */
		public var currentLoaderInfo:LoaderInfo;
		
		/**
		 * Reference to the current ProgressEvent
		 * */
		public var currentProgressEvent:ProgressEvent;
		
		
		/**
		 * Remove references
		 * */
		public function removeReferences(includeFileReferences:Boolean = false):void {
			
			currentFile = null;
			currentLoaderInfo = null;
			currentProgressEvent = null;
			
			if (includeFileReferences) fileReference = null;
			if (includeFileReferences) fileReferenceList = null;
			
			data = null;
			bitmapData = null;
			byteArray = null;
			contents = null;
			loaderInfo = null;
			contentType = "";
		}
	}
}