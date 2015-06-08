

package com.flexcapacitor.effects.display.supportClasses {
	import com.flexcapacitor.effects.display.Rasterize;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.DisplayObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.core.IInvalidating;
	import mx.core.UIComponent;
	
	import spark.core.SpriteVisualElement;
	
	
	/**
	 * @copy Rasterize
	 * */
	public class RasterizeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function RasterizeInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void {
			super.play(); // dispatches startEffect
			
			var action:Rasterize = Rasterize(effect);
			var source:DisplayObject = action.source as DisplayObject;
			var targetDisplayObject:Sprite = action.drawTarget ? action.drawTarget as Sprite : action.target as Sprite;
			var transparentFill:Boolean = action.transparentFill;
			var horizontalPadding:int = action.horizontalPadding;
			var verticalPadding:int = action.verticalPadding;
			var absoluteBounds:Boolean = action.absoluteBounds;
			var smoothing:Boolean = action.smoothing;
			var fillColor:Number = action.fillColor;
			var graphicsLayer:Graphics;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!source) {
					dispatchErrorEvent("Target must be a DisplayObject. Check the source property.");
				}
				
				if (source.width==0 || source.height==0) {
					dispatchErrorEvent("Target displayObject does not have size");
				}
				
				if ((action.drawTarget && !targetDisplayObject) ||
					(action.target && !targetDisplayObject) ) {
					dispatchErrorEvent("Draw target must be a subclass of Sprite");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// remove previous bitmap
			if (action.bitmapData) {
				action.bitmapData.dispose();
			}
			
			if (!source) {
				if (action.invalidTargetEffect) {
					playEffect(action.invalidTargetEffect);
				}
				if (action.hasEventListener(Rasterize.INVALID_TARGET)) {
					dispatchActionEvent(new Event(Rasterize.INVALID_TARGET));
				}
			}
			else {
				
				try {
					if (absoluteBounds) {
						//action.bitmapData = getAbsoluteSnapshot(source, transparentFill, action.scaleX, action.scaleY, horizontalPadding, verticalPadding, fillColor, smoothing);
						action.bitmapData = DisplayObjectUtils.getBitmapDataSnapshot2(source, transparentFill, action.scaleX, action.scaleY, horizontalPadding, verticalPadding, fillColor, smoothing);
					}
					else {
						action.bitmapData = getSnapshot(source, transparentFill, action.scaleX, action.scaleY, horizontalPadding, verticalPadding, fillColor, smoothing);
					}
					
					if (action.successEffect) {
						playEffect(action.successEffect);
					}
					if (action.hasEventListener(Rasterize.SUCCESS)) {
						dispatchActionEvent(new Event(Rasterize.SUCCESS));
					}
				}
				catch (error:ErrorEvent) {
					
					action.errorEvent = error;
					
					if (action.errorEffect) {
						playEffect(action.errorEffect);
					}
					if (action.hasEventListener(Rasterize.ERROR)) {
						dispatchActionEvent(new Event(Rasterize.ERROR));
					}
				}
			}
			
			// draw snapshot to sprite
			if (targetDisplayObject) {
				targetDisplayObject.width = action.bitmapData.width;
				targetDisplayObject.height = action.bitmapData.height;
				
				graphicsLayer = targetDisplayObject.graphics;
				graphicsLayer.clear();
				graphicsLayer.beginBitmapFill(action.bitmapData, action.matrix, action.repeat, action.smoothing);
				graphicsLayer.drawRect(0, 0, action.bitmapData.width, action.bitmapData.height);
				graphicsLayer.endFill();
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * There are numerous methods here to take a snapshot. I don't know which one is best. 
		 * More tests need to be done to figure out what works. 
		 * */
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap data
		 * transformed to be identical to the target.
		 * modified
		 * @author Nick Bilyk (nbflexlib)
		 */
		public static function getSnapshot(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000, smoothing:Boolean = true):BitmapData {
			var bitmapData:BitmapData;
			var container:Sprite;
			var bounds:Rectangle;
			var bitmap:Bitmap;
			var matrix:Matrix;
			
			// get bounds
			//if (target is UIComponent && target.parent) {
			//	bounds = UIComponent(target).getVisibleRect(target.parent);
			//}
			//else {
			//	bounds = target.getRect(target);
			//}
			
			// get bounds
			bounds = target.getRect(target);
			
			// create bitmap object
			bitmapData = new BitmapData((target.width+horizontalPadding) * scaleX, (target.height + verticalPadding) * scaleY, transparentFill, fillColor);
			matrix = new Matrix();
			matrix.translate(-bounds.left+horizontalPadding/2, -bounds.top+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			
			// draw target
			bitmapData.draw(target, matrix);
			
			// 
			container = new Sprite();
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, smoothing);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			bitmapData.draw(container);
			
			return bitmapData;
			
			// added 
			bounds = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);
			
			//var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData2, PixelSnapping.ALWAYS);
			
			return bitmapData2;
		}
		
		/**
		 * Wrapped to allow error handling
		 **/
		public static function drawBitmapData(bitmapData:BitmapData, displayObject:DisplayObject, matrix:Matrix = null):void {
			bitmapData.draw(displayObject, matrix, null, null, null, true);
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap data
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * modified
		 */
		public static function getAbsoluteSnapshot(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000, smoothing:Boolean = true):BitmapData {
			var container:Sprite;
			var bitmapData:BitmapData;
			var bounds:Rectangle;
			var bitmap:Bitmap;
			var matrix:Matrix;
			
			if (target is UIComponent && target.parent) {
				//bounds = UIComponent(target).getVisibleRect(target.parent);
				bounds = UIComponent(target).getBounds(target);
			}
			else {
				bounds = target.getRect(target);
			}
			
			bitmapData = new BitmapData((target.width+horizontalPadding) * scaleX, (target.height+verticalPadding) * scaleY, transparentFill, fillColor);
			matrix = new Matrix();
			//matrix.translate(0, 0);
			matrix.translate(0+horizontalPadding/2, 0+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			bitmapData.draw(target, matrix);
			
			// 
			container = new SpriteVisualElement();
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, smoothing);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			bitmapData.draw(container);
			
			return bitmapData;
		}
		
		/**
		 * From spark BitmapImage
		 * @private
		 * Utility function used for higher quality image scaling. Essentially we
		 * simply step down our bitmap size by half resulting in a much higher result
		 * though taking potentially multiple passes to accomplish.
		 */
		protected static function resample(bitmapData:BitmapData, newWidth:uint, newHeight:uint):BitmapData {
			var finalScale:Number = Math.max(newWidth/bitmapData.width, newHeight/bitmapData.height);
			
			var finalData:BitmapData = bitmapData;
			
			if (finalScale > 1) {
				finalData = new BitmapData(bitmapData.width * finalScale, bitmapData.height * finalScale, true, 0);
				
				finalData.draw(bitmapData, new Matrix(finalScale, 0, 0, finalScale), null, null, null, true);
				
				return finalData;
			}
			
			var drop:Number = .5;
			var initialScale:Number = finalScale;
			
			while (initialScale/drop < 1)
				initialScale /= drop;
			
			var w:Number = Math.floor(bitmapData.width * initialScale);
			var h:Number = Math.floor(bitmapData.height * initialScale);
			var bd:BitmapData = new BitmapData(w, h, bitmapData.transparent, 0);
			
			bd.draw(finalData, new Matrix(initialScale, 0, 0, initialScale),
				null, null, null, true);
			finalData = bd;
			
			for (var scale:Number = initialScale * drop;
				Math.round(scale * 1000) >= Math.round(finalScale * 1000);
				scale *= drop) {
				
				w = Math.floor(bitmapData.width * scale);
				h = Math.floor(bitmapData.height * scale);
				bd = new BitmapData(w, h, bitmapData.transparent, 0);
				
				bd.draw(finalData, new Matrix(drop, 0, 0, drop), null, null, null, true);
				finalData.dispose();
				finalData = bd;
			}
			
			return finalData;
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns it in a container Sprite 
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * modified
		 */
		public static function rasterize(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000):Sprite {
			//var bounds:Rectangle = target.getBounds(target);
			var bounds:Rectangle = target.getRect(target);
			var bitmapData:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			bitmapData.draw(target, matrix);
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			return container;
		}
		
		/**
		 * Rasterize from spark BitmapImage
		 * */
		public function rasterizeDisplayObject(value:DisplayObject):BitmapData {
			var bitmapData:BitmapData;
			var tmpSprite:DisplayObject;
			
			tmpSprite = value as DisplayObject;
			
			if ((tmpSprite.width == 0 || tmpSprite.height == 0) && !tmpSprite.stage ) {
				// If our source DisplayObject has yet to be assigned a stage,
				// and doesn't have valid bounds, it is not ready to be captured,
				// so we defer bitmap capture until it is added to the display list.
				//tmpSprite.addEventListener(Event.ADDED_TO_STAGE, source_addedToStageHandler);
				return null;
			}
			
			// We must ensure any IInvalidating sources
			// are properly validated before capturing.
			if (tmpSprite is IInvalidating) {
				IInvalidating(tmpSprite).validateNow();
			}
			
			// Return immediately if our input source has 0 bounds else
			// our BitmapData constructor will RTE.
			if (tmpSprite.width == 0 || tmpSprite.height == 0) {
				return null;
			}
			
			bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
			bitmapData.draw(tmpSprite, new Matrix(), tmpSprite.transform.colorTransform);
			
			return bitmapData;
		}
	
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}