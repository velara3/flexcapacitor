


package com.flexcapacitor.filters {
	
	import spark.filters.ColorMatrixFilter;
	

	/**
	 * Black and white filter
	 * */
	public class BlackAndWhiteFilter extends ColorMatrixFilter {
		private var r:Number = 0.2225;
		private var g:Number = 0.7169;
		private var b:Number = 0.0606;
		
		public var blackWhiteMatrix:Array = 
			   [r, g, b, 0, 0, 
				r, g, b, 0, 0, 
				r, g, b, 0, 0,		
				0, 0, 0, 1, 0];
		
		public function BlackAndWhiteFilter(matrix:Array=null) {
			super(blackWhiteMatrix);
		}
		/*
		override public function clone():BitmapFilter {
			return new com.flexcapacitor.filters.BlackAndWhiteFilter(blackWhiteMatrix);
		}*/
	}
}