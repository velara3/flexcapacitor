

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.UploadFileInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	
	/**
	 * Opens a file dialog to select files to upload. 
	 * 
	 * NOTE: In the browser this effect MUST be called within the 
	 * bubbling of a click event. If another effect is run before this one it may 
	 * this effect may not be run in time. 
	 * If it is part of an event handler it must be called within the call stack of a click event.
	 * Set the triggerButtonParent property to a parent of the button that triggers this event.
	 * Must not have any effects before it that have any duration. 
	 * */
	public class UploadFile extends ActionEffect {
		
		public static const APPLICATION_STORAGE:String = "applicationStorage";
		public static const APPLICATION:String = "application";
		public static const DESKTOP:String = "desktop";
		public static const DOCUMENTS:String = "documents";
		public static const USER:String = "user";
		public static const ROOT:String = "root";
		
		/**
		 *  Constructor.
		 * */
		public function UploadFile(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = UploadFileInstance;
			
		}
		
		
		/**
		 * Name of selected file
		 * */
		public var fileName:String;
		
		/**
		 * The contents of the file
		 * */
		public var contents:Object;
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * */
		public var traceFileNativePath:Boolean;
		
		/**
		 * An array of File Filter objects. Optional.
		 * @see FileFilter
		 * */
		public var fileFilters:Array;
		
		/**
		 * Allow multiple files to be selected
		 * */
		public var allowMultipleSelection:Boolean;
		
		
		/**
		 * Reference to the selected list of files. 
		 * */
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
		 * An ancestor of the display object generating the click event. You can most likely 
		 * set this property to the this keyword. 
		 * Note: Browsing for a file while in the browser requires a button event to 
		 * pass the security sandbox. 
		 * */
		public function set targetAncestor(value:DisplayObjectContainer):void {
			_targetAncestor = value;
		}
		
		public function get targetAncestor():DisplayObjectContainer {
			return _targetAncestor;
		}
		private var _targetAncestor:DisplayObjectContainer;
		
		/**
		 * Flag indicating to open a file dialog. You do not set this. 
		 * */
		public var invokeBrowseDialog:Boolean;
		
	}
}