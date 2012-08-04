

package com.flexcapacitor.effects.form {
	import com.flexcapacitor.effects.form.supportClasses.InitializeFormInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	import mx.core.UIComponent;
	
	
	/**
	 * Initializes the form
	 * */
	public class InitializeForm extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function InitializeForm(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = InitializeFormInstance;
		}
		
		/**
		 * Reference to Form
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * A view with the currentState property
		 * */
		public var view:UIComponent;
		
		/**
		 * Name of state to change to. Optional.
		 * */
		public var stateToChangeTo:String;
		
		/**
		 * Mode to switch to. Form must support the mode or an error is thrown. 
		 * Forms usually have only two which are edit and add.
		 * */
		public var modeToStartIn:String;
		
		/**
		 * 
		 * */
		public var editableItem:Object;
		
		/**
		 * 
		 * */
		public var editableItemProperty:Object;
		
		/**
		 * If this is true then errors will be suppressed if this action is called
		 * before the target components of the form are created. 
		 * To make sure that the action is complete you can call this same action 
		 * on the target components creation complete event. 
		 * */
		public var suppressNullTargetErrors:Boolean;
		
		/**
		 * If the state to change to property is set then we need to set a default state name in cases where 
		 * */
		public var defaultStateName:String;
		
		/**
		 * Default mode the form should start out in.
		 * */
		[Inspectable(enumeration="add,edit")]
		public var defaultMode:String = "add";
		
	}
}