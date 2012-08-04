

package com.flexcapacitor.effects.camera.supportClasses {
	import com.flexcapacitor.effects.camera.OpenCameraRoll;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	
	
	/**
	 * @copy OpenCameraRoll
	 * */  
	public class OpenCameraRollInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function OpenCameraRollInstance(target:Object) {
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
			super.play(); // dispatch startEffect
			
			var action:OpenCameraRoll = OpenCameraRoll(effect);
			var galleryUnsupport:String = OpenCameraRoll.CAMERA_ROLL_NOT_SUPPORTED;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (action.addToContainer && !action.container) {
				throw new Error("The container is required.");
			}
			
			// check if we have support for a gallery
			if (!CameraRoll.supportsBrowseForImage) { 
				
				if (action.unsupportedTestingImage) {
					action.bitmapData = action.unsupportedTestingImage;
					onComplete();
					return;
				}
				
				//trace("this device does not support access to the Gallery");
				
				if (action.hasEventListener(galleryUnsupport)) {
					action.dispatchEvent(new Event(galleryUnsupport));
				}
				
				if (action.cameraRollNotSupportedEffect) { 
					playEffect(action.cameraRollNotSupportedEffect);
				}
				
				cancel("This device does not support access to the Gallery");
				return;
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// create a reference to the camera roll
			action.cameraRoll = new CameraRoll();
			
			// Handle when the user selects an image:
			action.cameraRoll.addEventListener(MediaEvent.SELECT, onSelect);
			
			// Handle when the user opts out of the gallery:
			action.cameraRoll.addEventListener(Event.CANCEL, onCancel);
			
			// Handles if there is an issue in the camera roll process
			action.cameraRoll.addEventListener(ErrorEvent.ERROR, onError);
			
			// Call the browseForImage function to bring the Gallery application to the foreground.
			action.cameraRoll.browseForImage();
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			// wait until we hear back from our listeners
			waitForHandlers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * A image file was selected, load it.
		 * */
		private function onSelect(event:MediaEvent):void {
			var action:OpenCameraRoll = OpenCameraRoll(effect);
			var promise:MediaPromise = event.data as MediaPromise;
			var loader:Loader = new Loader();
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// Note: can we load the file like this promise.open();
			// any downsides? do we need to close the promise?
			
			///promise.isAsync will tell if the data is available immediately
			// if isAsync is true then sync is false?
			// if sync then data is available immediately
			
			//trace(promise.isAsync);
			
			// check if the camera roll is supported
			if (action.cameraRollSupportedEffect) { 
				playEffect(action.cameraRollSupportedEffect);
			}
			
			if (promise.isAsync) {
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onContentLoaderError);
				loader.loadFilePromise(promise);
			}
			else {
				loader.loadFilePromise(promise);
				action.bitmapData = Bitmap(loader.content).bitmapData;
				onComplete();
			}
			
			
			removeCameraRollListeners();
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			
			// wait until we hear back from our listeners
			if (promise.isAsync) {
				waitForHandlers();
			}
		}
		
		/**
		 * User has canceled out of the gallery dialog without selecting an image
		 * */
		private function onCancel(event:Event):void {
			removeCameraRollListeners();
			
			cancel("User canceled out of the gallery");
		}
		
		/**
		 * A image has been selected and has loaded completely.
		 * */
		private function onComplete(event:Event=null):void {
			var action:OpenCameraRoll = OpenCameraRoll(effect);
			var bitmapData:BitmapData;
			var isPortrait:Boolean;
			var bitmap:Bitmap;
			var forRatio:int;
			var ratio:Number;			
			var bitmapWidth:int;
			var bitmapHeight:int;
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// if we are testing we've manually set the bitmap data
			bitmapData = event ? Bitmap(event.target.content).bitmapData : action.bitmapData;
			bitmapWidth = bitmapData.width;
			bitmapHeight = bitmapData.height;

			// assign bitmap data
			action.bitmapData = bitmapData;
			
			if (action.addToContainer) {
				bitmap = new Bitmap(bitmapData);
	
				// determine the image orientation 
				isPortrait = (bitmapHeight/bitmapWidth) > 1.0;
				
				// choose the smallest value between stage width and height 
				forRatio = Math.min(action.container.height, action.container.width);
				
				// calculate the scaling ratio to apply to the image 
				if (isPortrait) {
					ratio = forRatio/bitmapWidth;
				}
				else {
					ratio = forRatio/bitmapHeight;
				}
				
				bitmap.width = bitmapWidth * ratio;
				bitmap.height = bitmapHeight * ratio;
				
				// rotate a landscape image 
				if (!isPortrait) {
					bitmap.y = action.container.width;
					bitmap.rotation = -90;
				}
				
				// in the bitmap image the bitmapData property is not always set right away
				// action.container.bitmapData may be null for a few a few frames
				action.container.source = bitmap;
			}
			
			if (event) {
				removeOnSelectListeners(event.currentTarget as Loader);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * An error occurred while using the gallery.
		 * */
		private function onError(event:ErrorEvent):void {
			//trace("Gallery error", event.type);
			
			if (event.errorID == 2124) {
				trace("You can only load images from the Gallery");
			}
			
			removeCameraRollListeners();
			
			cancel("Gallery error " + event.text);
		}
		
		/**
		 * An error occurred while loading the selected image from the gallery.
		 * */
		protected function onContentLoaderError(event:IOErrorEvent):void {
			var action:OpenCameraRoll = OpenCameraRoll(effect);
			removeOnSelectListeners(event.currentTarget as Loader);
			
			// NOTE: You may need to request permissions to access the device media
			
			// check if the camera roll is supported
			if (action.contentLoaderErrorEffect) { 
				playEffect(action.contentLoaderErrorEffect);
			}
			
			cancel("Gallery error " + event.text);
		}
		
		/**
		 * Remove listeners added initially.
		 * */
		private function removeCameraRollListeners():void {
			var action:OpenCameraRoll = OpenCameraRoll(effect);
			
			if (action.cameraRoll) {
				action.cameraRoll.removeEventListener(MediaEvent.SELECT, onSelect);
				action.cameraRoll.removeEventListener(Event.CANCEL, onCancel);
				action.cameraRoll.removeEventListener(ErrorEvent.ERROR, onError);
			}
		}
		
		/**
		 * Remove listeners added to the content loader.
		 * */
		private function removeOnSelectListeners(loader:Loader):void {
			
			if (loader) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onContentLoaderError);
			}
		}
	}
	
	
}