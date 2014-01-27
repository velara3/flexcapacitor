

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.CancelEffectInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * When part of a composite effect stops all sibling effects and 
	 * cancels out of the parent composite effect.<br/><br/>
	 * 
	 * This is being deprecated unless there is some reason to keep it. Instead of canceling a
	 * sequence of instances Action Effect authors should branch to subeffects that 
	 * play based on success or failure of their intended action. 
	 * 
	 * By default this will recursively cancel out of all parent composite effects. 
	 * If cancelAncestorEffects is set to false then this will only cancel out 
	 * of the direct parent composite effect.<br/><br/>
	 * 
	 * Equivalent to:<br/><br/>
	 * effectInstance.stop();<br/>
	 * parentEffectInstance.stop();<br/>
	 * parentEffectInstance.end();<br/><br/>
	 * 
	 * NOTE: Parent effects must call playEffects method for cancelAncestorEffects option 
	 * to work. For example, in the effect instance you would call playEffect(action.effect) 
	 * instead of action.effect.play();
	 * */
	public class Cancel extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 **/
		public function Cancel(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = CancelEffectInstance;
		}
		
		/**
		 * IN TESTING: Cancels out of all ancestor composite effects
		 * 
		 * NOTE: Parent effects must call playEffects method for cancelAncestorEffects option 
		 * to work. For example, in the effect instance you would call playEffect(action.effect) 
		 * instead of action.effect.play();
		 * */
		public var cancelAncestorEffects:Boolean = true;
	}
}