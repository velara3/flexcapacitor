

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.EndEffect;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.effects.IEffect;
	import mx.events.EffectEvent;
	
	
	/**
	 *  @copy EndEffect
	 */  
	public class EndEffectInstance extends ActionEffectInstance {
		
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
		public function EndEffectInstance(target:Object) {
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
			var action:EndEffect = EndEffect(effect);
			
			// IF we assign the effect to a local variable the instances don't
			// get deleted ever!? 
			//var targetEffect:IEffect = action.effect || target as IEffect;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (!action.effect && !(action.target is IEffect)) {
				errorMessage = "Set the target or effect property to the effect you want to end";
				dispatchErrorEvent(errorMessage);
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (action.effect) {
				action.effect.end();
			}
			else {
				action.target.end();
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