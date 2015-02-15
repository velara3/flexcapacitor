

package com.flexcapacitor.effects.application.supportClasses {
	import com.flexcapacitor.effects.application.CloseApplication;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.ErrorEvent;
	
	import mx.core.FlexGlobals;
	
	
	/**
	 * @copy CloseApplication
	 * */  
	public class CloseApplicationInstance extends ActionEffectInstance {
		
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
		public function CloseApplicationInstance(target:Object) {
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
			
			var action:CloseApplication = CloseApplication(effect);
			var application:Object = action.application;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				// check for required properties
				var noExitMethod:Boolean;
				
				if (application && !("exit" in application)) {
					noExitMethod = true;
				}
				
				if (!application && !("exit" in FlexGlobals.topLevelApplication)) {
					noExitMethod = true;
				}
				
				if (noExitMethod) {
					dispatchErrorEvent("The application does not define an exit method. It must have a exit method or be a WindowedApplication.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			try {
				if (application) {
					Object(application).exit();
				}
				else {
					Object(FlexGlobals.topLevelApplication).exit();
				}
				// note when the stage is set to 0 the flash player reports fps being 0.01;
			}
			catch (error:ErrorEvent) {
				dispatchErrorEvent("Could not close the application. " + error.toString());
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