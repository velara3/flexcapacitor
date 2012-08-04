

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.PromptSaveAsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	
	
	/**
	 * Opens a native Save as dialog to save data to a file. This effect MUST be called within the 
	 * bubbling of a click event. If another effect is run before this one
	 * this effect may not be run in time. 
	 * If it is part of an event handler it must be called within the call stack of a click event.
	 * Set the triggerButtonParent property to the parent a container of the button that will 
	 * trigger this event.
	 * Must not have any effects before it that have any duration. 
	 * */
	public class PromptSaveAs extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function PromptSaveAs(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = PromptSaveAsInstance;
			
		}
		
		
		/**
		 * Suggested file name
		 * */
		public var fileName:String;
		
		/**
		 * @copy FileReference#save()
		 * */
		public var data:Object;
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * */
		public var traceFileNativePath:Boolean;
		
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
		 * Flag indicating to open a save as file dialog. You do not set this. 
		 * */
		public var invokeSaveAsDialog:Boolean;
		
		/**
		 * Throws an error if data is null
		 * */
		public var throwErrorOnNoData:Boolean = true;
		
		/**
		 * File extension. 
		 * */
		public var fileExtension:String = "txt";
		
	}
}