package com.flexcapacitor.controls
{
	import spark.components.BorderContainer;
	
	[Style(name="borderJoints", type="String", inherit="no", enumeration="round,miter,bevel", defaultValue="miter")]
	[Style(name="borderCaps", type="String", inherit="no", enumeration="round,square,none", defaultValue="round")]
	[Style(name="borderMiterLimit", type="Number", inherit="no", defaultValue="3")]
	[Style(name="borderPixelHinting", type="Boolean", inherit="no", defaultValue="false")]
	[Style(name="borderScaleMode", type="String", inherit="no", enumeration="normal,horizontal,vertical,none", defaultValue="normal")]
	
	/**
	 *  This BorderContainer class extends the Spark BorderContainer and adds 
	 *  an additional set of CSS styles that control
	 *  the appearance of the border and background fill of the container.
	 *
	 *  <p><b>Note: </b>Because you use CSS styles and class properties to control 
	 *  the appearance of the BorderContainer, you typically do not create a custom skin for it.
	 *  If you do create a custom skin, your skin class should apply any styles to control the 
	 *  appearance of the container.</p>
	 *  
	 *  <p>The BorderContainer container has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>112 pixels wide by 112 pixels high</td></tr>
	 *     <tr><td>Minimum size</td><td>30 pixels wide by 30 pixels high</td></tr>
	 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
	 *     <tr><td>Default skin class</td><td>com.flexcapacitor.skins.BorderContainerSkin</td></tr>
	 *  </table>
	 *
	 *
	 *  <p>The <code>&lt;s:BorderContainer&gt;</code> tag inherits all the tag attributes
	 *  of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:BorderContainer
	 *    <b>Properties</b>
	 *    backgroundFill="null"
	 *    borderStroke="null"
	 * 
	 *    <b>Styles</b>
	 *    backgroundImage="undefined"
	 *    backgroundImageFillMode="scale"
	 *    borderAlpha="1.0"
	 *    borderColor="0xB7BABC"
	 *    borderStyle="solid"
	 *    borderVisible="true"
	 *    borderWeight="1"
	 *    borderJoints="miter"
	 *    borderCaps="rount"
	 *    borderMiterLimit="3"
	 *    borderPixelHinting="false"
	 *    borderScaleMode="normal"
	 *    cornerRadius="0"
	 *    dropShadowVisible="false"
	 *  /&gt;
	 *  </pre>
	 * 
	 *  @see com.flexcapacitor.skins.BorderContainerSkin
	 *  @includeExample examples/BorderContainerExample.mxml
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 * */
	public class BorderContainer extends spark.components.BorderContainer
	{
		public function BorderContainer()
		{
		}
	}
}