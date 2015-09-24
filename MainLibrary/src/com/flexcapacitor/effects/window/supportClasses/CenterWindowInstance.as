

package com.flexcapacitor.effects.window.supportClasses {
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.window.CenterWindow;
	
	import flash.events.ErrorEvent;
	import flash.system.Capabilities;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy CenterWindow
	 * */  
	public class CenterWindowInstance extends ActionEffectInstance {
		
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
		public function CenterWindowInstance(target:Object) {
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
			super.play(); // dispatch effectStart
			
			var action:CenterWindow = CenterWindow(effect);
			var window:Object = action.window || action.target;
			var ignoreWindowSizeError:Boolean = action.ignoreWindowSizeError;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (window==null) {
					dispatchErrorEvent("The window is not set. Set the target or the window property to the window you want to center.");
				}
				
				if (!("width" in window) && !("height" in window)) {
					dispatchErrorEvent("The window property is not set or the target does not have the width and height properties. Make sure the target or window property is set.");
				}
				
				// if you get the following error the size of the component may not have been set yet. Try running at a later event.
				if (!ignoreWindowSizeError && window.width==0 && window.height==0) {
					dispatchErrorEvent("The window width and height are 0. Set ignoreWindowSizeError to true or ensure the width and height are not 0.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			try {
				
				if ("nativeWindow" in window) {
					window = window.nativeWindow;
				}
				
				window.x = ((Capabilities.screenResolutionX - window.width) / 2) + action.offsetX;
				window.y = ((Capabilities.screenResolutionY - window.height) / 2) + action.offsetY;
			}
			catch (error:ErrorEvent) {
				dispatchErrorEvent("Could not center the window. " + error.toString());
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Check if empty object
		 * */
		public function isEmpty(object:Object):Boolean {
			for(var property:String in object) {
				return false;
			} 
			return true;
		}
		
	}
}