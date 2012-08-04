

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.UploadFile;
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
	 * @copy UploadFile
	 * */  
	public class UploadFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function UploadFileInstance(target:Object) {
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
			
			var action:UploadFile = UploadFile(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// if we are in the browser we must set a trigger button.
				// a button event must be called for the file reference class to open 
				// a browse window
				if (!action.targetAncestor) {
					dispatchErrorEvent("The trigger button must be set to a parent display object of the target(s)");
					return;
				}
				else if (!(action.targetAncestor is DisplayObjectContainer)) {
					dispatchErrorEvent("The trigger button must be a Display Object Container");
					return;
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
			var action:UploadFile = UploadFile(effect);
			var fileFilters:Array = action.fileFilters ? action.fileFilters : [];
			var contents:Object = action.contents;			
			var fileLocation:String;
			var fileExists:Boolean;
			var fileReferenceObject:*;
			
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
			
			throw new Error("This effect is not finished");
			// Upload Support SHOULD BE MOVED TO UPLOAD FILES EFFECT
			//action.uploadURLRequest = new URLRequest();
			//action.uploadURLRequest.url = "http://www.[yourDomain].com/yourUploadHandlerScript.cfm";
			
			// create filters
			
			
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
			
			fileReferenceObject.browse(fileFilters);
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			
			waitForHandlers();
		}
		
		
		//--------------------------------------------------------------------------
		//  File Reference Handlers
		//--------------------------------------------------------------------------
		
		private function selectHandler(event:Event):void {
			var action:UploadFile = UploadFile(effect);
			
			// remove listeners
			if (action.allowMultipleSelection) {
				removeFileListeners(action.fileReferenceList);
			}
			else {
				removeFileListeners(action.fileReference);
				
			}
			
			// we only want to select the file. We don't make an assumption
			// that we are loading, uploading, downloading or saving
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			// the reference to the file or files is in the effect
			finish();
			
			// LOAD OR UPLOAD
			
			// we should subclass this to Upload File
			/*if (action.uploadURL) {
				file.upload(action.uploadURL);
			}
			else {
				action.fileReference.load();
			}*/
		}
		
		private function openHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("openHandler: name=" + file.name);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			//trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function completeHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("completeHandler: name=" + file.name);
			finish();
		}
		
		private function httpErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("httpErrorHandler: name=" + file.name);
			cancel("httpErrorHandler: name=" + file.name);
		}
		
		private function ioErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("ioErrorHandler: name=" + file.name);
			cancel("ioErrorHandler: name=" + file.name);
		}
		
		private function securityErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			//trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
			cancel("securityErrorHandler: name=" + file.name + " event=" + event.toString());
		}
		
		private function cancelHandler(event:Event):void {
			//trace("cancelHandler: " + event);
			cancel("cancelHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + event);
		}
		
		private function uploadCompleteDataHandler(event:DataEvent):void {
			//trace("uploadCompleteData: " + event);
		}
		
		//--------------------------------------------------------------------------
		//  File Loading Handlers
		//--------------------------------------------------------------------------
		
		private function fileReference_complete(event:Event):void {
			var action:UploadFile = UploadFile(effect);
			var loader:Loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			
			loader.loadBytes(action.fileReference.data);
		}
		
		public function loader_complete (event:Event) : void {
			var action:UploadFile = UploadFile(effect);
		}

		//--------------------------------------------------------------------------
		//  File Helper Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Adds file listeners
		 * */
		private function addFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.addEventListener(Event.COMPLETE, 					completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, 		httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, 						openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, 						selectHandler);
			dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler);
		}
		
		/**
		 * Removes file listeners
		 * */
		private function removeFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.CANCEL, 						cancelHandler);
			dispatcher.removeEventListener(Event.COMPLETE, 						completeHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, 		httpStatusHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, 							openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, 				progressHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler);
			dispatcher.removeEventListener(Event.SELECT, 						selectHandler);
			dispatcher.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler);
		}
		
		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		private function getTextTypeFilter():FileFilter {
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}
	}
}