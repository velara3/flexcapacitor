package com.flexcapacitor.controls
{
	import spark.components.ToggleButton;
	
	/**
	 * Image source. Can be any source BitmapImage can support.
	 * */
	[Style(name="source", type="Object")]
	
	/**
	 * Background color
	 * */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * Background color alpha
	 * */
	[Style(name="backgroundAlpha", type="Number", inherit="no", max="1", min="0")]
	
	/**
	 * Scale mode for image
	 * */
	[Style(name="scaleMode", type="String", enumeration="stretch,letterbox,zoom", defaultValue="letterbox")]
	
	/**
	 * Show the background fill only when selected
	 * */
	[Style(name="showBackgroundWhenSelected", type="String", enumeration="true,false")]
	
	/**
	 * Toggle Button that uses an image as source.
	 * */
	public class BeveledImageToggleButton extends ToggleButton
	{
		public function BeveledImageToggleButton()
		{
			super();
			
			buttonMode = true;
		}
	}
}