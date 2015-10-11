package com.flexcapacitor.controls
{
	import spark.components.ButtonBar;
	
	[Style(name="borderAlpha", type="Number", inherit="no", max="1", min="0")]
	[Style(name="fillAlpha", type="Number", inherit="no", max="1", min="0")]
	
	/**
	 * Button bar that uses solid fill skin.
	 * Added borderAlpha style and fillAlpha.
	 * Use chromeColor style to transform the color.
	 * */
	public class SolidFillButtonBar extends ButtonBar
	{
		public function SolidFillButtonBar()
		{
			super();
		}
	}
}