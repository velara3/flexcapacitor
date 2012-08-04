

package com.flexcapacitor.effects.bitmap.supportClasses {
	import com.flexcapacitor.effects.bitmap.EncodeToJPG;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	
	/**
	 *
	 *  
	 * */  
	public class EncodeToJPGInstance extends ActionEffectInstance {
		
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
		public function EncodeToJPGInstance(target:Object) {
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
			
			var action:EncodeToJPG = EncodeToJPG(effect);
			var byteArray:ByteArray;
			
			if (!action.source || !(action.source is BitmapData)) {
				cancel();
				throw new Error("Source is not set to any bitmap data");
			}
			
			if (action.source && (action.source.height==0 || action.source.width==0)) {
				cancel();
				throw new Error("Source width or height is zero");
			}
			
			// we could support different source types like display object
			var jpg:JPEGEncoder = new JPEGEncoder();
			byteArray = jpg.encode(BitmapData(action.source));
			
			action.byteArray = byteArray;
			
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
	
}