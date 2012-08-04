

package com.flexcapacitor.effects.slider {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Changes the value of the slider by the snap interval. 
	 * 
	 * @copy spark.components.supportClasses.SliderBase.changeValueByStep()
	 * */
	public class ChangeValueByStep extends ActionEffect {
		
		
		/**
		 * 
		 * */
		public function ChangeValueByStep(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ChangeValueByStepInstance;
		}
		
		/**
		 * @copy spark.components.supportClasses.SliderBase.changeValueByStep()
		 * */
		public var increase:Boolean;
		
	}
}



	import com.flexcapacitor.effects.slider.ChangeValueByStep;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import spark.components.supportClasses.SliderBase;
	
	/**
	 * 
	 */  
	internal class ChangeValueByStepInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * */
		public function ChangeValueByStepInstance(target:Object) {
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
			// Dispatch an effectStart event
			super.play();
			
			var action:ChangeValueByStep = ChangeValueByStep(effect);
			var target:SliderBase = action.target as SliderBase;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!target) {
					errorMessage = "The target cannot be null";
					dispatchErrorEvent(errorMessage);
				}
					
					// check if target property exists on target
				else if (!(target is SliderBase)) {
					errorMessage = "The target must be a Slider";
					dispatchErrorEvent(errorMessage);
				}
					
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			target.changeValueByStep(action.increase);
			
			
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
