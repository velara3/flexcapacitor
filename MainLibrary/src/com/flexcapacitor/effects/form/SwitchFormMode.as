

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.SwitchFormModeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	import mx.core.UIComponent;
	
	public class SwitchFormMode extends ActionEffect {
		
		
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
		public function SwitchFormMode(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = SwitchFormModeInstance;
		}
		
		/**
		 * Reference to form adapter
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * Name of Form mode to go to. 
		 * */
		public var modeToSwitchTo:String;
		
		/**
		 * A view with the currentState property
		 * */
		public var view:UIComponent;
		
		/**
		 * Name of state to change to. 
		 * Changes the state of the component assigned to the view property.
		 * */
		public var stateToChangeTo:String;
	}
}