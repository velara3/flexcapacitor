

package com.flexcapacitor.effects.application.supportClasses {
	
	import com.flexcapacitor.effects.application.ExitApplication;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.managers.SystemManager;
	
	import spark.components.View;
	import spark.components.ViewNavigator;
	import spark.components.supportClasses.ViewNavigatorBase;

	use namespace mx_internal;
	/**
	 * Exits the application
	 * */  
	public class ExitApplicationInstance extends ActionEffectInstance {
		
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
		public function ExitApplicationInstance(target:Object) {
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
			
			var action:ExitApplication = ExitApplication(effect);
			var target:Object = action.target;
			var navigator:ViewNavigatorBase;
			var canExit:Boolean;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (action.viewToExitOn && !target) {//redun?
					dispatchErrorEvent("Target must be set if view to exit on is set");
				}
				
				if (!target) { 
					errorMessage = "Target is required";
					dispatchErrorEvent(errorMessage);
				}
				
				if (!(target is View) 
					&& !(target is ViewNavigator)) {
					dispatchErrorEvent("Target must be a View or ViewNavigator");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// get navigator
			if (target is View) {
				navigator = View(target).navigator;
			}
			else if (target is ViewNavigator) {
				navigator = ViewNavigator(target);
			}
			
			
			/*
			*  The exitApplicationOnBackKey property is used to determine whether the application can
			*  return to the home screen on Android when the back key is
			*  pressed.  An application can return to the home screen if the
			*  length of the navigator is 1 or less and a previous back key is not being processed
			*  by another view or open menu
			*/
			if (action.onlyExitOnFirstView) {
				// this returns true if on the first screen and no menus are open
				canExit = navigator.mx_internal::exitApplicationOnBackKey;
			}
			
			if (navigator.activeView is action.viewToExitOn) {
				canExit = true;
			}
			
			// NOTE This seems to be getting called three times???
			// BECAUSE the event handler listens adds an event handler to the target and stage
			
			// the first is the target in phase 2 			(the view)
			// the second is the stage in phase 3 			(the stage)
			// but the third is also the stage in phase 3 	(the stage)
			
			
			if (canExit) {
				NativeApplication.nativeApplication.exit();
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