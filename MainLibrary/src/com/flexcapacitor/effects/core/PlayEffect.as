

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.PlayEffectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	[DefaultProperty("effect")]
	
	/**
	 * Plays the specified effect. 
	 * 
	 * @see mx.effects.CompositeEffect
	 * */
	public class PlayEffect extends ActionEffect {
		
		
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
		public function PlayEffect(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = PlayEffectInstance;
		}
		
		
		/**
		 * Effect that will be played.  
		 * */
		public var effect:IEffect;
		
		/**
		 * If true then resumes playback of a paused effect rather than play it (rather than restart). 
		 * */
		public var resumeIfPaused:Boolean;
		
	}
}