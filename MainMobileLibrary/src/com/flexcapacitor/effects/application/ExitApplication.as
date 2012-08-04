

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.ExitApplicationInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.events.EffectEvent;
	
	import mx.effects.Effect;
	
	
	/**
	 * Exits the application
	 * */
	public class ExitApplication extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ExitApplication(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ExitApplicationInstance;
			
			
		}
		
		/**
		 * When true the application will not exit only if the first view is visible. 
		 * This only applies to View Navigator applications. It is ignored by other application
		 * types. Default is true.
		 * */
		public var onlyExitOnFirstView:Boolean;
		
		/**
		 * The type of the class to exit on
		 * */
		public var viewToExitOn:Class;
		
	}
}