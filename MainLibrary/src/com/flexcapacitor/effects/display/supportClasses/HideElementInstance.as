

package com.flexcapacitor.effects.display.supportClasses {
	import com.flexcapacitor.effects.display.HideElement;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.IVisualElement;
	
	
	/**
	 * @copy HideElement
	 * */  
	public class HideElementInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function HideElementInstance(target:Object) {
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
			super.play(); // dispatches startEffect
			
			var action:HideElement = HideElement(effect);
			var includeInLayout:String = action.includeInLayout;
			var element:IVisualElement = target as IVisualElement;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (!(action.target is IVisualElement)) {
					dispatchErrorEvent("Target must be a IVisualElement");
				}
				
				if (!element) {
					dispatchErrorEvent("Target is required");
				}
				
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			element.visible = action.display;
			
			if ("includeInLayout" in element && action.includeInLayout!=null) {
				Object(element).includeInLayout = action.includeInLayout=="true" ? true : false;
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