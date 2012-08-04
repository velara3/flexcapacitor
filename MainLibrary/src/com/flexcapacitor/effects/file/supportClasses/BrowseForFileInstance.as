

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.BrowseForFile;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	
	
	/**
	 * @copy BrowseForFile
	 * */  
	public class BrowseForFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function BrowseForFileInstance(target:Object) {
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
			super.play();// Dispatch an effectStart event
			
			var action:BrowseForFile = BrowseForFile(effect);
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// if we are in the browser we must set a trigger button.
				// a button event must be called for the file reference class to open 
				// a browse window
				if (!action.targetAncestor) {
					dispatchErrorEvent("The trigger button must be set to a parent display object of the target(s). You could probably set it to '{this}' and it would work.");
				}
				else if (!(action.targetAncestor is DisplayObjectContainer)) {
					dispatchErrorEvent("The trigger button must be a Display Object Container");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.invokeBrowseDialog = true;
			
			// add a click event listener to the parent 
			// so we can attach a click event listeners to the child 
			// while the event is bubbling.
			// we do this to get around a security restriction that prevents dialogs
			// from being open unless triggered by a click event
			action.targetAncestor.addEventListener(MouseEvent.CLICK, buttonHandler);
			
			// reset multiple selections flag
			action.hasMultipleSelections = false;
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			// NOTE: If nothing is happening make sure that the button or *buttons* 
			// that are triggering this event have the targetAncestor as their ancestor
			// and that there is no pause or duration between the click event and this effect
			// IE no other effect that has a duration can run before this one
			waitForHandlers();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handles the event tied to opening a file dialog. 
		 * */
		public function buttonHandler(event:MouseEvent):void {
			var action:BrowseForFile = BrowseForFile(effect);
			var fileFilters:Array = action.fileFilters ? action.fileFilters : [];
			var fileFilterDescription:String = action.fileFilterDescription || " ";
			var acceptedFileTypes:Array = action.fileTypes ? action.fileTypes.split(","):null;
			var fileLocation:String;
			var fileExists:Boolean;
			var fileReferenceObject:*; // could be file reference type? 
			var fileFilter:FileFilter;
			var filtersString:String;
			var length:int;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// prevent this from opening two dialogs next time
			action.targetAncestor.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			if (!action.invokeBrowseDialog) {
				// this means... the event listener was not removed
				dispatchErrorEvent("The browse for file event handler was not previously removed.");
				return;
			}
			
			// reset browse dialog flag
			action.invokeBrowseDialog = false;
			
			// Upload Support SHOULD BE MOVED TO UPLOAD FILES EFFECT
			//action.uploadURLRequest = new URLRequest();
			//action.uploadURLRequest.url = "http://www.[yourDomain].com/yourUploadHandlerScript.cfm";
			
			
			// FOR SELECTING A FILE WE MAY NOT NEED ALL THE LISTENERS WE ARE ADDING
			// add listeners
			if (action.allowMultipleSelection) {
				fileReferenceObject = action.fileReferenceList = new FileReferenceList();
				addFileListeners(fileReferenceObject);
			}
			else {
				fileReferenceObject = action.fileReference = new FileReference();
				addFileListeners(fileReferenceObject);
			}
			
			// check for manually entered file filters and add to existing filters array
			if (acceptedFileTypes) {
				filtersString = acceptedFileTypes.join(";*.");
				
				fileFilter = new FileFilter(fileFilterDescription, filtersString);
				fileFilters.push(fileFilter);
			}
			
			// if you get an error here enter a file filter description such as "Images" or "Files"
			// SEE action.fileFilterDescription
			// add filters and open
			fileReferenceObject.browse(fileFilters);
			
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			waitForHandlers();
		}
		
		
		//--------------------------------------------------------------------------
		//  File Reference Handlers
		//--------------------------------------------------------------------------
		
		protected function selectHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			var files:FileReferenceList = action.fileReferenceList;
			var file:FileReference = action.fileReference;
			var multipleSelection:Boolean = action.allowMultipleSelection;
			var fileList:Array;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// get selected file or first file if multiple selections
			if (multipleSelection) {
				removeFileListeners(files);
				fileList = files.fileList;
				file = fileList[0];
				
				if (fileList.length>1) {
					action.hasMultipleSelections = true;
				}
			}
			else {
				file = action.fileReference;
				removeFileListeners(file);
			}
			
			// set some file properties
			// NOTE: file.data is null until a method like file.load() is called
			action.fileData = file.data;
			action.fileName = file.name;
			action.fileSize = file.size;
			action.fileModificationDate = file.modificationDate;
			action.fileCreationDate = file.creationDate;
			action.fileCreator = file.creator;
			action.fileType = file.type;
			
			
			// up for removal
			// file paths are not available in the fileReference class
			if (action.traceFileURL) {
				//trace(action.className + " File URL: " + file.url);
			}
			
			// file paths are not available in the fileReference class
			if (action.traceFileNativePath) {
				//trace(action.className + " File Native Path: " + file.nativePath);
			}
			
			// dispatch events and run effects
			if (action.hasEventListener(BrowseForFile.SELECT)) {
				action.dispatchEvent(event);
			}
			
			if (multipleSelection) {
				if (action.multipleSelectionEffect) {
					playEffect(action.multipleSelectionEffect);
				}
			}
			else {
				if (action.selectionEffect) {
					playEffect(action.selectionEffect);
				}
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// we only want to select the file. We don't make an assumption
			// that we are loading, uploading, downloading or saving
			finish();
			
			// USE THE LOAD FILE ACTION TO LOAD THE FILE
			
			
			// LOAD OR UPLOAD
			
			// we should subclass this to Upload File
			/*if (action.uploadURL) {
				file.upload(action.uploadURL);
			}*/
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function httpErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("httpErrorHandler: name=" + file.name);
			cancel("httpErrorHandler: name=" + file.name);
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function ioErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("ioErrorHandler: name=" + file.name);
			cancel("ioErrorHandler: name=" + file.name);
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function securityErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
			cancel("securityErrorHandler: name=" + file.name + " event=" + event.toString());
		}
		
		/**
		 * Cancel button was pressed on the browse dialog
		 * */
		private function cancelHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			
			
			if (action.hasEventListener(BrowseForFile.CANCEL)) {
				action.dispatchEvent(event);
			}
			
			if (action.cancelEffect) {
				playEffect(action.cancelEffect);
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// If cancel is pressed on the browser dialog then cancel 
			// out of an effect sequence (if part of one).
			if (action.cancelOnDismiss) {
				cancel("cancelHandler: " + event);
			}
			else {
				finish();
			}
			
		}

		//--------------------------------------------------------------------------
		//  File Helper Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Adds file listeners
		 * */
		private function addFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, 						selectHandler);
			//dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler);
		}
		
		/**
		 * Removes file listeners
		 * */
		private function removeFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.removeEventListener(Event.SELECT, 						selectHandler);
			//dispatcher.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler);
		}
		
		/**
		 * Helper methods - up for removal
		 * */
		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		/**
		 * Helper methods - up for removal
		 * */
		private function getTextTypeFilter():FileFilter {
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}
	}
}