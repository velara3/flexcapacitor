

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.CloseApplicationInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Closes the application
	 * */
	public class CloseApplication extends ActionEffect {
		
		
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
		public function CloseApplication(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = CloseApplicationInstance;
			
		}
		
		/**
		 * Reference to the Application to close. If not set then the 
		 * FlexGlobals.topLevelApplication is used.
		 * */
		[Bindable]
		public var application:Object;
		
	}
}