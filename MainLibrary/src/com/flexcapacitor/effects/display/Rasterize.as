

package com.flexcapacitor.effects.display {
	
	import com.flexcapacitor.effects.display.supportClasses.RasterizeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.geom.Matrix;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when target is invalid
	 * */
	[Event(name="invalidTarget", type="flash.events.Event")]
	
	/**
	 * Event dispatched when capture is successful.
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched on error.
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Takes a snapshot of the source display object and copies the results
	 * into the bitmapData property. 
	 * 
	 * Optionally draws the content to the target display object.
	 * 
	 * In progress... needs review. 
	 * */
	public class Rasterize extends ActionEffect {
		
		public static const INVALID_TARGET:String = "invalidTarget";
		public static const SUCCESS:String = "success";
		public static const ERROR:String = "error";
		
		/**
		 *  Constructor.
		 * */
		public function Rasterize(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = RasterizeInstance;
		}
		
		/**
		 * Sprite duplicate of the display object
		 * */
		public var snapshot:Sprite;
		
		/**
		 * Indicates if the transparent areas are transparent or opaque
		 * */
		public var transparentFill:Boolean = true;
		
		/**
		 * 
		 * */
		public var scaleX:Number = 1;
		
		/**
		 * 
		 * */
		public var scaleY:Number = 1;
		
		/**
		 * Bitmap data of the display object. You do not set this.
		 * */
		[Bindable]
		public var bitmapData:BitmapData;
		
		/**
		 * Effect played when target is invalid
		 * */
		public var invalidTargetEffect:IEffect;
		
		/**
		 * Effect played on success
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played on error
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * Event on error
		 * */
		[Bindable]
		public var errorEvent:ErrorEvent;
		
		/**
		 * When true forces the content top and left values to be set to 0. 
		 * */
		public var absoluteBounds:Boolean;
		
		/**
		 * Draws the rasterized data to the target sprite
		 * */
		public var drawResultsToSprite:Boolean;
		
		/**
		 * Source display object to rasterize
		 * */
		public var source:DisplayObject;
		
		/**
		 * When drawing to a target sprite sets the fill mode to repeat. Default is false.
		 * */
		public var repeat:Boolean = false;
		
		/**
		 * When drawing to a target sprite sets the matrix to draw with. Default is null.
		 * */
		public var matrix:Matrix;
		
		/**
		 * When drawing to a target sprite sets the smoothing value. Default is false.
		 * */
		public var smoothing:Boolean = false;
		
		/**
		 * 
		 * */
		public var horizontalPadding:int;
		
		/**
		 * 
		 * */
		public var verticalPadding:int;
		
		/**
		 * 
		 * */
		public var fillColor:Number = 0x00000000;
		
		/**
		 * Target to draw rasterizd results too. 
		 * @private
		 * overridden here to add comments
		 * */
		override public function set target(value:Object):void {
			super.target = value;
		}
		
	}
}