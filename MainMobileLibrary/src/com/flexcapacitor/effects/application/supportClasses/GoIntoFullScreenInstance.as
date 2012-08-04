

package com.flexcapacitor.effects.application.supportClasses {
	import com.flexcapacitor.effects.application.GoIntoFullscreen;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	import mx.managers.SystemManager;
	
	
	/**
	 * Opens the gallery of a camera roll. 
	 * */  
	public class GoIntoFullScreenInstance extends ActionEffectInstance {
		
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
		public function GoIntoFullScreenInstance(target:Object) {
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
			
			var action:GoIntoFullscreen = GoIntoFullscreen(effect);
			var stage:Stage = SystemManager.getSWFRoot(this).stage;
			var fullScreenMode:String = action.interactiveFullScreen ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.FULL_SCREEN;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!stage) { 
					errorMessage = "Target must be set to a display object on the stage";
					cancel(errorMessage);
					throw new Error(errorMessage);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (action.toggle) {
				stage.displayState = stage.displayState==fullScreenMode ? StageDisplayState.NORMAL : fullScreenMode;
			}
			else {
				stage.displayState = action.displayState;
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