



package com.flexcapacitor.skins.transparentScroller {
	import spark.components.VScrollBar;
	import spark.skins.spark.VScrollBarSkin;
	
	/**
	 * Transparent scroller skin
	 * */
	public class TransparentVerticalScrollerSkin extends VScrollBarSkin {
		
		public function TransparentVerticalScrollerSkin() {
			super();
			alpha = 0.0;
			visible = false;
		}
		
	}
}
