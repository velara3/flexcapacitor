

package com.flexcapacitor.effects.camera {
	
	import com.flexcapacitor.effects.camera.supportClasses.OpenCameraRollInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	
	import mx.effects.Effect;
	import mx.managers.SystemManager;
	
	import spark.primitives.BitmapImage;
	
	/**
	 * Event dispatched when the camera roll is NOT supported.
	 * */
	[Event(name="cameraRollNotSupported", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the camera roll is supported.
	 * */
	[Event(name="cameraRollSupported", type="flash.events.Event")]
	
	/**
	 * Event dispatched when there is an error when loading the content.
	 * Usually file name or path is incorrect.
	 * */
	[Event(name="contentLoaderError", type="flash.events.Event")]
	
	/**
	 * Opens the gallery of a Camera Roll. 
	 * */
	public class OpenCameraRoll extends ActionEffect {
		
		public static const CAMERA_ROLL_SUPPORTED:String = "cameraRollSupported";
		
		public static const CAMERA_ROLL_NOT_SUPPORTED:String = "cameraRollNotSupported";
		
		public static const CAMERA_ROLL_CLASS_NAME:String = "flash.media.CameraRoll";
		
		public static const CONTENT_LOADER_ERROR:String = "contentLoaderError";
		
		
		/**
		 *  Constructor.
		 * */
		public function OpenCameraRoll(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			// SINCE THIS CLASS USES AIR CLASSES WE NEED TO CHECK IF
			// THE REQUIRED CLASSES EXIST HERE BEFORE CREATING 
			// A REFERENCE TO THE INSTANCE. OTHERWISE WE GET A 
			// ERROR #1065 - Variable "flash.media.CameraRoll"
			// VerifyError: Error #1014: Class flash.media::CameraRoll could not be found.
			// VerifyError: Error #1014: Class flash.events::MediaEvent could not be found.

			// From SystemManager: var domain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info()["currentDomain"] as ApplicationDomain;
			var applicationDomain:ApplicationDomain = SystemManager.getSWFRoot(this).loaderInfo.applicationDomain;
			var hasCameraRollDefinition:Boolean = applicationDomain.hasDefinition(CAMERA_ROLL_CLASS_NAME); 
			
			if (hasCameraRollDefinition) {
				instanceClass = OpenCameraRollInstance;
			}
			
		}
		
		/**
		 * Effect to play when camera roll is NOT supported
		 * */
		public var cameraRollNotSupportedEffect:Effect;
		
		/**
		 * Effect to play when camera roll is supported
		 * */
		public var cameraRollSupportedEffect:Effect;
		
		/**
		 * Effect to play when content was not loaded.
		 * Usually due to incorrect file name or path
		 * NOTE: You may need to request permissions to access the device media
		 * QNX - access_shared
		 * */
		public var contentLoaderErrorEffect:Effect;
		
		/**
		 * Reference to the cameral roll
		 * */
		public var cameraRoll:Object;
		
		/**
		 * If add to container property is true then the image 
		 * bitmap data is added to the bitmap image defined 
		 * in this property.
		 * */
		public var container:BitmapImage;
		
		/**
		 * When set to true sets the bitmap data of the bitmap image.
		 * */
		public var addToContainer:Boolean;
		
		/**
		 * If add to container is true then scales the bitmap data to 
		 * fit the bitmap image.
		 * */
		public var scaleToFitContainer:Boolean;
		
		/**
		 * Bitmap data of the selected image.
		 * */
		public var bitmapData:BitmapData;
		
		/**
		 * If camera roll gallery is not supported we can set this property
		 * to an image for testing purposes
		 * */
		public var unsupportedTestingImage:BitmapData;
	}
}