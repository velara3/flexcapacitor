

package com.flexcapacitor.effects.display.supportClasses {
	import com.flexcapacitor.effects.display.ShowElement;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.core.IVisualElement;
	
	
	/**
	 * @copy ShowElement
	 */  
	public class ShowElementInstance extends ActionEffectInstance {
		
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
		public function ShowElementInstance(target:Object) {
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
			
			var action:ShowElement = ShowElement(effect);
			var includeInLayout:String = action.includeInLayout;
			var element:IVisualElement = action.target as IVisualElement;
			
			
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
			
			if ("includeInLayout" in element && action.includeInLayout!=null) { // is there an interface for include in layout
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