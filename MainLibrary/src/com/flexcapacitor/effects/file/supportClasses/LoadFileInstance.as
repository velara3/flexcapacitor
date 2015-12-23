

package com.flexcapacitor.effects.file.supportClasses {
	import com.flexcapacitor.effects.file.LoadFile;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	
	/**
	 * @copy LoadFile
	 * */
	public class LoadFileInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function LoadFileInstance(target:Object) {
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
			
			var action:LoadFile = LoadFile(effect);
			var fileReferenceList:FileReferenceList = action.fileReferenceList;
			var fileReference:FileReference = action.fileReference;
			var filesArray:Array = action.filesArray;

			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (fileReference==null && fileReferenceList==null && filesArray==null) {
					dispatchErrorEvent("The file reference, file reference list or filesArray is not set to any files");
				}
				
				if (fileReference) {
					// in some cases the file was never selected so we have a file object with no file selected
					// in other words the user was shown a list of files and selected one but then clicked 
					// cancel on the browse for file dialog window
					// we should handle this better but it could also be handled in the browse for file effect
					// by using the file was selected event or effect
					try {
						var test:String = fileReference.name;
					}
					catch(test:Error) {
						//dispatchErrorEvent("A valid file was never selected");
						// trace("Failed:", error.message);
						// traceMessage("BrowseForFile:" + error.message);
						
						action.error = test;
						
						// dispatch events and run effects
						if (action.hasEventListener(LoadFile.ERROR)) {
							dispatchActionEvent(new Event(LoadFile.ERROR));
						}
						
						if (action.errorEffect) {
							playEffect(action.errorEffect);
						}
						
						finish();
						return;
					}
					
				}
				
				// Check at least one file is selected
				//if (!file.creationDate) {
				//	dispatchErrorEvent("No file is selected");
				//}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// remove previous variables
			action.removeReferences(false);
			
			// load in files
			if (fileReference) {
				
				try {
					addFileListeners(fileReference);
					
					action.numOfFiles = 1;
					fileReference.load();
				}
				catch (error:Error) {
					removeFileListeners(fileReference);
				   // trace("Failed:", error.message);
				   // traceMessage("BrowseForFile:" + error.message);
					
					action.error = error;
					
					// dispatch events and run effects
					if (action.hasEventListener(LoadFile.ERROR)) {
						dispatchActionEvent(new Event(LoadFile.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					finish();
					return;
				}
			}
			else if (fileReferenceList || (filesArray && filesArray.length>0)) {

				if (fileReferenceList) {
					filesArray = fileReferenceList.fileList;
				}
				
				action.numOfFiles = filesArray ? filesArray.length : 0;
				
				for each (fileReference in filesArray) {
					addFileListeners(fileReference);
					fileReference.load();
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			waitForHandlers();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//  File Reference Handlers
		//--------------------------------------------------------------------------
		
		
		/**
		 * Dispatched on file complete event
		 * */
		private function completeHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loadBytesWithLoader:Boolean = action.loadIntoLoader;
			var fileReferenceList:FileReferenceList;
			var fileReference:FileReference;
			var loader:Loader;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			fileReference = event.target as FileReference;
			fileReferenceList = event.target as FileReferenceList;
			
			action.totalFilesProcessed++;
			
			if (fileReference) {
				
			}
			else if (fileReferenceList) {
				/*
				// not sure if multi file support is correct here
				removeFileListeners(fileReference);
				
				if (action.currentFileReferenceList != fileReferenceList) {
					action.currentFileReferenceList = fileReferenceList;
				}
				
				action.data = fileReference.data;
				action.type = fileReference.type;
				action.dataAsString = fileReference.data.readUTFBytes(fileReference.data.length);
				
				if (loadBytesWithLoader) {
					loader = new Loader();
					addLoaderListeners(loader.contentLoaderInfo);
					//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete, false, 0, true);
					loader.loadBytes(fileReference.data);
				}
				*/
			}
			
			removeFileListeners(fileReference);
			updateCurrentFile(fileReference);
			
			if (loadBytesWithLoader) {
				loader = new Loader();
				action.filesDictionary[loader] = fileReference;
				addLoaderListeners(loader.contentLoaderInfo);
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete, false, 0, true);
				loader.loadBytes(fileReference.data);
			}
			
			if (action.hasEventListener(LoadFile.COMPLETE)) {
				dispatchActionEvent(event);
			}
			
			if (action.completeEffect) {
				playEffect(action.completeEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			if (loadBytesWithLoader) {
				waitForHandlers();
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			if (!loadBytesWithLoader) {
				//finish();
			}
			
			
			if (action.numOfFiles==action.totalFilesProcessed) {
				if (action.removeReferencesOnComplete && !action.loadIntoLoader) {
					action.removeReferences();
				}
				
				
				if (action.hasEventListener(LoadFile.TOTAL_COMPLETE)) {
					dispatchActionEvent(new Event(LoadFile.TOTAL_COMPLETE));
				}
				
				if (action.totalCompleteEffect) {
					playEffect(action.totalCompleteEffect);
				}
				
				
				finish();
			}
			
		}
		
		/**
		 * Dispatched on file io error event
		 * */
		private function ioErrorHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var fileReference:FileReference = FileReference(event.target);
			var loadBytesWithLoader:Boolean = action.loadIntoLoader;
			
			updateCurrentFile(fileReference);
			action.totalFilesProcessed++;
			
			removeFileListeners(fileReference);
			
			if (action.hasEventListener(LoadFile.IO_ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.ioErrorEffect) {
				playEffect(action.ioErrorEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// remove references if done loading
			if (action.numOfFiles==action.totalFilesProcessed) {
				
				// we are not done yet if we need to load into loader
				if (action.removeReferencesOnComplete && !action.loadIntoLoader) {
					action.removeReferences();
				}
				
				finish();
			}
			
			
			if (!loadBytesWithLoader) {
				
			}
		}
		
		/**
		 * Dispatched on file open event
		 * */
		private function openHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var fileReference:FileReference = FileReference(event.target);
			
			updateCurrentFile(fileReference);
			
			if (action.hasEventListener(Event.OPEN)) {
				dispatchActionEvent(event);
			}
			
			if (action.openEffect) {
				playEffect(action.openEffect);
			}
			
		}
		
		/**
		 * Dispatched on file progress event
		 * */
		private function progressHandler(event:ProgressEvent):void {
			var action:LoadFile = LoadFile(effect);
			var fileReference:FileReference = FileReference(event.target);
			
			updateCurrentFile(fileReference);
			action.currentProgressEvent = event; 
			
			if (action.hasEventListener(LoadFile.PROGRESS)) {
				dispatchActionEvent(event);
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
		}
		
		
		//--------------------------------------------------------------------------
		//  Loader Handlers
		//--------------------------------------------------------------------------
		
		
		/**
		 * Dispatched on loader async error event
		 * */
		protected function loaderASyncErrorHandler(event:AsyncErrorEvent):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			action.totalLoadersProcessed++;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.ASYNC_ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.asyncErrorEffect) {
				playEffect(action.asyncErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			if (action.numOfFiles==action.totalLoadersProcessed) {
				if (action.removeReferencesOnComplete) {
					action.removeReferences();
				}
				
				finish();
			}
			
		}
		
		/**
		 * Dispatched on loader complete event
		 * */
		public function loaderComplete(event:Event) : void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var completeEvent:Event;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			action.totalLoadersProcessed++;
			
			removeLoaderListeners(loaderInfo);
			
			action.loaderInfo = loaderInfo;
			action.loaderByteArray = loaderInfo.bytes;
			action.loaderContents = loaderInfo.content;
			action.loaderContentType = loaderInfo.contentType;
			
			if (loaderInfo.content is Bitmap) {
				action.bitmapData = Bitmap(loaderInfo.content).bitmapData;
			}
			
			// NOTE: there is a complete event and loader complete event
			if (action.hasEventListener(LoadFile.LOADER_COMPLETE)) {
				completeEvent = new Event(LoadFile.LOADER_COMPLETE);
				dispatchActionEvent(completeEvent);
			}
			
			if (action.loaderCompleteEffect) {
				playEffect(action.loaderCompleteEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			if (action.numOfFiles==action.totalLoadersProcessed) {
				if (action.removeReferencesOnComplete) {
					action.removeReferences();
				}
				
				if (action.hasEventListener(LoadFile.LOADER_TOTAL_COMPLETE)) {
					var allCompleteEvent:Event = new Event(LoadFile.LOADER_TOTAL_COMPLETE);
					dispatchActionEvent(allCompleteEvent);
				}
				
				if (action.loaderTotalCompleteEffect) {
					playEffect(action.loaderTotalCompleteEffect);
				}
				
				finish();
			}
		}
		
		/**
		 * Dispatched on loader init event
		 * */
		protected function loaderInitHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			
			if (action.hasEventListener(LoadFile.INIT)) {
				dispatchActionEvent(event);
			}
			
			if (action.initEffect) {
				playEffect(action.initEffect);
			}
			
		}
		
		/**
		 * Dispatched on loader io error event
		 * */
		private function loaderIOErrorHandler(event:IOErrorEvent):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var ioErrorEvent:IOErrorEvent;
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			action.totalLoadersProcessed++;
			
			removeLoaderListeners(loaderInfo);
			
			// NOTE: there is a io error event and loader io error event
			if (action.hasEventListener(LoadFile.LOADER_IO_ERROR)) {
				ioErrorEvent = new IOErrorEvent(LoadFile.LOADER_IO_ERROR, false, false, event.text, event.errorID);
				dispatchActionEvent(ioErrorEvent);
			}
			
			if (action.ioErrorEffect) {
				playEffect(action.ioErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			if (action.numOfFiles==action.totalLoadersProcessed) {
				if (action.removeReferencesOnComplete) {
					action.removeReferences();
				}
				
				finish();
			}
		}
		
		/**
		 * Dispatched on loader open event
		 * */
		private function loaderOpenHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var openEvent:Event;
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			
			
			// NOTE: there is a open event and loader open event
			if (action.hasEventListener(LoadFile.LOADER_OPEN)) {
				openEvent = new Event(LoadFile.LOADER_OPEN);
				dispatchActionEvent(openEvent);
			}
			
			if (action.openEffect) {
				playEffect(action.openEffect);
			}
			
		}
		
		/**
		 * Dispatched on loader progress event
		 * */
		private function loaderProgressHandler(event:ProgressEvent):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var progressEvent:Event;
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			
			
			// NOTE: there is a progress event and loader progress event
			if (action.hasEventListener(LoadFile.LOADER_PROGRESS)) {
				progressEvent = new ProgressEvent(LoadFile.LOADER_PROGRESS, false, false, event.bytesLoaded, event.bytesTotal);
				
				dispatchActionEvent(progressEvent);
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
			
		}
		
		/**
		 * Dispatched on loader security error event
		 * */
		protected function loaderSecurityErrorHandler(event:SecurityErrorEvent):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.SECURITY_ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.securityErrorEffect) {
				playEffect(action.securityErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			if (action.numOfFiles==action.totalLoadersProcessed) {
				if (action.removeReferencesOnComplete) {
					action.removeReferences();
				}
				
				finish();
			}
		}
		
		/**
		 * Dispatched on loader unload event
		 * */
		protected function loaderUnloadHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			updateCurrentFile(getFileFromLoader(loaderInfo.loader));
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.UNLOAD)) {
				dispatchActionEvent(event);
			}
			
			if (action.unloadEffect) {
				playEffect(action.unloadEffect);
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
		private function addFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, 			completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 		ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, 				openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 	progressHandler);
		}
		
		/**
		 * Removes file listeners
		 * */
		private function removeFileListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, 				completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,	 	ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, 					openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, 		progressHandler);
		}
		
		/**
		 * Adds content loader listeners
		 * */
		private function addLoaderListeners(loader:LoaderInfo):void {	
			loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 		loaderASyncErrorHandler);
			loader.addEventListener(Event.COMPLETE, 					loaderComplete);
			loader.addEventListener(Event.INIT, 						loaderInitHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, 				loaderIOErrorHandler);
			loader.addEventListener(Event.OPEN, 						loaderOpenHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, 			loaderProgressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	loaderSecurityErrorHandler);
			loader.addEventListener(Event.UNLOAD,		 				loaderUnloadHandler);
		}
		
		/**
		 * Removes content loader listeners
		 * */
		private function removeLoaderListeners(loader:LoaderInfo):void {	
			loader.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, 		loaderASyncErrorHandler);
			loader.removeEventListener(Event.COMPLETE, 						loaderComplete);
			loader.removeEventListener(Event.INIT, 							loaderInitHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, 				loaderIOErrorHandler);
			loader.removeEventListener(Event.OPEN, 							loaderOpenHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, 				loaderProgressHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	loaderSecurityErrorHandler);
			loader.removeEventListener(Event.UNLOAD,		 				loaderUnloadHandler);
		}
		
		/**
		 * Get file reference from loader
		 * */
		public function getFileFromLoader(loader:Loader):FileReference {
			var action:LoadFile = LoadFile(effect);
			return action.filesDictionary[loader];
		}
		
		/**
		 * Updates the current file property in the action class
		 * */
		public function updateCurrentFile(fileReference:FileReference):void {
			var action:LoadFile = LoadFile(effect);
			action.currentFileReference = fileReference;
			action.data = fileReference.data;
			action.type = fileReference.type;
			
			// prevent converting the whole byte array into string each time
			// we update the current file
			if (!action.fileStringDictionary[fileReference] && fileReference.data) {
				if (fileReference.data!=null) {
					action.fileStringDictionary[fileReference] = fileReference.data.readUTFBytes(fileReference.data.length);
				}
				else {
					action.fileStringDictionary[fileReference] = null;
				}
			}
			
			action.dataAsString = action.fileStringDictionary[fileReference];
		}
	}
}