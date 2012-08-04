

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CreateObject;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.ClassFactory;
	import mx.effects.IEffect;
	import mx.utils.ObjectUtil;
	
	/**
	 *  @copy CreateObject
	 * */  
	public class CreateObjectInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CreateObjectInstance(target:Object) {
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
			
			var action:CreateObject = CreateObject(effect);
			var type:Class = action.type;
			var valueType:Object = action.valueType;
			var properties:Object = action.properties;
			var styles:Object = action.styles;
			var style:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!type) {
					dispatchErrorEvent("Type must be set to a class");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			var factory:ClassFactory = new ClassFactory(type);
			factory.properties = action.properties;
			action.data = factory.newInstance();
			
			for (style in styles) {
				action.data.setStyle(style, styles[style]);
			}
			
			// set value type
			if (valueType!=null) {
				action.data = valueType(action.data);
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