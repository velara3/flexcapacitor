

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.StopEffectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	import mx.effects.IEffectInstance;
	
	[DefaultProperty("effect")]
	
	/** 
	 * @copy mx.effects.Effect.stop()
	 * */
	public class StopEffect extends ActionEffect {
		
		
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
		public function StopEffect(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = StopEffectInstance;
		}
		
		
		/**
		 * Effect that will end. You can set this or the target property.
		 * */
		[Bindable]
		public var effect:IEffect;
		
		/**
		 *  @private
		 */
		override protected function initInstance(instance:IEffectInstance):void
		{
			super.initInstance(instance);
			
			//var targetEffect:IEffect = effect || target as IEffect;
			//effect.end();
			//var actionInstance:EndEffectInstance = EndEffectInstance(instance);
			
			//actionInstance.end();
			
			//targetEffect.end();
			//targetEffect = null;
		}
		
		
	}
}