

package com.flexcapacitor.effects.bitmap.supportClasses {
	import com.flexcapacitor.effects.bitmap.ResizeBitmapData;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	
	
	/**
	 *
	 * @copy GetBitmapData
	 * */  
	public class ResizeBitmapDataInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ResizeBitmapDataInstance(target:Object) {
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
			super.play();
			
			var action:ResizeBitmapData = ResizeBitmapData(effect);
			var sourceBitmapData:BitmapData = action.source;
			var allowZeroWidthHeight:Boolean = action.allowZeroWidthHeight;
			var scale:Number = action.scale;
			var width:Number = action.width;
			var height:Number = action.height;
			var quality:String = action.quality;
			var bitmapData:BitmapData;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (sourceBitmapData==null) {
					dispatchErrorEvent("Source bitmap data cannot be null");
				}
				
				if (!allowZeroWidthHeight && sourceBitmapData["width"]==0) {
					dispatchErrorEvent("Source bitmap data cannot be a width of 0");
				}
				
				if (!allowZeroWidthHeight && sourceBitmapData["height"]==0) {
					dispatchErrorEvent("Source bitmap data cannot be a height of 0");
				}
				
				if (isNaN(width) && isNaN(height) && scale==1) {
					//dispatchErrorEvent("Width and height are not numbers");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			var version:Array = Capabilities.version.split(",");
			//var supportsHighQuality:Boolean = version[0].substr(4)>11 || (version[0].substr(4)==11 && version[1]>2);
			var supportsHighQuality:Boolean = "drawWithQuality" in sourceBitmapData;
			quality = supportsHighQuality ? quality : null;
			
			// size not set - use scale
			if (isNaN(width) && isNaN(height)) {
				bitmapData = resample(sourceBitmapData, sourceBitmapData.width * scale, sourceBitmapData.height * scale, quality);
			}
			// set to explicit width
			else if (!isNaN(width) && isNaN(height)) {
				scale = width / sourceBitmapData.width;
				bitmapData = resample(sourceBitmapData, width, sourceBitmapData.height * scale, quality);
			}
			// set to explicit height
			else if (!isNaN(height) && isNaN(width)) {
				scale = height / sourceBitmapData.height;
				bitmapData = resample(sourceBitmapData, sourceBitmapData.width * scale, height, quality);
			}
			// set to explicit width and height
			else {
				bitmapData = resample(sourceBitmapData, width * scale, height * scale, quality);
			}
			
			action.bitmapData = bitmapData;
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function resizeBitmap(source:BitmapData, ratio:Number): BitmapData {
		    var bitmapData:BitmapData = new BitmapData(source.width * ratio, source.height * ratio);
		    var matrix:Matrix = new Matrix();   
		    matrix.scale(ratio, ratio);
		    bitmapData['drawWithQuality'](source, matrix);
		    return bitmapData;
		}
		
	    /**
	     * @private
	     * Utility function used for higher quality image scaling. Essentially we
	     * simply step down our bitmap size by half resulting in a much higher result
	     * though taking potentially multiple passes to accomplish.
		 * 
		 * source spark.primitives.BitmapImage
	     */
	    protected static function resample(bitmapData:BitmapData, newWidth:uint,
	                                       newHeight:uint, quality:String = null):BitmapData
	    {
			
	        var finalScale:Number = Math.max(newWidth/bitmapData.width,
	            newHeight/bitmapData.height);
	
	        var finalData:BitmapData = bitmapData;
	
			// ERROR HERE MEANS
			// Property drawWithQuality not found on flash.display.BitmapData and there is no default value.
			// 
			// Solution
			// add -swf-version=16 or greater to your compiler arguments
			// 
			// https://bugbase.adobe.com/index.cfm?event=bug&id=3219149
	        if (finalScale > 1)
	        {
	            finalData = new BitmapData(bitmapData.width * finalScale,
	                bitmapData.height * finalScale, true, 0);
	
				if (quality) {
					finalData['drawWithQuality'](bitmapData, new Matrix(finalScale, 0, 0,
		                finalScale), null, null, null, true, quality);
				}
				else {
		            finalData.draw(bitmapData, new Matrix(finalScale, 0, 0,
		                finalScale), null, null, null, true);
				}
	
	            return finalData;
	        }
	
	        var drop:Number = .5;
	        var initialScale:Number = finalScale;
	
	        while (initialScale/drop < 1)
	            initialScale /= drop;
	
	        var w:Number = Math.floor(bitmapData.width * initialScale);
	        var h:Number = Math.floor(bitmapData.height * initialScale);
	        var bd:BitmapData = new BitmapData(w, h, bitmapData.transparent, 0);
	
			if (quality) {
				bd['drawWithQuality'](finalData, new Matrix(initialScale, 0, 0, initialScale),
            		null, null, null, true, quality);
			}
			else {
		        bd.draw(finalData, new Matrix(initialScale, 0, 0, initialScale),
		            null, null, null, true);
			}
			
	        finalData = bd;
	
	        for (var scale:Number = initialScale * drop;
	            Math.round(scale * 1000) >= Math.round(finalScale * 1000);
	            scale *= drop)
	        {
	            w = Math.floor(bitmapData.width * scale);
	            h = Math.floor(bitmapData.height * scale);
	            bd = new BitmapData(w, h, bitmapData.transparent, 0);
	
				
				if (quality) {
	            	bd['drawWithQuality'](finalData, new Matrix(drop, 0, 0, drop), null, null, null, true, quality);
				}
				else {
	            	bd.draw(finalData, new Matrix(drop, 0, 0, drop), null, null, null, true);
				}
				
	            finalData.dispose();
	            finalData = bd;
	        }
	
	        return finalData;
	    }
	}
	
	
}