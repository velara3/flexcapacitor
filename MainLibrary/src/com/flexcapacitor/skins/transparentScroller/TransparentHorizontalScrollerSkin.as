



package com.flexcapacitor.skins.transparentScroller {
	import spark.components.HScrollBar;
	import spark.skins.spark.HScrollBarSkin;
	
	/**
	 * Transparent scroller skin
	 * */
	public class TransparentHorizontalScrollerSkin extends HScrollBarSkin {
		
		public function TransparentHorizontalScrollerSkin() {
			super();
			alpha = 0.0;
			visible = false;
		}
		
	}
}
