

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.GoIntoFullScreenInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Event dispatched when full screen is not supported.
	 * */
	[Event(name="fullScreenUnsupported", type="flash.events.Event")]
	
	/**
	 * Enters into full screen. If toggle is set to true then switches between full screen and un full screen.
	 * 
	 * Calling the displayState property of a Stage object throws an exception for any caller that is not 
	 * in the same security sandbox as the Stage owner (the main SWF file). 
	 * To avoid this, the Stage owner can grant permission to the domain of the caller by calling 
	 * the Security.allowDomain() method or the Security.allowInsecureDomain() method. 
	 * For more information, see the "Security" chapter in the ActionScript 3.0 Developer's Guide. 
	 * Trying to set the displayState property while the settings dialog is displayed, without a user 
	 * response, or if the param or embed HTML tag's allowFullScreen 
	 * attribute is not set to true throws a security error.
	 * */
	public class GoIntoFullscreen extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function GoIntoFullscreen(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = GoIntoFullScreenInstance;
			
		}
		
		/**
		 * When set to true toggles between normal and full screen 
		 * */
		public var toggle:Boolean;
		
		/**
		 * The destination state either full screen, full screen interactive or normal.
		 * Full Screen - Specifies that the Stage is in full-screen mode. 
		 * Keyboard interactivity is disabled in this mode. 
		 * Full Screen Interactive - AIR ONLY Specifies that the Stage is 
		 * in full-screen mode with keyboard interactivity enabled. 
		 * Only AIR applications support this capability.
		 * Normal - Specifies that the Stage is in normal mode. 
		 * */
		[Inspectable(enumeration="fullScreen,fullScreenInteractive,normal")]
		public var displayState:String = "fullScreen";
		
		/**
		 * Determines if switching to full screen mode or interactive full screen mode.
		 * */
		public var interactiveFullScreen:Boolean;
	}
}