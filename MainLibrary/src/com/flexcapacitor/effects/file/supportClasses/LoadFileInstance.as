

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
			var files:FileReferenceList = action.fileReferenceList;
			var file:FileReference = action.fileReference;
			var filesList:Array;

			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (file==null && files==null) {
					dispatchErrorEvent("The file reference or file reference list is not set");
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
			action.currentLoaderInfo = null;
			action.currentFile = null;
			
			// load in files
			if (file) {
				addFileListeners(file);
				file.load();
			}
			else if (files) {
				//addFileListeners(files);
				filesList = files.fileList;
				
				for each (file in filesList) {
					addFileListeners(file);
					file.load();
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
			var files:FileReferenceList;
			var file:FileReference;
			var loader:Loader;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			file = event.target as FileReference;
			files = event.target as FileReferenceList;
			action.removeReferences();
			
			if (file) {
				removeFileListeners(file);
				action.fileReference = file;
				action.currentFile = file;
				
				if (loadBytesWithLoader) {
					loader = new Loader();
					addLoaderListeners(loader.contentLoaderInfo);
					//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete, false, 0, true);
					loader.loadBytes(file.data);
				}
			}
			else if (files) {
				
				removeFileListeners(file);
				action.fileReferenceList = files;
				
				if (loadBytesWithLoader) {
					loader = new Loader();
					addLoaderListeners(loader.contentLoaderInfo);
					//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete, false, 0, true);
					loader.loadBytes(file.data);
				}
			}
			
			action.data = file.data;
			
			if (action.hasEventListener(LoadFile.COMPLETE)) {
				action.dispatchEvent(event);
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
				finish();
			}
			
			
		}
		
		/**
		 * Dispatched on file io error event
		 * */
		private function ioErrorHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var file:FileReference = FileReference(event.target);
			
			action.currentFile = file;
			
			removeFileListeners(file);
			
			if (action.hasEventListener(LoadFile.IO_ERROR)) {
				action.dispatchEvent(event);
			}
			
			if (action.ioErrorEffect) {
				playEffect(action.ioErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Dispatched on file open event
		 * */
		private function openHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var file:FileReference = FileReference(event.target);
			
			action.currentFile = file;
			
			if (action.hasEventListener(Event.OPEN)) {
				action.dispatchEvent(event);
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
			var file:FileReference = FileReference(event.target);
			
			action.currentFile = file;
			action.currentProgressEvent = event; 
			
			if (action.hasEventListener(LoadFile.PROGRESS)) {
				action.dispatchEvent(event);
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
			
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.ASYNC_ERROR)) {
				action.dispatchEvent(event);
			}
			
			if (action.asyncErrorEffect) {
				playEffect(action.asyncErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
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
			
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			action.loaderInfo = loaderInfo;
			action.byteArray = loaderInfo.bytes;
			action.data = loaderInfo.content;
			action.contentType = loaderInfo.contentType;
			
			if (loaderInfo.content is Bitmap) {
				action.bitmapData = Bitmap(loaderInfo.content).bitmapData;
			}
			
			// NOTE: there is a complete event and loader complete event
			if (action.hasEventListener(LoadFile.LOADER_COMPLETE)) {
				completeEvent = new Event(LoadFile.LOADER_COMPLETE);
				action.dispatchEvent(completeEvent);
			}
			
			if (action.loaderCompleteEffect) {
				playEffect(action.loaderCompleteEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Dispatched on loader init event
		 * */
		protected function loaderInitHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			action.currentLoaderInfo = loaderInfo;
			
			
			if (action.hasEventListener(LoadFile.INIT)) {
				action.dispatchEvent(event);
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
			
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			// NOTE: there is a io error event and loader io error event
			if (action.hasEventListener(LoadFile.LOADER_IO_ERROR)) {
				ioErrorEvent = new IOErrorEvent(LoadFile.LOADER_IO_ERROR, false, false, event.text, event.errorID);
				action.dispatchEvent(ioErrorEvent);
			}
			
			if (action.ioErrorEffect) {
				playEffect(action.ioErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Dispatched on loader open event
		 * */
		private function loaderOpenHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			var openEvent:Event;
			
			action.currentLoaderInfo = loaderInfo;
			
			
			// NOTE: there is a open event and loader open event
			if (action.hasEventListener(LoadFile.LOADER_OPEN)) {
				openEvent = new Event(LoadFile.LOADER_OPEN);
				action.dispatchEvent(openEvent);
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
			
			action.currentLoaderInfo = loaderInfo;
			
			
			// NOTE: there is a progress event and loader progress event
			if (action.hasEventListener(LoadFile.LOADER_PROGRESS)) {
				progressEvent = new ProgressEvent(LoadFile.LOADER_PROGRESS, false, false, event.bytesLoaded, event.bytesTotal);
				
				action.dispatchEvent(progressEvent);
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
			
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.SECURITY_ERROR)) {
				action.dispatchEvent(event);
			}
			
			if (action.securityErrorEffect) {
				playEffect(action.securityErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		/**
		 * Dispatched on loader unload event
		 * */
		protected function loaderUnloadHandler(event:Event):void {
			var action:LoadFile = LoadFile(effect);
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			
			action.currentLoaderInfo = loaderInfo;
			
			removeLoaderListeners(loaderInfo);
			
			if (action.hasEventListener(LoadFile.UNLOAD)) {
				action.dispatchEvent(event);
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
		
	}
}