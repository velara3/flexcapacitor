
package com.flexcapacitor.filters {
	
	import flash.filters.BitmapFilterQuality;
	
	import spark.filters.DropShadowFilter;
	
	/**
	 * Adds a border stroke around visible pixels in a display object
	 * 
	 * */
	public class BorderStrokeFilter extends DropShadowFilter {
		
		public static const WEIGHT_1:Array = [10, 1.1, 3];
		public static const WEIGHT_2:Array = [20, 1.5, 3];
		public static const WEIGHT_3:Array = [30, 3,   3];
		public static const WEIGHT_4:Array = [44, 4.6, 2]; // this switches to quality 2
		public static const WEIGHT_5:Array = [50, 4,   3];
		
		/**
		 * @Constructor
		 * */
		public function BorderStrokeFilter() {
			super();
			
			alpha 		= 1;
			angle 		= 45; 
			distance 	= 0;
			hideObject	= false;
			inner 		= false;
			knockout	= false;
			weight 		= 1;
		}
		
		
		/**
		 * Amount to determine strength from weight
		 * */
		public var multiplier:int = 6;
		
		private var _weight:Number;
		
		/**
		 * @private
		 * */
		public function get weight():Number {
			return _weight;
		}
		
		/**
		 * Preferred weight<br/><br/>
		 * Setting the weight above a value of 8 typically results in degraded results.
		 * Setting the filter quality to less than BitmapFilterQuality.HIGH
		 * results in degraded appearance and clipped edges.
		 * */
		public function set weight(value:Number):void {
			_weight = value;
			
			switch (value) {
				case 1: {
					strength	= WEIGHT_1[0];
					blurX=blurY	= WEIGHT_1[1];
					quality 	= WEIGHT_1[2];
					break;
				}
				case 2: {
					strength	= WEIGHT_2[0];
					blurX=blurY	= WEIGHT_2[1];
					quality 	= WEIGHT_2[2];
					break;
				}
				case 3: {
					strength	= WEIGHT_3[0];
					blurX=blurY	= WEIGHT_3[1];
					quality 	= WEIGHT_3[2];
					break;
				}
				case 4: {
					strength	= WEIGHT_4[0];
					blurX=blurY	= WEIGHT_4[1];
					quality 	= WEIGHT_4[2];
					break;
				}
				case 5: {
					strength	= WEIGHT_5[0];
					blurX=blurY	= WEIGHT_5[1];
					quality 	= WEIGHT_5[2];
					break;
				}
				default: {
					strength 	= value * multiplier;
					blurX=blurY = value;
					quality		= BitmapFilterQuality.HIGH;
					break;
				}
			}
			
			// note: quality is expected to be at BitmapFilterQuality.HIGH
			// values above or below lead to unexpected results
			// this code does not factor that in
			
			trace("weight:"+ _weight+",blur:" + blurX+",strength="+strength);
			
		}
	}
}