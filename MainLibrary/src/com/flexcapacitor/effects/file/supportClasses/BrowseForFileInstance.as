

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.BrowseForFile;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.system.ApplicationDomain;
	
	import mx.managers.SystemManager;
	
	
	
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
			var applicationDomain:ApplicationDomain;
			var classDefinition:String = "flash.filesystem.File";
			var browseForFolder:Boolean = action.browseForFolder;
			var FileClass:Object = action.FileClass;
			var fileClassFound:Boolean = FileClass!=null;
			
			// get reference to flash.filesystem.File - not supported in the browser
			if (!FileClass) {
				applicationDomain = SystemManager.getSWFRoot(this).loaderInfo.applicationDomain;
				fileClassFound = applicationDomain.hasDefinition(classDefinition); 
				action.fileClassFound = fileClassFound;
				
				if (fileClassFound) {
					FileClass = applicationDomain.getDefinition(classDefinition);
					action.FileClass = FileClass as Class;
				}
			}
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// if we are in the browser (not AIR app) we must set a trigger button.
				// a button event must be called for the file reference class to open 
				// a browse window
				if (!action.targetAncestor && !fileClassFound) {
					dispatchErrorEvent("The target ancestor property must be set to a parent display object of the target(s). You could probably set it to '{this}' and it would work.");
				}
				else if (!(action.targetAncestor is DisplayObjectContainer) && !fileClassFound) {
					dispatchErrorEvent("The target ancestor property must be a Display Object Container");
				}
				
				if (browseForFolder) {
					if (!fileClassFound && !action.ignoreBrowseForFolderError) {
						dispatchErrorEvent("Browse for folder is not supported on this device.");
					}
					else if (action.useFileReferences && !action.ignoreBrowseForFolderError) {
						dispatchErrorEvent("Browse for folder is not supported when use file references property is enabled.");
					}
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
			var acceptedFileTypes:Array = action.fileTypes ? action.fileTypes.split(",") : null;
			var title:String = action.title ? action.title : "";
			var fileClassFound:Boolean = action.fileClassFound;
			var browseForFolder:Boolean = action.browseForFolder;
			var FileClass:Class = action.FileClass;
			var fileReferenceObject:*;
			var fileFilter:FileFilter;
			var filtersString:String;
			var fileLocation:String;
			var fileExists:Boolean;
			var length:int;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// prevent this from opening two dialogs next time
			action.targetAncestor.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			if (!action.invokeBrowseDialog) {
				// this means... the event listener was not removed - we shouldn't be here
				dispatchErrorEvent("The browse for file event handler was not previously removed.");
				return;
			}
			
			// reset browse dialog flag
			action.invokeBrowseDialog = false;
			
			// check for manually entered file filters and add to existing filters array
			if (acceptedFileTypes) {
				filtersString = "*." + acceptedFileTypes.join(";*.");
				
				fileFilter = new FileFilter(fileFilterDescription, filtersString);
				fileFilters.push(fileFilter);
			}
			
			// Use File rather than FileReference if available
			// check if the File class is found
			if (fileClassFound && !action.useFileReferences) {
				
				fileReferenceObject = action.fileReference = new FileClass();
				addFileListeners(fileReferenceObject);
			
				try {
					
					if (browseForFolder) {
						fileReferenceObject.browseForDirectory(title);
					}
					else if (action.allowMultipleSelection) {
						fileReferenceObject.browseForOpenMultiple(title, fileFilters);
					}
					else {
						fileReferenceObject.browseForOpen(title, fileFilters);
					}
				}
				catch (error:Error) {
				   // trace("Failed:", error.message);
				   // traceMessage("BrowseForFile:" + error.message);
					
					action.error = error;
					
					// dispatch events and run effects
					if (action.hasEventListener(BrowseForFile.ERROR)) {
						dispatchActionEvent(new Event(BrowseForFile.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
				}
			}
			else {
				
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
				
				
				// if you get an error here enter a file filter description such as "Images" or "Files"
				// SEE action.fileFilterDescription
				// add filters and open
				
				try {
					
					fileReferenceObject.browse(fileFilters);
				}
				catch (error:Error) {
				   // trace("Failed:", error.message);
				   // traceMessage("BrowseForFile:" + error.message);
					
					action.error = error;
					
					// dispatch events and run effects
					if (action.hasEventListener(BrowseForFile.ERROR)) {
						dispatchActionEvent(new Event(BrowseForFile.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
				}
			}
			

			
			
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
			var fileReferenceList:FileReferenceList = action.fileReferenceList;
			var fileReference:FileReference = action.fileReference;
			var multipleSelection:Boolean = action.allowMultipleSelection;
			var fileObject:Object = action.fileObject;
			var fileClassFound:Boolean = action.fileClassFound;
			var useFileReferences:Boolean = action.useFileReferences;
			var fileList:Array;
			var fileCount:uint;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (fileClassFound && !useFileReferences) {
				
				if (action.browseForFolder) {
					action.fileReference = fileReference;
					action.file = fileReference as Object;
					removeFileListeners(fileReference);
				}
				else if (multipleSelection) {
					
					// get selected file or first file if multiple selections
					removeFileListeners(fileReference);
					fileList = Object(event).files; // FileListEvent(event)
					fileReference = fileList[0];
					action.fileReference = fileReference;
					action.file = fileReference as Object;
					fileCount = fileList.length;
					
					if (fileCount>1) {
						action.hasMultipleSelections = true;
					}
				}
				else {
					action.fileReference = fileReference;
					action.file = fileReference as Object;
					removeFileListeners(fileReference);
				}
			}
			else {
				
				if (multipleSelection) {
					
					// get selected file or first file if multiple selections
					removeFileListeners(fileReferenceList);
					fileList = fileReferenceList.fileList; // FileReferenceList
					fileReference = fileList[0];
					fileCount = fileList.length;
					action.fileReference = fileReference;
					action.file = fileReference as Object;
					
					if (fileCount>1) {
						action.hasMultipleSelections = true;
					}
				}
				else {
					action.fileReference = fileReference;
					action.file = fileReference as Object;
					removeFileListeners(fileReference);
				}
			}
			
			
			// set some file properties
			// NOTE: file.data is null in the browser until a method like file.load() is called
			action.fileData = fileReference.data;
			action.fileName = fileReference.name;
			action.fileSize = fileReference.size;
			action.fileModificationDate = fileReference.modificationDate;
			action.fileCreationDate = fileReference.creationDate;
			action.fileCreator = fileReference.creator;
			action.fileType = fileReference.type;
			action.fileList = multipleSelection ? fileList : [fileReference];
			action.fileCount = multipleSelection ? fileCount : 1;
			
			if ("url" in fileReference) {
				action.fileURL = Object(fileReference).url;
			}
			if ("nativePath" in fileReference) {
				action.fileNativePath = Object(fileReference).nativePath;
			}
			
			// file paths are not available in the fileReference class
			// need to check if on the desktop and add support
			if (fileClassFound && !useFileReferences && action.traceFileURL) {
				traceMessage(action.className + " File URL: " + Object(fileReference).url);
			}
			
			// file paths are not available in the fileReference class
			if (fileClassFound && !useFileReferences && action.traceFileNativePath) {
				traceMessage(action.className + " File Native Path: " + Object(fileReference).nativePath);
			}
			
			// dispatch events and run effects
			if (action.hasEventListener(BrowseForFile.SELECT)) {
				dispatchActionEvent(new Event(BrowseForFile.SELECT));
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
			
			// we only want to select the file or folder. We don't make an assumption
			// of what we are doing with that file. 
			// whether it is loading, uploading, downloading or saving
			finish();
			
			// USE THE LOAD FILE ACTION TO LOAD THE FILE
			
			
			// LOAD OR UPLOAD
			
			// we could subclass this to Upload File
			/*if (action.uploadURL) {
				file.upload(action.uploadURL);
			}*/
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function httpErrorHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.errorEvent = event;
			
			// dispatch events and run effects
			if (action.hasEventListener(BrowseForFile.ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
					
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function ioErrorHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.errorEvent = event;
			
			// dispatch events and run effects
			if (action.hasEventListener(BrowseForFile.ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * Not sure if needed - up for removal
		 * */
		private function securityErrorHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.errorEvent = event;
			
			// dispatch events and run effects
			if (action.hasEventListener(BrowseForFile.ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		/**
		 * Cancel button was pressed on the browse dialog
		 * */
		private function cancelHandler(event:Event):void {
			var action:BrowseForFile = BrowseForFile(effect);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.hasEventListener(BrowseForFile.CANCEL)) {
				dispatchActionEvent(event);
			}
			
			if (action.cancelEffect) {
				playEffect(action.cancelEffect);
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
		 * Adds file listeners
		 * */
		private function addFileListeners(dispatcher:Object):void {
			dispatcher.addEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, 						selectHandler);
			dispatcher.addEventListener("selectMultiple", 					selectHandler);
			//dispatcher.addEventListener(FileListEvent.SELECT_MULTIPLE, 		selectHandler);
			//dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler);
		}
		
		/**
		 * Removes file listeners
		 * */
		private function removeFileListeners(dispatcher:Object):void {
			dispatcher.removeEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.removeEventListener(Event.SELECT, 						selectHandler);
			dispatcher.removeEventListener("selectMultiple",			 		selectHandler);
			//dispatcher.removeEventListener(FileListEvent.SELECT_MULTIPLE, 		selectHandler);
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