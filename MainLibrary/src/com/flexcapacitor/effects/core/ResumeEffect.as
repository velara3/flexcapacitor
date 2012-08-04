

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.ResumeEffectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when the effect is not paused.
	 * */
	[Event(name="notPaused", type="flash.events.Event")]
	
	[DefaultProperty("effect")]
	
	/**
	 * Resumes the specified effect. Optionally can play the effect if not paused. 
	 * 
	 * @see mx.effects.CompositeEffect
	 * */
	public class ResumeEffect extends ActionEffect {
		
		/**
		 * Event name constant when effect is not paused.
		 * */
		public static const NOT_PAUSED:String = "notPaused";
		
		
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
		public function ResumeEffect(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = ResumeEffectInstance;
		}
		
		
		/**
		 * Effect that will be resumed.  
		 * */
		public var effect:IEffect;
		
		/**
		 * If true and the effect is not paused then plays the effect, rather than resumes. 
		 * */
		public var playIfNotPaused:Boolean;
		
		/**
		 * Effect that is played if the effect is not paused.
		 * */
		public var notPausedEffect:Effect;
		
	}
}