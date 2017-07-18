


package com.flexcapacitor.filters {
	
	import spark.filters.ConvolutionFilter;
	
	/**
	 * Sharpen filter
	 * */
	public class SharpenFilter extends ConvolutionFilter {
		
		
		public var sharpenMatrix:Array = [0, -1, 0,
										 -1, 5, -1,
										  0, -1, 0];
		
		public function SharpenFilter() {
			super();
			
			matrixX = 3;
			matrixY = 3;
			divisor = 1;
			matrix = sharpenMatrix;
		}
		
	}
}