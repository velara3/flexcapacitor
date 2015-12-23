

package com.flexcapacitor.skins
{
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	
	import mx.graphics.BitmapFill;
	import mx.graphics.RectangularDropShadow;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.states.SetProperty;
	import mx.states.State;
	import mx.utils.GraphicsUtil;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.supportClasses.Skin;
	import spark.primitives.Path;
	import spark.primitives.Rect;
	
	
	/** 
	 * @copy spark.skins.spark.ApplicationSkin#hostComponent
	 */
	[HostComponent("com.flexcapacitor.controls.BorderContainer")]
	
	[States("normal", "disabled")]
	
	/**
	 *  A border container with sides property.
	 * 
	 *  @see spark.components.BorderContainer
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4 
	 */ 
	public class BorderContainerSkin extends Skin
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function BorderContainerSkin()
		{
			super();
			
			minWidth = 30;
			minHeight = 30;
			
			states = [
				new State({name:"normal"}), 
				new State({name:"disabled", 
					overrides:[new SetProperty(this, "alpha", 0.5)]})
			];
		}
		
		/**
		 *  The required skin part for SkinnableContainer 
		 */ 
		[Bindable]
		public var contentGroup:Group;
		
		private var bgRect:Rect;
		private var insetPath:Path;
		private var rds:RectangularDropShadow;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			bgRect = new Rect();
			addElementAt(bgRect, 0);
			bgRect.left = bgRect.top = bgRect.right = bgRect.bottom = 0;
			
			contentGroup = new Group();
			addElement(contentGroup);  
			
			insetPath = new Path();
			addElement(insetPath);
		}
		
		
		/**
		 *  @private 
		 */ 
		override protected function measure():void
		{	    
			measuredWidth = contentGroup.measuredWidth;
			measuredHeight = contentGroup.measuredHeight;
			measuredMinWidth = contentGroup.measuredMinWidth;
			measuredMinHeight = contentGroup.measuredMinHeight;
			
			var borderWeight:Number = getStyle("borderWeight");
			
			if (hostComponent && hostComponent.borderStroke)
				borderWeight = hostComponent.borderStroke.weight;
			
			if (borderWeight > 0)
			{
				var borderSize:int = borderWeight * 2;
				measuredWidth += borderSize;
				measuredHeight += borderSize;
				measuredMinWidth += borderSize;
				measuredMinHeight += borderSize;
			}
		}
		
		/**
		 *  @private 
		 */ 
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
		{
			graphics.clear();
			
			var borderWeight:int;
			var borderStyle:String = getStyle("borderStyle");
			var borderVisible:Boolean = getStyle("borderVisible");
			var cornerRadius:Number = getStyle("cornerRadius");
			var borderSides:String = getStyle("borderSides");;
			var bRoundedCorners:Boolean = getStyle("roundedBottomCorners").toString().toLowerCase() == "true";
			var bHasAllSides:Boolean = true;
			var radiusObj:Object;
			var borderColor:Number = getStyle("borderColor");
			var borderAlpha:Number = getStyle("borderAlpha");
			
			
			// BORDER //
			if (hostComponent && hostComponent.borderStroke) {
				borderWeight = hostComponent.borderStroke.weight;
			}
			else {
				borderWeight = getStyle("borderWeight");
			}
			
			if (!borderVisible) {
				borderWeight = 0;
			}
			
			if (isNaN(borderWeight)) {
				borderWeight = 1;
			}
			
			// new ////////
			// TODO: Add support for corner radius for each corner
			if (borderWeight!=0 && borderSides != "left top right bottom") {
				var holeRadius:Number = Math.max(cornerRadius - borderWeight, 0);
				
				var hole:Object = { x: borderWeight,
					y: borderWeight,
					w: unscaledWidth - borderWeight * 2,
						h: unscaledHeight - borderWeight * 2,
						r: holeRadius };
				
				if (!bRoundedCorners) {
					radiusObj = {tl:cornerRadius, tr:cornerRadius, bl:0, br:0};
					hole.r = {tl:holeRadius, tr:holeRadius, bl:0, br:0};
				}
				
				// Convert the radius values from a scalar to an object
				// because we need to adjust individual radius values
				// if we are missing any sides.
				hole.r = { tl: holeRadius,
					tr: holeRadius,
					bl: bRoundedCorners ? holeRadius : 0,
						br: bRoundedCorners ? holeRadius : 0 };
				
				radiusObj = { tl: cornerRadius,
					tr: cornerRadius,
					bl: bRoundedCorners ? cornerRadius : 0,
						br: bRoundedCorners ? cornerRadius : 0};
				
				borderSides = borderSides.toLowerCase();
				
				if (borderSides.indexOf("left") == -1) {
					hole.x = 0;
					hole.w += borderWeight;
					hole.r.tl = 0;
					hole.r.bl = 0;
					radiusObj.tl = 0;
					radiusObj.bl = 0;
					bHasAllSides = false;
					contentGroup.setStyle("left", borderWeight);
				}
				
				if (borderSides.indexOf("top") == -1) {
					hole.y = 0;
					hole.h += borderWeight;
					hole.r.tl = 0;
					hole.r.tr = 0;
					radiusObj.tl = 0;
					radiusObj.tr = 0;
					bHasAllSides = false;
					contentGroup.setStyle("top", borderWeight);
				}
				
				if (borderSides.indexOf("right") == -1) {
					hole.w += borderWeight;
					hole.r.tr = 0;
					hole.r.br = 0;
					radiusObj.tr = 0;
					radiusObj.br = 0;
					bHasAllSides = false;
					contentGroup.setStyle("right", borderWeight);
				}
				
				if (borderSides.indexOf("bottom") == -1) {
					hole.h += borderWeight;
					hole.r.bl = 0;
					hole.r.br = 0;
					radiusObj.bl = 0;
					radiusObj.br = 0;
					bHasAllSides = false;
					contentGroup.setStyle("bottom", borderWeight);
				}
			}
			else {
				contentGroup.setStyle("left", borderWeight);
				contentGroup.setStyle("right", borderWeight);
				contentGroup.setStyle("top", borderWeight);
				contentGroup.setStyle("bottom", borderWeight);
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// update the bgRect stroke/fill
			if (hostComponent && hostComponent.borderStroke)
			{
				bgRect.stroke = hostComponent.borderStroke;
			}
			else if (!borderVisible)
			{
				bgRect.stroke = null;
			}
			else if (bHasAllSides)  {
				var borderJoints:String = getStyle("borderJoints");
				var borderCaps:String = getStyle("borderCaps");
				var borderMiterLimit:Number = getStyle("borderMiterLimit");
				var borderPixelHinting:String = getStyle("borderPixelHinting");
				var borderScaleMode:String = getStyle("borderScaleMode");
				var stroke:SolidColorStroke;
				
				if (!isNaN(borderColor))
				{
					if (isNaN(borderAlpha)) {
						borderAlpha = 1;
					}
					
					stroke = new SolidColorStroke(borderColor, borderWeight, borderAlpha);
					
					
					// Setting defaults if style is undefined
					// set default to miter
					if (borderJoints==null) {
						borderJoints = JointStyle.MITER;
					}
					
					stroke.joints = borderJoints;
					
					if (borderCaps==null) {
						borderCaps = CapsStyle.ROUND;
					}
					
					stroke.caps = borderCaps;
					
					if (isNaN(borderMiterLimit)) {
						borderMiterLimit = 3;
					}
					
					stroke.miterLimit = borderMiterLimit;
					
					if (borderPixelHinting==null) {
						borderPixelHinting = "false";
					}
					else {
						borderPixelHinting = "true";
					}
					
					stroke.pixelHinting = borderPixelHinting=="true" ? true : false;
					
					if (borderScaleMode==null) {
						borderScaleMode = LineScaleMode.NORMAL;
					}
					
					stroke.scaleMode = borderScaleMode;
					
					bgRect.stroke = stroke;
				}
			}
			else if (radiusObj) { // draw border sides
				drawRoundRectSides( 0, 0, unscaledWidth, unscaledHeight, radiusObj,
					borderColor, 1,
					null, null, null, hole);
				
				// Reset radius here so background drawing
				// below is correct.
				radiusObj.tl = Math.max(cornerRadius - borderWeight, 0);
				radiusObj.tr = Math.max(cornerRadius - borderWeight, 0);
				radiusObj.bl = bRoundedCorners ? Math.max(cornerRadius - borderWeight, 0) : 0;
				radiusObj.br = bRoundedCorners ? Math.max(cornerRadius - borderWeight, 0) : 0;
			}
			
			
			// BACKGROUND FILL 
			if (hostComponent && hostComponent.backgroundFill)
			{
				bgRect.fill = hostComponent.backgroundFill;
			}
			else
			{
				var bgImage:Object = getStyle("backgroundImage");
				
				if (bgImage)
				{
					var bitmapFill:BitmapFill = bgRect.fill is BitmapFill ? BitmapFill(bgRect.fill) : new BitmapFill();
					
					bitmapFill.source = bgImage;
					bitmapFill.fillMode = getStyle("backgroundImageFillMode");
					bitmapFill.alpha = getStyle("backgroundAlpha");
					
					bgRect.fill = bitmapFill;
				}
				else
				{
					var bkgdColor:Number = getStyle("backgroundColor");
					var bkgdAlpha:Number = getStyle("backgroundAlpha");
					
					if (isNaN(bkgdAlpha))
						bkgdAlpha = 1;
					
					if (!isNaN(bkgdColor))
						bgRect.fill = new SolidColor(bkgdColor, bkgdAlpha);
					else
						bgRect.fill = new SolidColor(0, 0);
				}
			}
			
			// Draw the shadow for the inset style
			if (borderStyle == "inset" && hostComponent && hostComponent.borderStroke == null && borderVisible)
			{            
				var negCR:Number = -cornerRadius;
				var path:String = ""; 
				
				if (cornerRadius > 0 && borderWeight < 10)
				{
					// Draw each corner with two quadratics, using the following ratios:
					var a:Number = cornerRadius * 0.292893218813453;
					var s:Number = cornerRadius * 0.585786437626905;
					var right:Number = unscaledWidth - borderWeight;
					
					path += "M 0 " + cornerRadius; // M 0 CR
					path += " Q 0 " + s + " " + a + " " + a; // Q 0 s a a 
					path += " Q " + s + " 0 " + cornerRadius + " 0"; // Q s 0 CR 0
					path += " L " + (right - cornerRadius) + " 0"; // L (right-CR) 0
					path += " Q " + (right - s) + " 0 " + (right - a) + " " + a; // Q (right-s) 0 (right-a) a
					path += " Q " + right + " " + s + " " + right + " " + cornerRadius; // Q right s right CR   
					insetPath.height = cornerRadius;
				}
				else
				{
					path += "M 0 0";
					path += " L " + (unscaledWidth - borderWeight) + " 0";
					insetPath.height = 1; 
				}
				
				insetPath.x = borderWeight;
				insetPath.y = borderWeight;
				insetPath.width = unscaledWidth - (borderWeight * 2);
				insetPath.data = path;
				insetPath.stroke = new SolidColorStroke(0x000000, 1, .12);
			}
			else
			{
				insetPath.data = "";
				insetPath.stroke = null;
			}
			
			bgRect.radiusX = bgRect.radiusY = cornerRadius; 
			
			//super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (getStyle("dropShadowVisible") == true)
			{
				if (!rds)
					rds = new RectangularDropShadow();
				
				rds.alpha = 0.4;
				rds.angle = 90;
				rds.color = 0x000000;
				rds.distance = 5;
				rds.tlRadius = rds.trRadius = rds.blRadius = rds.brRadius = cornerRadius + 1;
				
				graphics.lineStyle();
				rds.drawShadow(graphics, 0, 0, unscaledWidth, unscaledHeight);
			}
		}
		
		/**
		 *  Programatically draws a rectangle into this skin's Graphics object.
		 *
		 *  <p>The rectangle can have rounded corners.
		 *  Its edges are stroked with the current line style
		 *  of the Graphics object.
		 *  It can have a solid color fill, a gradient fill, or no fill.
		 *  A solid fill can have an alpha transparency.
		 *  A gradient fill can be linear or radial. You can specify
		 *  up to 15 colors and alpha values at specified points along
		 *  the gradient, and you can specify a rotation angle
		 *  or transformation matrix for the gradient.
		 *  Finally, the rectangle can have a rounded rectangular hole
		 *  carved out of it.</p>
		 *
		 *  <p>This versatile rectangle-drawing routine is used by many skins.
		 *  It calls the <code>drawRect()</code> or
		 *  <code>drawRoundRect()</code>
		 *  methods (in the flash.display.Graphics class) to draw into this
		 *  skin's Graphics object.</p>
		 *
		 *	@param x Horizontal position of upper-left corner
		 *  of rectangle within this skin.
		 *
		 *	@param y Vertical position of upper-left corner
		 *  of rectangle within this skin.
		 *
		 *	@param width Width of rectangle, in pixels.
		 *
		 *	@param height Height of rectangle, in pixels.
		 *
		 *	@param cornerRadius Corner radius/radii of rectangle.
		 *  Can be <code>null</code>, a Number, or an Object.
		 *  If it is <code>null</code>, it specifies that the corners should be square
		 *  rather than rounded.
		 *  If it is a Number, it specifies the same radius, in pixels,
		 *  for all four corners.
		 *  If it is an Object, it should have properties named
		 *  <code>tl</code>, <code>tr</code>, <code>bl</code>, and
		 *  <code>br</code>, whose values are Numbers specifying
		 *  the radius, in pixels, for the top left, top right,
		 *  bottom left, and bottom right corners.
		 *  For example, you can pass a plain Object such as
		 *  <code>{ tl: 5, tr: 5, bl: 0, br: 0 }</code>.
		 *  The default value is null (square corners).
		 *
		 *	@param color The RGB color(s) for the fill.
		 *  Can be <code>null</code>, a uint, or an Array.
		 *  If it is <code>null</code>, the rectangle not filled.
		 *  If it is a uint, it specifies an RGB fill color.
		 *  For example, pass <code>0xFF0000</code> to fill with red.
		 *  If it is an Array, it should contain uints
		 *  specifying the gradient colors.
		 *  For example, pass <code>[ 0xFF0000, 0xFFFF00, 0x0000FF ]</code>
		 *  to fill with a red-to-yellow-to-blue gradient.
		 *  You can specify up to 15 colors in the gradient.
		 *  The default value is null (no fill).
		 *
		 *	@param alpha Alpha value(s) for the fill.
		 *  Can be null, a Number, or an Array.
		 *  This argument is ignored if <code>color</code> is null.
		 *  If <code>color</code> is a uint specifying an RGB fill color,
		 *  then <code>alpha</code> should be a Number specifying
		 *  the transparency of the fill, where 0.0 is completely transparent
		 *  and 1.0 is completely opaque.
		 *  You can also pass null instead of 1.0 in this case
		 *  to specify complete opaqueness.
		 *  If <code>color</code> is an Array specifying gradient colors,
		 *  then <code>alpha</code> should be an Array of Numbers, of the
		 *  same length, that specifies the corresponding alpha values
		 *  for the gradient.
		 *  In this case, the default value is <code>null</code> (completely opaque).
		 *
		 *  @param gradientMatrix Matrix object used for the gradient fill. 
		 *  The utility methods <code>horizontalGradientMatrix()</code>, 
		 *  <code>verticalGradientMatrix()</code>, and
		 *  <code>rotatedGradientMatrix()</code> can be used to create the value for 
		 *  this parameter.
		 *
		 *	@param gradientType Type of gradient fill. The possible values are
		 *  <code>GradientType.LINEAR</code> or <code>GradientType.RADIAL</code>.
		 *  (The GradientType class is in the package flash.display.)
		 *
		 *	@param gradientRatios (optional default [0,255])
		 *  Specifies the distribution of colors. The number of entries must match
		 *  the number of colors defined in the <code>color</code> parameter.
		 *  Each value defines the percentage of the width where the color is 
		 *  sampled at 100%. The value 0 represents the left-hand position in 
		 *  the gradient box, and 255 represents the right-hand position in the 
		 *  gradient box. 
		 *
		 *	@param hole (optional) A rounded rectangular hole
		 *  that should be carved out of the middle
		 *  of the otherwise solid rounded rectangle
		 *  { x: #, y: #, w: #, h: #, r: # or { br: #, bl: #, tl: #, tr: # } }
		 *
		 *  @see flash.display.Graphics#beginGradientFill()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function drawRoundRectSides(
			x:Number, y:Number, width:Number, height:Number,
			cornerRadius:Object = null,
			color:Object = null,
			alpha:Object = null,
			gradientMatrix:Matrix = null,
			gradientType:String = "linear",
			gradientRatios:Array /* of Number */ = null,
			hole:Object = null):void
		{
			var g:Graphics = graphics;
			
			// Quick exit if weight or height is zero.
			// This happens when scaling a component to a very small value,
			// which then gets rounded to 0.
			if (width == 0 || height == 0)
				return;
			
			// If color is an object then allow for complex fills.
			if (color !== null)
			{
				if (color is uint)
				{
					g.beginFill(uint(color), Number(alpha));
				}
				else if (color is Array)
				{
					var alphas:Array = alpha is Array ?
						alpha as Array :
						[ alpha, alpha ];
					
					if (!gradientRatios)
						gradientRatios = [ 0, 0xFF ];
					
					g.beginGradientFill(gradientType,
						color as Array, alphas,
						gradientRatios, gradientMatrix);
				}
			}
			
			var ellipseSize:Number;
			
			// Stroke the rectangle.
			if (!cornerRadius)
			{
				g.drawRect(x, y, width, height);
			}
			else if (cornerRadius is Number)
			{
				ellipseSize = Number(cornerRadius) * 2;
				g.drawRoundRect(x, y, width, height, 
					ellipseSize, ellipseSize);
			}
			else
			{
				GraphicsUtil.drawRoundRectComplex(g,
					x, y, width, height,
					cornerRadius.tl, cornerRadius.tr,
					cornerRadius.bl, cornerRadius.br);
			}
			
			// Carve a rectangular hole out of the middle of the rounded rect.
			if (hole)
			{
				var holeR:Object = hole.r;
				if (holeR is Number)
				{
					ellipseSize = Number(holeR) * 2;
					g.drawRoundRect(hole.x, hole.y, hole.w, hole.h, 
						ellipseSize, ellipseSize);
				}
				else
				{
					GraphicsUtil.drawRoundRectComplex(g,
						hole.x, hole.y, hole.w, hole.h,
						holeR.tl, holeR.tr, holeR.bl, holeR.br);
				}	
			}
			
			if (color !== null)
				g.endFill();
		}
	}
}

