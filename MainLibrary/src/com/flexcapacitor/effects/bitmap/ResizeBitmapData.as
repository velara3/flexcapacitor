

package com.flexcapacitor.effects.bitmap {
	
	import com.flexcapacitor.effects.bitmap.supportClasses.ResizeBitmapDataInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import mx.effects.IEffect;
	
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Event when resize is successful.
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 *  Event when an error occured.
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Resizes the bitmap data. 
	 * 
	 * @see com.flexcapacitor.effects.bitmap.GetBitmapData
	 * */
	public class ResizeBitmapData extends ActionEffect {
		
		public static const ERROR:String 		= "error";
		public static const SUCCESS:String 		= "success";
		
		/**
		 * Constructor
		 */
		public function ResizeBitmapData(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ResizeBitmapDataInstance;
		}
		
		/**
		 * The bitmap data or display object to resize.<br/><br/>
		 * 
		 *  @copy flash.display.IBitmapDrawable
		 */
		public function set source(value:BitmapData):void {
			if (_source == value)
				return;
			_source = value;
		}
		
		[Bindable]
		[Inspectable(category="General")]
		
		/**
		 *  @private
		 */
		public function get source():BitmapData {
			return _source;
		}
		
		private var _source:BitmapData;
		
		/**
		 *  @copy spark.primitives.BitmapImage#bitmapData
		 * */
		[Bindable]
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void {
			if (_bitmapData==value)
				return;
			
			_bitmapData = value;
		}
		
		private var _bitmapData:BitmapData;
		
		/**
		 * Effect played on success
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played on error
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * @copy flash.display.BitmapData#draw()
		 * */
		public var scale:Number;
		
		/**
		 * @copy flash.display.BitmapData#draw()
		 * */
		public var height:Number;
		
		/**
		 * @copy flash.display.BitmapData#draw()
		 * */
		public var width:Number;
		
		/**
		 * Does not throw an error when width or height is zero. 
		 * Returns null bitmap data 
		 * */
		public var allowZeroWidthHeight:Boolean;
		
		/**
		 * Quality of the resize. 
		 * 
		 * Since 11.3 additional high quality values have been made available. <br/><br/>
		 * 
		 * StageQuality.BEST<br/>
		 * StageQuality.HIGH<br/>
		 * StageQuality.HIGH_16X16<br/>
		 * StageQuality.HIGH_16X16_LINEAR<br/>
		 * StageQuality.HIGH_8X8<br/>
		 * StageQuality.HIGH_8X8_LINEAR<br/>
		 * StageQuality.MEDIUM<br/>
		 * StageQuality.LOW<br/><br/>
		 * 
		 * @copy flash.display.StageQuality
		 * */
		[Inspectable(enumeration="low,medium,high,best,8x8,8x8linear,16x16,16x16linear")]
		public var quality:String = StageQuality.BEST;
		
		
	}
}