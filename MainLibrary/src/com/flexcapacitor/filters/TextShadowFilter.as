
package com.flexcapacitor.filters {
	
	import spark.filters.DropShadowFilter;
	
	/**
	 * Adds an inner shadow to text.
	 * 
	 * On text greater than 28pt you may increase the 
	 * blurY to 2.
	 * */
	public class TextShadowFilter extends DropShadowFilter {
		
		public function TextShadowFilter() {
			super();
			
			alpha 		= .75; 
			angle 		= 90; 
			blurX 		= 0;
			blurY 		= 0; 
			color		= 0xFFFFFF;			
			distance 	= 1; 
			hideObject	= false;
			inner 		= false;
			knockout	= false;
			quality		= 2; 
			strength	= 1;
		}
	}
}