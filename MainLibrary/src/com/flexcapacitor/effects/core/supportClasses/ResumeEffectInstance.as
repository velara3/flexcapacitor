

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.ResumeEffect;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.effects.IEffect;
	import mx.events.EffectEvent;
	
	
	/**
	 *  @copy ResumeEffect
	 */  
	public class ResumeEffectInstance extends ActionEffectInstance {
		
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
		public function ResumeEffectInstance(target:Object) {
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
			var action:ResumeEffect = ResumeEffect(effect);
			var targetEffect:IEffect = action.effect || target as IEffect;
			var playIfNotPaused:Boolean = action.playIfNotPaused;
			
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
			
			if (playIfNotPaused && !targetEffect.isPlaying) {
				targetEffect.addEventListener(EffectEvent.EFFECT_END, effectEndHandler, false, 0, true);
				playEffect(targetEffect);
				
				///////////////////////////////////////////////////////////
				// Wait for handlers
				///////////////////////////////////////////////////////////
				waitForHandlers();
			}
			else if (targetEffect.isPlaying) { // isPlaying is true even if it's paused
				targetEffect.resume();
			}
			else {
				// calling targetEffect.resume(); when not playing generates the following error:
				// RangeError: Error #2066: The Timer delay specified is out of range.
				// at Error$/throwError()
				// at flash.utils::Timer/set delay()
				// at mx.effects::EffectInstance/resume()
				
				
				if (action.hasEventListener(ResumeEffect.NOT_PAUSED)) {
					dispatchActionEvent(new Event(ResumeEffect.NOT_PAUSED));
				}
				
				if (action.notPausedEffect) { 
					playEffect(action.notPausedEffect);
				}
				
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			return;
			
			
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
			var action:ResumeEffect = ResumeEffect(effect);
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