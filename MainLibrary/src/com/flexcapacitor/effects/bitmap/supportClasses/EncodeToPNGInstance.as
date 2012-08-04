

package com.flexcapacitor.effects.bitmap.supportClasses {
	import com.flexcapacitor.effects.bitmap.EncodeToPNG;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	
	/**
	 * @copy EncodeToPNG
	 * */  
	public class EncodeToPNGInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function EncodeToPNGInstance(target:Object) {
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
			
			var action:EncodeToPNG = EncodeToPNG(effect);
			var encoderFilter:int = action.encoderFilter;
			var data:BitmapData = action.data;
			var byteArray:ByteArray;
			var allowNullData:Boolean = action.allowNullData;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (   !data 
					|| !(data is BitmapData) 
					|| data.height==0 
					|| data.width==0) {
					
					if (action.invalidBitmapDataEffect 
						|| action.hasEventListener(EncodeToPNG.INVALID_BITMAP_DATA)
						|| allowNullData) {
						// let the developer handle it
					}
					else {
						// add a event handler or effect to avoid this error
						dispatchErrorEvent("Bitmap data is invalid");
					}
					
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check if data is valid
			
			if (!data 					|| 
				!(data is BitmapData) 	|| 
				data.height==0 			|| 
				data.width==0) {
				
				if (action.invalidBitmapDataEffect) {
					playEffect(action.invalidBitmapDataEffect);
				}
				
				if (action.hasEventListener(EncodeToPNG.INVALID_BITMAP_DATA)) {
					action.dispatchEvent(new Event(EncodeToPNG.INVALID_BITMAP_DATA));
				}
				
				if (allowNullData) {
					cancel("Invalid bitmap data");
					return;
				}
			}
			else {
				// we could support different source types like display object
				var png:PNGEncoder = new PNGEncoder();
				byteArray = png.encode(data);
			
				action.byteArray = byteArray;
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
	
}