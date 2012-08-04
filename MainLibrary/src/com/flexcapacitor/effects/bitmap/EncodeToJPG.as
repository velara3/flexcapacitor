

package com.flexcapacitor.effects.bitmap {
	
	import com.flexcapacitor.effects.bitmap.supportClasses.EncodeToJPGInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.utils.ByteArray;
	
	import spark.primitives.BitmapImage;
	
	
	
	
	public class EncodeToJPG extends ActionEffect {
		
		public static const GALLERY_UNSUPPORTED:String = "galleryUnsupported";
		
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
		public function EncodeToJPG(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = EncodeToJPGInstance;
		}
		
		/**
		 *  @copy spark.primitives.BitmapImage#source
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function set source(value:Object):void {
			if (_source == value)
				return;
			_source = value;
		}
		
		[Bindable("sourceChanged")]
		[Inspectable(category="General")]
		
		/**
		 *  @private
		 */
		public function get source():Object {
			return _source;
		}
		
		private var _source:Object;
		  
		
		/**
		 * Contains the image byte array. 
		 *  @copy spark.primitives.ByteArray
		 * 
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		[Bindable]
		public function get byteArray():ByteArray {
			return _byteArray;
		}
		
		public function set byteArray(value:ByteArray):void {
			if (_byteArray==value)
				return;
			
			_byteArray = value;
		}
		
		private var _byteArray:ByteArray;
		
		/**
		 *  Utility component for handling source data.
		 */
		public var imageDisplay:BitmapImage;
		
		/**
		 * The quality of the JPG. 100 is highest quality. Default is 70.
		 * */
		public var quality:uint = 70;
		
		
	}
}