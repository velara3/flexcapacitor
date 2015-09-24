

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.HasProperty;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	

	/**
	 * @copy HasProperty
	 * */  
	public class HasPropertyInstance extends ActionEffectInstance {
		
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
		public function HasPropertyInstance(target:Object) {
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
			
			var action:HasProperty = HasProperty(effect);
			var propertyName:String = action.propertyName;
			var subPropertyName:String = action.subPropertyName;
			var propertyExists:Boolean;
			var value:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// check for required properties
			if (validate) {
				if (propertyName==null || propertyName=="") {
					dispatchErrorEvent("The property name is not set.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (subPropertyName) {
				value = target[propertyName];
				
				if (value && subPropertyName in value) {
					propertyExists = true;
				}
				else {
					propertyExists = false;
				}
			}
			else if (propertyName in target) {
				propertyExists = true;
			}
			
			
			// check if the property is set
			if (!propertyExists) { 
				
				// property is NOT set 
				if (action.hasEventListener(HasProperty.NO_PROPERTY)) {
					dispatchActionEvent(new Event(HasProperty.HAS_PROPERTY));
				}
				
				if (action.noPropertyEffect) { 
					playEffect(action.noPropertyEffect);
				}
				
				if (action.cancelIfNoProperty) {
					cancel();
				}
				
			}
			else {
				
				// property IS set
				if (action.hasEventListener(HasProperty.HAS_PROPERTY)) {
					dispatchActionEvent(new Event(HasProperty.HAS_PROPERTY));
				}
				
				if (action.hasPropertyEffect) { 
					playEffect(action.hasPropertyEffect);
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