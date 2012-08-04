

package com.flexcapacitor.effects.bitmap {
	
	import com.flexcapacitor.effects.bitmap.supportClasses.EncodeToPNGInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.effects.IEffect;
	
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the encoding was unsuccessful. Not implemented
	 * */
	[Event(name="encodingFailed", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the bitmapData is invalid
	 * */
	[Event(name="invalidBitmapData", type="flash.events.Event")]
	
	
	/**
	 * Encodes bitmapData into PNG byte array. 
	 * Once in byte array format can be saved to file with 
	 * file.writeUTFBytes()
	 * */
	public class EncodeToPNG extends ActionEffect {
		
		public static const INVALID_BITMAP_DATA:String = "invalidBitmapData";
		
		/**
		 *  Constructor.
		 * */
		public function EncodeToPNG(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = EncodeToPNGInstance;
		}
		
		/**
		 * Set this to the bitmapData you want to encode to a PNG
		 *  @copy flash.display.BitmapData
		 * */
		[Bindable]
		public var data:BitmapData;
		
		/**
		 * Contains the encoded image byte array. 
		 * This is the data you save to a PNG file. 
		 * @copy spark.primitives.ByteArray
		 * */
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
		 * Filter value in the encoder. Not sure what it means. 
		 * */
		public var encoderFilter:int;
		
		/**
		 * Effect played when the bitmap data is invalid
		 * */
		public var invalidBitmapDataEffect:IEffect;
		
		/**
		 * Does not throw an error if bitmap data is null
		 * */
		public var allowNullData:Boolean;
		
		
	}
}