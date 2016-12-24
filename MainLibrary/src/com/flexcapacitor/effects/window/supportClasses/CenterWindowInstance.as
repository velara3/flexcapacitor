

package com.flexcapacitor.effects.window.supportClasses {
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.effects.window.CenterWindow;
	import com.flexcapacitor.utils.ClassUtils;
	import com.flexcapacitor.utils.DisplayObjectUtils;
	
	import flash.events.ErrorEvent;
	import flash.system.Capabilities;
	
	
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
			var window:Object = action.window ? action.window : action.target;
			var ignoreWindowSizeError:Boolean = action.ignoreWindowSizeError;
			var windowWidth:int = window && "width" in window ? window.width : 0;
			var windowHeight:int = window && "height" in window ? window.height : 0;
			var isEmpty:Boolean = ClassUtils.isEmptyObject(window);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				if (window==null || isEmpty) {
					dispatchErrorEvent("The window is not set. Set the target or the window property to the window you want to center.");
				}
				
				if (!("width" in window) && !("height" in window)) {
					dispatchErrorEvent("The window property is not set or the target does not have the width and height properties. Make sure the target or window property is set.");
				}
				
				// if you get the following error 
				// the size of the component may not have been set yet. 
				// Try running at a later event such as 
				// 
				// initialize, creationComplete or applicationComplete
				if (!ignoreWindowSizeError && windowWidth==0 && windowHeight==0) {
					dispatchErrorEvent("The window or component width and height are 0. Set ignoreWindowSizeError to true or ensure the width and height are not 0. Or wait until a later event to run this effect. Also, check that this is running on the correct component or application.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			try {
				var offsetY:Number = action.includeTitleBar ? action.offsetY + action.titleBarHeight : action.offsetY;
				DisplayObjectUtils.centerWindow(window, offsetY, action.offsetX);
			}
			catch (error:ErrorEvent) {
				dispatchErrorEvent("Could not center the window. " + error.toString());
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
	}
}