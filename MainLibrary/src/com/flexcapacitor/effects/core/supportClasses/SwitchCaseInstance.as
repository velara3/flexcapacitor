

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.SwitchCase;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.effects.IEffect;
	
	
	/**
	 *  @copy SwitchEffects
	 * */  
	public class SwitchCaseInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SwitchCaseInstance(target:Object) {
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
			
			var action:SwitchCase = SwitchCase(effect);
			var effects:Array = action.effects;
			var values:Array = action.values;
			var value:Object = action.value;
			var effectsCount:uint = effects ? effects.length : 0;
			var valuesCount:uint = values ? values.length : 0;
			var arrayValue:Object;
			var targetEffect:IEffect;
			var effectInstance:IEffect;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (effectsCount!==valuesCount) {
					dispatchErrorEvent("The amount of values do not equal the amount of effects.");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// loop through values and check for a match
			for (var i:int;i<valuesCount;i++) {
				arrayValue = values[i];
				
				// match found
				if (arrayValue==value) {
					targetEffect = IEffect(effects[i]);
					
					// stop previous effect if playing
					for (var j:int;j<valuesCount;j++) {
						effectInstance = IEffect(effects[j]);
						if (effectInstance && 
							effectInstance.isPlaying && 
							targetEffect!=effectInstance) {
							effectInstance.end();
						}
					}
					
					// play corresponding effect
					playEffect(targetEffect);
				}
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