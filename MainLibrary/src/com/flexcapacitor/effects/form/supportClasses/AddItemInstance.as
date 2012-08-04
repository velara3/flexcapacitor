

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.AddItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	import com.flexcapacitor.form.FormManager;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy AddItem
	 * */
	public class AddItemInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function AddItemInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play(); // Dispatch an effectStart event
			
			var valid:Boolean = true;
			var action:AddItem = effect as AddItem;
			var validateForm:Boolean = action.validate;
			var form:FormAdapter = action.formAdapter;
			var array:Object = action.targetList || form.targetList;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!form) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				if (!array) {
					dispatchErrorEvent("The target list is required in the form or effect.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			if (validateForm) {
				valid = FormManager.instance.validate(form);
			}
			
			if (valid) {
				FormManager.instance.add(form, array);
				
				action.addedItem = form.lastCreatedItem;
				
				if (action.hasEventListener(AddItem.VALID)) {
					dispatchEvent(new Event(AddItem.VALID));
				}
				
				if (action.validEffect) {
					playEffect(action.validEffect);
				}
				
				if (action.hasEventListener(AddItem.ADDED)) {
					dispatchEvent(new Event(AddItem.ADDED));
				}
				
				if (action.addedEffect) {
					playEffect(action.addedEffect);
				}
				/*
				if (action.targetList) {
					addToTarget(action.targetList, action.addedItem); // NOT TESTED
				}
				else {
					action.addMethod.apply(this, [action.addedItem]);
				}*/
			}
			
			// if not valid
			else {
				if (action.hasEventListener(AddItem.INVALID)) {
					dispatchEvent(new Event(AddItem.INVALID));
				}
				
				if (action.invalidEffect) {
					playEffect(action.invalidEffect);
				}
			}
			
			// save new item
			/*if (action.saveAfterAdd) {
				if (action.saveMethod!=null) {
					action.saveMethod.apply(this);
				}
				else {
					dispatchErrorEvent("The save method is not set");
				}
			}*/
			
			
			// state to switch to after add
			/*if (action.stateToSwitchToAfterAdd) {
				if (action.view==null) {
					dispatchErrorEvent("The view is not set");
				}
				
				if (action.view.hasState(action.stateToSwitchToAfterAdd)) {
					action.view.currentState = action.stateToSwitchToAfterAdd;
				}
				else {
					dispatchErrorEvent("The view does not have the state specified");
				}
			}*/
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		private function addToTarget(targetList:Object, newItem:Object):void {
			if (targetList is XML) {
				XML(targetList).appendChild(newItem);
			}
			else if (targetList is IList) {
				IList(targetList).addItem(newItem);
			}
			else if (targetList is Array) {
				(targetList as Array).push(newItem);
			}
			else if (targetList is Vector) {
				Vector.<Class>(targetList).push(newItem);
			}
			else if (targetList!=null) {
				// if target list is defined but adding to the target list is not supported
				throw new Error("The target list is not a type that this class can add new items too. You must manually add the new item. See lastAddedItem.");
			}
		}
		
		/**
		 * Add an item
		 * */
		public function addItem(xmlList:XMLList, item:XML, overwrite:Boolean = false):XML {
			if (item && xmlList) {
				xmlList.items.appendChild(item);
				return item;
			}
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}