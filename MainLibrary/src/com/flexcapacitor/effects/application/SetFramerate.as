

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.SetFramerateInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Sets the framerate of the stage through the property
	 * systemManager.stage.framerate
	 * */
	public class SetFramerate extends ActionEffect {
		
		
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
		public function SetFramerate(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SetFramerateInstance;
			
			// defaults
			frameRate = 24;
		}
		
		/**
		 * Target frame rate. Default is 24. 
		 * */
		public var frameRate:Number;
		
	}
}