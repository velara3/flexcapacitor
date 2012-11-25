

package com.flexcapacitor.effects.camera {
	
	import com.flexcapacitor.effects.camera.supportClasses.OpenCameraRollInstance;
	import com.flexcapacitor.effects.camera.supportClasses.SaveToCameraRollInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
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
	 * Event dispatched when complete
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Event dispatched when an error occurs
	 * */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	
	/**
	 * Saves bitmap data to the Camera Roll image gallery 
	 * */
	public class SaveToCameraRoll extends ActionEffect {
		
		public static const CAMERA_ROLL_SUPPORTED:String = "cameraRollSupported";
		
		public static const CAMERA_ROLL_NOT_SUPPORTED:String = "cameraRollNotSupported";
		
		public static const CAMERA_ROLL_CLASS_NAME:String = "flash.media.CameraRoll";
		
		public static const COMPLETE:String = "complete";
		
		public static const ERROR:String = "error";
		
		
		/**
		 *  Constructor.
		 * */
		public function SaveToCameraRoll(target:Object = null) {
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
				instanceClass = SaveToCameraRollInstance;
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
		 * Effect when add is complete 
		 * */
		public var completeEffect:Effect;
		
		/**
		 * Effect when an error occurs
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:ErrorEvent;
		
		/**
		 * Reference to the cameral roll
		 * */
		[Bindable]
		public var cameraRoll:Object;
		
		/**
		 * Bitmap data to save to the camera roll
		 * */
		[Bindable]
		public var bitmapData:BitmapData;
		
		/**
		 * If camera roll gallery is not supported we can set this property
		 * to an image for testing purposes
		 * */
		[Bindable]
		public var unsupportedTestingImage:BitmapData;
	}
}