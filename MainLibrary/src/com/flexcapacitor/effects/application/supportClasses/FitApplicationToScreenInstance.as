

package com.flexcapacitor.effects.application.supportClasses {
	import com.flexcapacitor.effects.application.FitApplicationToScreen;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.DisplayObjectUtils;
	
	import flash.events.ErrorEvent;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	
	
	/**
	 * @copy FitApplicationToScreen
	 * */  
	public class FitApplicationToScreenInstance extends ActionEffectInstance {
		
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
		public function FitApplicationToScreenInstance(target:Object) {
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
			
			var action:FitApplicationToScreen = FitApplicationToScreen(effect);
			var application:Object = action.application;
			var centerApplication:Boolean = action.centerApplication;
			var includeTitle:Boolean = action.includeTitleBar;
			var widthRatio:Number = action.widthRatio;
			var heightRatio:Number = action.heightRatio;
			var offsetHeight:int = includeTitle ? action.titleBarHeight : 0;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (application==null) {
				
				if (action.target && "width" in action.target) {
					application = action.target;
				}
				else {
					application = FlexGlobals.topLevelApplication;
				}
			}
			
			if (validate) {
				
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			try {
				application.width = Capabilities.screenResolutionX * widthRatio;
				application.height = Capabilities.screenResolutionY * heightRatio;
				
				if (centerApplication) {
					DisplayObjectUtils.centerWindow(application, offsetHeight);
				}
			}
			catch (error:ErrorEvent) {
				dispatchErrorEvent("Could not size the application. " + error.toString());
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
	}
}