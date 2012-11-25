

package com.flexcapacitor.effects.camera.supportClasses {
	import com.flexcapacitor.effects.camera.SaveToCameraRoll;
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
	 * @copy SaveToCameraRoll
	 * */  
	public class SaveToCameraRollInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SaveToCameraRollInstance(target:Object) {
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
			
			var action:SaveToCameraRoll = SaveToCameraRoll(effect);
			var cameraRoll:CameraRoll;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (action.bitmapData==null) {
					dispatchErrorEvent("Bitmap data is null");
				}
				else if (action.bitmapData.width==0 || action.bitmapData.height==0) {
					dispatchErrorEvent("Bitmap data width or height is 0");
				}
			}
			
			// check if we have support for a gallery
			if (!CameraRoll.supportsAddBitmapData) { 
				
				if (action.hasEventListener(SaveToCameraRoll.CAMERA_ROLL_NOT_SUPPORTED)) {
					action.dispatchEvent(new Event(SaveToCameraRoll.CAMERA_ROLL_NOT_SUPPORTED));
				}
				
				if (action.cameraRollNotSupportedEffect) { 
					playEffect(action.cameraRollNotSupportedEffect);
				}
				
				finish();
				return;
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// create a reference to the camera roll
			cameraRoll = new CameraRoll();
			
			// Handle when image is added
			cameraRoll.addEventListener(Event.COMPLETE, onComplete);
			
			// Handles if there is an error
			cameraRoll.addEventListener(ErrorEvent.ERROR, onError);
			
			// Call the addBitmapData function to bring the Gallery application to the foreground.
			cameraRoll.addBitmapData(action.bitmapData);
			
			action.cameraRoll = cameraRoll;
			
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
		 * The image was added to the gallery
		 * */
		private function onComplete(event:Event):void {
			var action:SaveToCameraRoll = SaveToCameraRoll(effect);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (action.completeEffect) { 
				playEffect(action.completeEffect);
			}
			
			if (action.hasEventListener(SaveToCameraRoll.COMPLETE)) {
				action.dispatchEvent(event);
			}
			
			removeCameraRollListeners();
			
			///////////////////////////////////////////////////////////
			// Finish
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		/**
		 * An error occurred 
		 * */
		private function onError(event:ErrorEvent):void {
			var action:SaveToCameraRoll = SaveToCameraRoll(effect);
			
			action.errorEvent = event;
			

			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (event.errorID == 2124) {
				traceMessage("You can only load images from the Gallery");
			}
			
			if (action.errorEffect) {
				playEffect(action.errorEffect);
			}
			
			if (action.hasEventListener(SaveToCameraRoll.ERROR)) {
				action.dispatchEvent(event);
			}
			
			removeCameraRollListeners();

			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		
		/**
		 * Remove listeners
		 * */
		private function removeCameraRollListeners():void {
			var action:SaveToCameraRoll = SaveToCameraRoll(effect);
			
			if (action.cameraRoll) {
				action.cameraRoll.removeEventListener(Event.COMPLETE, onComplete);
				action.cameraRoll.removeEventListener(ErrorEvent.ERROR, onError);
			}
		}
		
	}
	
	
}