

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.ToggleEffects;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.effects.IEffect;
	
	
	/**
	 *  @copy ToggleEffects
	 * */  
	public class ToggleEffectsInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ToggleEffectsInstance(target:Object) {
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
			super.play(); // Dispatch an effectStart event
			
			var action:ToggleEffects = ToggleEffects(effect);
			var effects:Array = action.effects;
			var endPreviousEffectIfPlaying:Boolean = action.endPreviousEffectIfPlaying;
			var length:int = effects.length;
			var effectIndex:int;
			var index:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!effects || length<2) {
					dispatchErrorEvent("At least two effects must be provided.");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// get index of current effect
			index = action.lastEffectPlayedIndex;
			
			// if we are at the last index set to the first index
			if (index >= length-1) {
				effectIndex = 0;
			}
			else {
				// get next index
				effectIndex = index+1;
			}
			
			action.lastEffectPlayedIndex = effectIndex;
			
			// play the next effect
			if (effectIndex<=length-1) {
				
				// stop previous effect if playing
				if (endPreviousEffectIfPlaying && 
					effects[index] && 
					IEffect(effects[index]).isPlaying) {
					IEffect(effects[index]).end();
				}
				
				playEffect(effects[effectIndex]);
				return;
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
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