

package com.flexcapacitor.effects.compatibility {
	
	import com.flexcapacitor.effects.compatibility.supportClasses.IsCameraRollAvailableInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.events.EffectEvent;
	
	import mx.effects.Effect;
	import mx.managers.SystemManager;
	
	
	/**
	 * Event dispatched when the device supports browse for image
	 * */
	[Event(name="supportsBrowseForImage", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the device does NOT support browse for image
	 * */
	[Event(name="browseForImageNotSupported", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the device supports adding bitmap data
	 * */
	[Event(name="supportsAddBitmapData", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the device does NOT support adding bitmap data
	 * */
	[Event(name="addBitmapDataNotSupported", type="flash.events.Event")]
	
	/**
	 * Checks if the device supports the CameraRoll features of opening an image 
	 * from the image gallery and saving an image back to the image gallery.
	 * */
	public class IsCameraRollAvailable extends ActionEffect {
		
		/**
		 * Event name constant 
		 * */
		public static const SUPPORTS_BROWSE:String = "supportsBrowse";
		
		/**
		 * Event name constant 
		 * */
		public static const SUPPORTS_ADD_BITMAP_DATA:String = "supportsAddBitmapData";
		
		/**
		 * Event name constant 
		 * */
		public static const BROWSE_NOT_SUPPORTED:String = "browseNotSupported";
		
		/**
		 * Event name constant 
		 * */
		public static const ADD_BITMAP_DATA_NOT_SUPPORTED:String = "addBitmapDataNotSupported";
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function IsCameraRollAvailable(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			classDefinition = "flash.media.CameraRoll";
			
			instanceClass = IsCameraRollAvailableInstance;
			
		}
		
		/**
		 * Name of class to check for. For example, "flash.media.CameraRoll".
		 * The name of the class is searched for in the application domain. 
		 * */
		public var classDefinition:String;
		
		/**
		 * Reference to the class if it was found
		 * */
		public var classReference:Class;
		
		/**
		 * Effect that is played if device supports saving bitmap data to 
		 * the image gallery. 
		 * */
		public var supportsAddBitmapDataEffect:Effect;
		
		/**
		 * Effect that is played if device supports opening an image
		 * from the image gallery.
		 * */
		public var supportsBrowseForImageEffect:Effect;
		
		/**
		 * Effect that is played if device does NOT support the CameraRoll 
		 * or opening an image from the camera roll / image gallery.
		 * */
		public var browseForImageNotSupportedEffect:Effect;
		
		/**
		 * Effect that is played if device does NOT support the CameraRoll 
		 * or saving an image to the camera roll / image gallery. 
		 * */
		public var addBitmapDataNotSupportedEffect:Effect;
	}
}