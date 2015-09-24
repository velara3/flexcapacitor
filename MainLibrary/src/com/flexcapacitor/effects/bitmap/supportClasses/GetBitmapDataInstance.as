

package com.flexcapacitor.effects.bitmap.supportClasses {
	import com.flexcapacitor.effects.bitmap.GetBitmapData;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.primitives.BitmapImage;
	
	
	/**
	 *
	 * @copy GetBitmapData
	 * */  
	public class GetBitmapDataInstance extends ActionEffectInstance {
		
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
		public function GetBitmapDataInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected var _loading:Boolean = false;
		
		/**
		 *  @private
		 */
		protected var _ready:Boolean = false;
		
		/**
		 *  @private
		 */
		protected var _invalid:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  bitmapImage
		//----------------------------------
		
		/**
		 *  A bitmap that defines the image content.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public var bitmap:BitmapImage;  
		
		//----------------------------------
		//  bytesLoaded
		//----------------------------------
		
		/**
		 *  @copy spark.primitives.BitmapImage#bytesLoaded
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get bytesLoaded():Number 
		{
			return bitmap ? bitmap.bytesLoaded : NaN; 
		}
		
		//----------------------------------
		//  bytesTotal
		//----------------------------------
		
		/**
		 *  @copy spark.primitives.BitmapImage#bytesTotal
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get bytesTotal():Number 
		{
			return bitmap ? bitmap.bytesTotal : NaN;
		}
		
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
			
			var action:GetBitmapData = GetBitmapData(effect);
			var padding:int = action.padding;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (action.source==null) {
					dispatchErrorEvent("Source cannot be null");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (!action.bitmapImage) {
				bitmap = new BitmapImage();
			}
			else {
				bitmap = action.bitmapImage;
			}
			
			// add listeners
			addListeners(bitmap)
			
			
			// can't find image decoding policy property
			// this may be causing us to run the next effect before load is complete
			
			// caching and caching group
			if (action.contentLoader) {
				bitmap.contentLoader = action.contentLoader;
			}
			
			if (action.contentLoaderGrouping) {
				bitmap.contentLoaderGrouping = action.contentLoaderGrouping;
			}
			
			// This may not do anything for us
			//bitmap.clearOnLoad = action.clearOnLoad;
			
			// The BitmapImage class handles multiple sources. Let it do the work
			// Multidpi images, external, local, bitmap data, display object etc 
			// Click on the bitmap source property and check it out
			
			// After setting the source we need to call the applySource() mx_internal method 
			bitmap.source = null;
			bitmap.source = action.source;
			bitmap.mx_internal::validateSource(); // testing with this method instead
			//bitmap.mx_internal::applySource();
			action.bitmapImage = bitmap;
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			if (bitmap.bitmapData) {
				onComplete();
			}
			else {
				// wait until we hear back from our listeners
				waitForHandlers();
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function bitmapImage_ioErrorHandler(event:IOErrorEvent):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			_invalid = true;
			_loading = false;
			
			removeListeners();
			
			action.ioErrorEvent = event;
			
			if (action.hasEventListener(GetBitmapData.IOERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.ioErrorEffect) {
				playEffect(action.ioErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		
		}
		
		/**
		 * Security error accessing file.
		 * */
		private function onSecurityError(event:SecurityErrorEvent):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			_invalid = true;
			_loading = false;
			
			removeListeners();
			
			action.securityErrorEvent = event;
			
			if (action.hasEventListener(GetBitmapData.SECURITY_ERROR)) {
				dispatchActionEvent(event);
			}
			
			if (action.securityErrorEffect) {
				playEffect(action.securityErrorEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * HTTP Status events
		 * */
		private function onHTTPStatus(event:HTTPStatusEvent):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			if (action.hasEventListener(GetBitmapData.HTTP_STATUS)) {
				dispatchActionEvent(event);
			}
			
			if (action.httpStatusEffect) {
				playEffect(action.httpStatusEffect);
			}
		}
		
		/**
		 * Progress events
		 *  @private
		 * */
		private function bitmapImage_progressHandler(event:ProgressEvent):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			action.progressValue = percentComplete(event.bytesLoaded, event.bytesTotal);
			
			_loading = true;
			
			action.progressEvent = event;
			
			if (action.hasEventListener(GetBitmapData.PROGRESS)) {
				dispatchActionEvent(event);
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
		}
		
		/**
		 * Ready events
		 * @private
		 * */
		private function bitmapImage_readyHandler(event:Event):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			_loading = false;
			_ready = true;
			
			if (action.hasEventListener(GetBitmapData.READY)) {
				dispatchActionEvent(event);
			}
			
			if (action.progressEffect) {
				playEffect(action.progressEffect);
			}
		}
		
		/**
		 * A image has been selected and has loaded completely.
		 * */
		private function onComplete(event:Event= null):void {
			var action:GetBitmapData = GetBitmapData(effect);
			var bitmapImage:BitmapImage;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			//bitmapData = event ? bitmapImage.bitmapData : action.bitmapImage.bitmapData;
			if (event) {
				action.bitmapData = (event.target as BitmapImage).bitmapData;
			}
			else {
				action.bitmapData = action.bitmapImage.bitmapData;
			}
			
			removeListeners();
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// NOTE: At some point we may want to consider an option to 
			// dispose of the bitmap data. Possibly through another effect 
			// that can be run later
			
			finish();
		}
		
		
		/**
		 * Add listeners.
		 * */
		private function addListeners(bitmap:BitmapImage):void {
			var action:GetBitmapData = GetBitmapData(effect);
			
			bitmap.addEventListener(IOErrorEvent.IO_ERROR, 				bitmapImage_ioErrorHandler);
			bitmap.addEventListener(ProgressEvent.PROGRESS, 			bitmapImage_progressHandler);
			bitmap.addEventListener(FlexEvent.READY, 					bitmapImage_readyHandler);
			bitmap.addEventListener(Event.COMPLETE, 					onComplete);
			bitmap.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityError);
			
			if (action.hasEventListener(HTTPStatusEvent.HTTP_STATUS)) {
				bitmap.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			}
			
		}
		
		/**
		 * Remove listeners added initially.
		 * */
		private function removeListeners():void {
			var action:GetBitmapData = GetBitmapData(effect);
			var bitmap:BitmapImage = action.bitmapImage;
			
			if (bitmap) {
				bitmap.removeEventListener(IOErrorEvent.IO_ERROR, 				bitmapImage_ioErrorHandler);
				bitmap.removeEventListener(ProgressEvent.PROGRESS, 				bitmapImage_progressHandler);
				bitmap.removeEventListener(FlexEvent.READY, 					bitmapImage_readyHandler);
				bitmap.removeEventListener(Event.COMPLETE, 						onComplete);
				bitmap.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityError);
				bitmap.removeEventListener(HTTPStatusEvent.HTTP_STATUS, 		onHTTPStatus);
			}
			
		}
		
		
		/**
		 *  @private
		 */  
		private function percentComplete(bytesLoaded:Number, bytesTotal:Number):Number {
			var value:Number = Math.ceil((bytesLoaded / bytesTotal) * 100.0);
			return isNaN(value) ? 0 : value;
		}
	}
	
	
}