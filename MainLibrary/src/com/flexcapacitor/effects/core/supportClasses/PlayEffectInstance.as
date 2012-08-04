

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.PlayEffect;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.effects.IEffect;
	import mx.events.EffectEvent;
	
	
	/**
	 *  @copy PlayEffect
	 */  
	public class PlayEffectInstance extends ActionEffectInstance {
		
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
		public function PlayEffectInstance(target:Object) {
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
		 */
		override public function play():void { 
			super.play();
			
			// Dispatch an effectStart event
			var action:PlayEffect = PlayEffect(effect);
			var targetEffect:IEffect = action.effect || target as IEffect;
			var resumeIfPaused:Boolean = action.resumeIfPaused;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (targetEffect==null) {
					errorMessage = "Effect is a required property";
					dispatchErrorEvent(errorMessage);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// targetEffect.isPaused is a private property on Effect so we check if isPlaying is true
			
			if (resumeIfPaused && targetEffect.isPlaying) {
				targetEffect.resume();
				finish();
				return;
			}
			else {
				playEffect(targetEffect);
				return;
			}
			
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			waitForHandlers();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Played at the end of the target effect
		 * */
		protected function effectEndHandler(event:EffectEvent):void {
			var action:PlayEffect = PlayEffect(effect);
			var targetEffect:IEffect = action.effect || action.target as IEffect;
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			targetEffect.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
	}
}