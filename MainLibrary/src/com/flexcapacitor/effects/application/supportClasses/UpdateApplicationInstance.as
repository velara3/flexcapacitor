

package com.flexcapacitor.effects.application.supportClasses {
	import com.flexcapacitor.effects.application.UpdateApplication;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.display.NativeWindow;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.FlexGlobals;
	
	import spark.components.Application;
	import spark.components.WindowedApplication;
	
	import air.update.ApplicationUpdater;
	import air.update.ApplicationUpdaterUI;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusFileUpdateErrorEvent;
	import air.update.events.StatusFileUpdateEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	
	/**
	 * @copy UpdateApplication
	 * */  
	public class UpdateApplicationInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function UpdateApplicationInstance(target:Object) {
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
		 */
		override public function play():void { 
			super.play(); // dispatch effectStart
			
			var action:UpdateApplication = UpdateApplication(effect);
			var useUI:Boolean = action.useUI;
			var configurationFilePath:String = action.configurationFilePath;
			var updateURL:String = action.updateURL;
			var delay:Number = action.delay;
			var updater:ApplicationUpdater;
			var updaterUI:ApplicationUpdaterUI;
			/*var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
		    var ns:Namespace = appXML.namespace();
		    var version:String = appXML.versionNumber;*/
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!configurationFilePath && !updateURL) {
					dispatchErrorEvent("You must set the configurationFilePath to a valid config file location or set the updateURL.");
				}
				
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// if not using update config path and delay is not set then set to one day
			if (isNaN(delay) && !configurationFilePath) {
				delay = 1;
			}
			
			// show dialogs
			if (useUI) {
				if (updaterUI==null) {
					updaterUI = new ApplicationUpdaterUI();
				}
				
				addEventListeners(updaterUI);
				
				if (action.versionCompareFunction!=null) {
					updaterUI.isNewerVersionFunction = action.versionCompareFunction;
				}
				
				if (configurationFilePath) {
					updaterUI.configurationFile = new File(configurationFilePath);
				}
				else {
					updaterUI.updateURL = updateURL;
					
					updaterUI.delay = delay;
					
					updaterUI.isCheckForUpdateVisible = action.isCheckForUpdateVisible;
					
					updaterUI.isDownloadUpdateVisible = action.isDownloadUpdateVisible;
					
					updaterUI.isDownloadProgressVisible = action.isDownloadProgressVisible;
					
					updaterUI.isInstallUpdateVisible = action.isInstallUpdateVisible;
					
					updaterUI.isFileUpdateVisible = action.isFileUpdateVisible;
					
					updaterUI.isUnexpectedErrorVisible = action.isUnexpectedErrorVisible;
				}
				
				action.updater = updaterUI;
			
				action.currentVersion = updaterUI.currentVersion;
				action.previousVersion = updaterUI.previousVersion;
				action.wasPendingUpdate = updaterUI.wasPendingUpdate;
				action.updateDescriptor = updaterUI.updateDescriptor;
				
				updaterUI.initialize();
				
				//updaterUI.checkNow();
			}
			else {
				if (updater==null) {
					updater = new ApplicationUpdater();
				}
				
				addEventListeners(updater);
				
				if (action.versionCompareFunction!=null) {
					updater.isNewerVersionFunction = action.versionCompareFunction;
				}
				
				if (configurationFilePath) {
					updater.configurationFile = new File(configurationFilePath);
				}
				else {
					updater.updateURL = updateURL;
					updater.delay = delay;
				}
				
				action.updater = updater;
				
				//BindingUtils.bindProperty(action, "currentState", action.updater, "currentState");
				BindingUtils.bindProperty(action, "currentState", action.updater, "currentState");
				action.currentVersion = updater.currentVersion;
				action.previousVersion = updater.previousVersion;
				action.wasPendingUpdate = updater.wasPendingUpdate;
				action.updateDescriptor = updater.updateDescriptor;
				
				updater.initialize();
				
				//updater.checkForUpdate();
			}
			
			if ((updater && updater.isFirstRun) || 
				(updaterUI && updaterUI.isFirstRun)) {
				if (action.hasEventListener(UpdateApplication.FIRST_RUN)) {
					dispatchActionEvent(new Event(UpdateApplication.FIRST_RUN));
				}
				
				if (action.firstRunEffect) { 
					playEffect(action.firstRunEffect);
				}
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			waitForHandlers();
		}
		
		public static const EVENT_CHECK_FILE:String = "check.file";
		public static const EVENT_CHECK_URL:String = "check.url";
		public static const EVENT_INITIALIZE:String = "initialize";
		public static const ENTER:String = "enter";
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Handles events from the update framework instance
		 * */
		private function eventListener(event:Object):void {
			var action:UpdateApplication = UpdateApplication(effect);
			var updater:ApplicationUpdater;
			var updaterUI:ApplicationUpdaterUI;
					
			var eventName:String = event.type;
			var effectName:String = eventName + "Effect";
			
			updater = action.updater as ApplicationUpdater;
			updaterUI = action.updater as ApplicationUpdaterUI;
			
			// binding not detecting changes to currentState
			// setting here because other events exit out of the 
			// processes
			if (updater) {
				action.currentState = updater.currentState;
			}
			
			// TODO: Add all the effects and test this more
			switch (eventName) {
				
				case UpdateEvent.INITIALIZED: {
			
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.initializedEffect) {
						playEffect(action.initializedEffect);
					}
					
					if (updater) {
						updater.checkNow();
					}
					else if (updaterUI) {
						updaterUI.checkNow();
					}
					
					break;
				}
				case StatusUpdateEvent.UPDATE_STATUS: {
					var statusEvent:StatusUpdateEvent = event as StatusUpdateEvent;
					var descriptor:XML;
					var ns:Namespace;
					
					action.isUpdateAvailable = statusEvent.available;
					action.remoteVersion = statusEvent.version;
					action.versionLabel = statusEvent.versionLabel;
					action.versionDetails = statusEvent.details;
					
					if (updater) {
						descriptor = updater.updateDescriptor;
					}
					else if (updaterUI) {
						descriptor = updaterUI.updateDescriptor;
					}
					
					ns = descriptor.namespace();
					action.versionURL = descriptor.ns::url;
					action.versionDescription = descriptor.ns::description;
			
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.statusUpdateEffect) {
						playEffect(action.statusUpdateEffect);
					}
					
					// if an update is available this property is true
					if (statusEvent.available) {
						
						if (action.orderUpdateAvailableWindowToFront) {
							orderUpdateWindowToFront();
						}
			
						if (action.hasEventListener(UpdateApplication.UPDATE_AVAILABLE)) {
							dispatchActionEvent(new Event(UpdateApplication.UPDATE_AVAILABLE));
						}
			
						if (action.updateAvailableEffect) {
							playEffect(action.updateAvailableEffect);
						}
						
						if (action.cancelBeforeUpdate) {
							StatusUpdateEvent(event).preventDefault();
							removeEventListeners(action.updater as IEventDispatcher);
							
							finish();
						}
					}
					else {
						
						if (action.hasEventListener(UpdateApplication.UPDATE_NOT_AVAILABLE)) {
							dispatchActionEvent(new Event(UpdateApplication.UPDATE_NOT_AVAILABLE));
						}
						
						if (action.updateNotAvailableEffect) {
							playEffect(action.updateNotAvailableEffect);
						}
						
						removeEventListeners(action.updater as IEventDispatcher);
						
						finish();
					}
					
					// version will be null or empty string if no update is available 
					//[StatusUpdateEvent (type=updateStatus available=false version= details= versionLabel= )]
					if (statusEvent.version) {
						
					}
					
					break;
				}
				case StatusUpdateErrorEvent.UPDATE_ERROR: {
					var statusError:StatusUpdateErrorEvent = event as StatusUpdateErrorEvent;
					
					action.errorEvent 	= statusError;
					action.errorID 		= statusError.errorID;
					action.errorText 	= statusError.text;
			
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.hasEventListener(ErrorEvent.ERROR)) {
						// this was causing an error to display and was not caught by uncaughtExceptionHandler
						// dispatchActionEvent(event as Event); 
						dispatchActionEvent(new Event(ErrorEvent.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					removeEventListeners(action.updater as IEventDispatcher);
					
					finish();
					break;
				}
				case StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR: {
					var statusFileError:StatusFileUpdateErrorEvent = event as StatusFileUpdateErrorEvent;
					
					action.errorEvent 	= statusFileError;
					action.errorID 		= statusFileError.errorID;
					action.errorText 	= statusFileError.text;
			
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.hasEventListener(ErrorEvent.ERROR)) {
						dispatchActionEvent(new Event(ErrorEvent.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					removeEventListeners(action.updater as IEventDispatcher);
					
					finish();
					break;
				}
				case DownloadErrorEvent.DOWNLOAD_ERROR: {
					var downloadErrorEvent:DownloadErrorEvent = event as DownloadErrorEvent;
					
					action.errorEvent 	= downloadErrorEvent;
					action.errorID 		= downloadErrorEvent.errorID;
					action.errorText 	= downloadErrorEvent.text;

					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.hasEventListener(ErrorEvent.ERROR)) {
						dispatchActionEvent(new Event(ErrorEvent.ERROR));
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					removeEventListeners(action.updater as IEventDispatcher);
					
					finish();
					
					break;
				}
				case ErrorEvent.ERROR: {
					var errorEvent:ErrorEvent = event as ErrorEvent;
					
					action.errorEvent 	= errorEvent;
					action.errorID		= errorEvent.errorID;
					action.errorText 	= errorEvent.text;
					
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					
					removeEventListeners(action.updater as IEventDispatcher);
					
					finish();
					
					break;
				}
				default: {
								
					if (action.hasEventListener(eventName)) {
						dispatchActionEvent(event as Event);
					}
					
					if (effectName in action && action[effectName]) { 
						playEffect(action[effectName]);
					}
				}
			}
			
			// setting current state again
			if (updater) {
				action.currentState = updater.currentState;
			}
		}
		
		protected function orderUpdateWindowToFront():void {
			var windows:Array;
			var window:NativeWindow;
			var nativeApplication:NativeApplication;
			var nativeWindow:NativeWindow;
			
			nativeWindow = FlexGlobals.topLevelApplication.nativeWindow;
			nativeApplication = FlexGlobals.topLevelApplication.nativeApplication;
			
			windows = nativeApplication.openedWindows;
			
			for (var i:int;i<windows.length;i++) {
				window = windows[i];
				
				// if application then skip
				if (window==nativeWindow) {
					window.notifyUser(NotificationType.INFORMATIONAL);
					window.notifyUser(NotificationType.CRITICAL);
					continue;
				}
				
				if (window.title.indexOf("Updating:")!=-1) {
					// determine if update window - what about non-english
				}
				
				if (window.width==530 && window.height==232) {
					// determine if update window - what about scale factor or content
				}
				
				// order all non-application windows to front until we find a method to
				// find our update window
				window.orderToFront();
				//break;
			}
		}
		
		/**
		 * Add event listeners to the update framework instance
		 * */
		public function addEventListeners(updater:IEventDispatcher):void {
			var isWeakReference:Boolean = false;
			updater.addEventListener(UpdateEvent.BEFORE_INSTALL, eventListener, false, 0, isWeakReference);
			updater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, eventListener, false, 0, isWeakReference);
			updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, eventListener, false, 0, isWeakReference);
			updater.addEventListener(UpdateEvent.DOWNLOAD_START, eventListener, false, 0, isWeakReference);
			updater.addEventListener(UpdateEvent.INITIALIZED, eventListener, false, 0, isWeakReference);
			updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, eventListener, false, 0, isWeakReference);
			updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, eventListener, false, 0, isWeakReference);
			updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, eventListener, false, 0, isWeakReference);
			updater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, eventListener, false, 0, isWeakReference);
			updater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, eventListener, false, 0, isWeakReference);
			updater.addEventListener(ProgressEvent.PROGRESS, eventListener, false, 0, isWeakReference);
			updater.addEventListener(ErrorEvent.ERROR, eventListener, false, 0, isWeakReference);
			updater.addEventListener(UpdateApplication.INITIALIZE, eventListener, false, 0, isWeakReference);
			updater.addEventListener(EVENT_CHECK_FILE, eventListener, false, 0, isWeakReference);
			updater.addEventListener(EVENT_CHECK_URL, eventListener, false, 0, isWeakReference);
			updater.addEventListener(EVENT_INITIALIZE, eventListener, false, 0, isWeakReference);
			updater.addEventListener(ENTER, eventListener, false, 0, isWeakReference);
		}
		
		/**
		 * Remove event listeners from update framework instance
		 * */
		public function removeEventListeners(updater:IEventDispatcher):void {
			updater.removeEventListener(UpdateEvent.BEFORE_INSTALL, eventListener);
			updater.removeEventListener(UpdateEvent.CHECK_FOR_UPDATE, eventListener);
			updater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, eventListener);
			updater.removeEventListener(UpdateEvent.DOWNLOAD_START, eventListener);
			updater.removeEventListener(UpdateEvent.INITIALIZED, eventListener);
			updater.removeEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, eventListener);
			updater.removeEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, eventListener);
			updater.removeEventListener(StatusUpdateEvent.UPDATE_STATUS, eventListener);
			updater.removeEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, eventListener);
			updater.removeEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, eventListener);
			updater.removeEventListener(ProgressEvent.PROGRESS, eventListener);
			updater.removeEventListener(ErrorEvent.ERROR, eventListener);
			updater.removeEventListener(UpdateApplication.INITIALIZE, eventListener);
			updater.removeEventListener(EVENT_CHECK_FILE, eventListener);
			updater.removeEventListener(EVENT_CHECK_URL, eventListener);
			updater.removeEventListener(EVENT_INITIALIZE, eventListener);
			updater.removeEventListener(ENTER, eventListener);
		}
	}
}