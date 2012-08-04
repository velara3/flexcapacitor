

package com.flexcapacitor.effects.application.supportClasses {
	import com.flexcapacitor.effects.application.SetFramerate;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	
	import mx.managers.SystemManager;
	
	
	/**
	 * @copy SetFramerate
	 * */  
	public class SetFramerateInstance extends ActionEffectInstance {
		
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
		public function SetFramerateInstance(target:Object) {
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
			
			var action:SetFramerate = SetFramerate(effect);
			var systemManager:DisplayObject = SystemManager.getSWFRoot(this);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// Calling the frameRate property of a Stage object throws an exception 
			// for any caller that is not in the same security sandbox as the Stage 
			// owner (the main SWF file). To avoid this, the Stage owner can grant 
			// permission to the domain of the caller by calling the 
			// Security.allowDomain() method or the Security.allowInsecureDomain() 
			// method. For more information, see the "Security" chapter in the 
			// ActionScript 3.0 Developer's Guide.
			
			try {
				systemManager.stage.frameRate = action.frameRate;
				// note when the stage is set to 0 the flash player reports fps being 0.01;
			}
			catch (error:ErrorEvent) {
				dispatchErrorEvent("Could not change the framerate");
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