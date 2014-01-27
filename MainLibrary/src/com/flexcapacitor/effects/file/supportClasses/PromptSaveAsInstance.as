

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.PromptSaveAs;
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
	
	
	
	/**
	 * @copy PromptSaveAs
	 * */
	public class PromptSaveAsInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function PromptSaveAsInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:PromptSaveAs = PromptSaveAs(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// if we are in the browser we must set a trigger button.
			// a button event must be called for the file reference class to open 
			// a browse window
			if (validate) {
				if (!action.targetAncestor) {
					errorMessage = "The trigger button must be set to an ancestor of the target(s)";
					dispatchErrorEvent(errorMessage);
					return;
				}
				else if (!(action.targetAncestor is DisplayObjectContainer)) {
					dispatchErrorEvent("The trigger button must be a Display Object Container");
					return;
				}
				else if (!action.data && action.throwErrorOnNoData) {
					dispatchErrorEvent("There is no data to save");
					return;
				}
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.invokeSaveAsDialog = true;
			
			// add a click event listener to the parent 
			// so we can attach a click event listeners to the child 
			// while the event is bubbling.
			// we do this to get around a security restriction that prevents dialogs
			// from being open unless triggered by a click event
			action.targetAncestor.addEventListener(MouseEvent.CLICK, buttonHandler);
			
			// Place your code in the button handler event
			
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
			var action:PromptSaveAs = PromptSaveAs(effect);
			var data:Object = action.data;
			var fileName:String = action.fileName==null ? "" : action.fileName;
			fileName = fileName.indexOf(".")==-1 && action.fileExtension ? fileName + "." + action.fileExtension : fileName;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// prevent this from opening two dialogs next time
			action.targetAncestor.removeEventListener(MouseEvent.CLICK, buttonHandler);
			
			if (!action.invokeSaveAsDialog) {
				// this means... the event listener was not removed
				dispatchErrorEvent("The browse for file event handler was not previously removed.");
				return;
			}
			
			// reset browse dialog flag
			action.invokeSaveAsDialog = false;
			
			
			// FOR SAVING A FILE (save as) WE MAY NOT NEED ALL THE LISTENERS WE ARE ADDING
			// add listeners
			action.fileReference = new FileReference();
			addFileListeners(action.fileReference);
			
			action.fileReference.save(action.data, fileName);
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			waitForHandlers();
		}
		
		
		//--------------------------------------------------------------------------
		//  File Reference Handlers
		//--------------------------------------------------------------------------
		
		/**
		 * Handler when file has been saved
		 * */
		private function selectHandler(event:Event):void {
			var action:PromptSaveAs = PromptSaveAs(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// remove listeners
			removeFileListeners(action.fileReference);
			
			// dispatch events and run effects
			if (action.hasEventListener(PromptSaveAs.SAVE)) {
				action.dispatchEvent(event);
			}
			
			if (action.saveEffect) {
				playEffect(action.saveEffect);
			}
		
			// the reference to the file or files is in the effect
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		
		/**
		 * Cancel button was pressed on the browse dialog
		 * */
		private function cancelHandler(event:Event):void {
			var action:PromptSaveAs = PromptSaveAs(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// remove listeners
			removeFileListeners(action.fileReference);
			
			if (action.hasEventListener(PromptSaveAs.CANCEL)) {
				action.dispatchEvent(event);
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
		//  File Reference Handlers - candidates for removal
		//--------------------------------------------------------------------------
		
		
		/**
		 * 
		 * */
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
			var action:PromptSaveAs = PromptSaveAs(effect);
			var loader:Loader = new Loader();
			//trace("fileReference_complete: " + event);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			
			loader.loadBytes(action.fileReference.data);
		}
		
		public function loader_complete (event:Event) : void {
			var action:PromptSaveAs = PromptSaveAs(effect);
		}

		//--------------------------------------------------------------------------
		//  File Helper Methods
		//--------------------------------------------------------------------------
		
		/**
		 * Adds file listeners
		 * */
		private function addFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, 						cancelHandler, false, 0, true);
			dispatcher.addEventListener(Event.COMPLETE, 					completeHandler, false, 0, true);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, 		httpStatusHandler, false, 0, true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.OPEN, 						openHandler, false, 0, true);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			progressHandler, false, 0, true);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.SELECT, 						selectHandler, false, 0, true);
			dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,		uploadCompleteDataHandler, false, 0, true);
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