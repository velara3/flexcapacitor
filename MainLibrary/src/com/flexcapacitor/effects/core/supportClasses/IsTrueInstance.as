

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.IsTrue;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.effects.IEffect;
	import mx.events.EffectEvent;
	

	/**
	 * @copy IsTrue
	 * */  
	public class IsTrueInstance extends ActionEffectInstance {
		
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
		public function IsTrueInstance(target:Object) {
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
			super.play(); // dispatch startEffect
			
			var action:IsTrue = IsTrue(effect);
			var propertyName:String = action.targetPropertyName;
			var subPropertyName:String = action.targetSubPropertyName;
			var isTrue:Boolean;
			var value:Object;
			var subValue:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (target==null) {
					dispatchErrorEvent("The target is not set.");
				}
				if (!(propertyName in target)) {
					dispatchErrorEvent("The property '" + propertyName + "' is not found on the target.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (subPropertyName) {
				value = target[propertyName];// "data" is the default property
				
				// if value is set and sub property exists
				if (value && subPropertyName in value) {
					subValue = value[subPropertyName];
					
					if (subValue) {
						isTrue = true;
					}
					else {
						isTrue = false;
					}
				}
				else {
					dispatchErrorEvent("The sub property '" + subPropertyName + "' is not on the '" + propertyName + "' object");
				}
			}
			else {
				value = target[propertyName];
				
				if (value) {
					isTrue = true;
				}
				else {
					isTrue = false;
				}
			}
			
			
			// check if the property is true
			if (!isTrue) { 
				
				// property is NOT true 
				
				if (action.hasEventListener(IsTrue.NOT_TRUE)) {
					dispatchActionEvent(new Event(IsTrue.NOT_TRUE));
				}
				
				if (action.notTrueEffect) { 
					playEffect(action.notTrueEffect);
					return;
				}
				
			}
			else {
				
				// property IS true
				if (action.hasEventListener(IsTrue.TRUE)) {
					dispatchActionEvent(new Event(IsTrue.TRUE));
				}
				
				if (action.trueEffect) { 
					playEffect(action.trueEffect);
					//action.trueEffect.addEventListener(EffectEvent.EFFECT_END, playEffectEndHandler2, false, 0, true);
					return;
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
		
		/**
		 * Handle playEffect end
		 * */
		public function playEffectEndHandler2(event:Event):void {
			//var parentSequenceEffect:Object = parentCompositeEffectInstance as SequenceInstance;
			
			IEffect(event.currentTarget).removeEventListener(EffectEvent.EFFECT_END, playEffectEndHandler);
			restorePreviousDuration();
			
			finish();
			
			
		}
	}
	
	
}