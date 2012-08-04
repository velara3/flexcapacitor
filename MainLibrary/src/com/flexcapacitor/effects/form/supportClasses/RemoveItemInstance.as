

package com.flexcapacitor.effects.form.supportClasses {
	import com.flexcapacitor.effects.form.RemoveItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.form.FormAdapter;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy RemoveItem
	 * */
	public class RemoveItemInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function RemoveItemInstance(target:Object) {
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
			var action:RemoveItem = effect as RemoveItem;
			var form:FormAdapter = action.formAdapter;
			var array:Object = action.targetList || form.targetList;
			var data:Object = action.data || form.data;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (!form) {
					dispatchErrorEvent("Form adapter property is required.");
				}
				if (!array) {
					dispatchErrorEvent("A list or array is required in the form or effect.");
				}
				if (!data) {
					dispatchErrorEvent("The data to remove is null.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			var removed:Boolean = remove(data, array);
			
			// found and removed
			if (removed) {
				if (action.hasEventListener(RemoveItem.REMOVED)) {
					dispatchEvent(new Event(RemoveItem.REMOVED));
				}
				
				if (action.removedEffect) {
					playEffect(action.removedEffect);
				}

				form.lastRemovedItem = form.data;
				
				if (form.hasEventListener(FormAdapter.REMOVE_COMPLETE)) {
					form.dispatchEvent(new Event(FormAdapter.REMOVE_COMPLETE));
				}
			}
			
			// if not found
			else {
				if (action.hasEventListener(RemoveItem.NOT_FOUND)) {
					dispatchEvent(new Event(RemoveItem.NOT_FOUND));
				}
				
				if (action.notFoundEffect) {
					playEffect(action.notFoundEffect);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
	
		/**
		 * Removes the item from an array or list
		 * */
		public function remove(item:Object, items:Object):Boolean {
			var index:int;
			var length:int;
			
			// check if targetList is set
			if (items is XML) {
				// NOT IMPLEMENTED!
				throw new Error("XML not supported yet.");
				//XML(targetList).appendChild(editableItem);
			}
			else if (items is XMLList) {
				items = items as XMLList;
				index = 0;
				
				if (items==null) {
					// no items exist
					return false;
				}
				
				for each (var node:XML in items) {
					if (node==item) {
						delete items[index];
					}
					index++;
				}
			}
			else if (items is IList) {
				index = IList(items).getItemIndex(item);
				IList(items).removeItemAt(index);// check for -1
			}
			else if (items is Array) {
				length = (items as Array).length;
				index = (items as Array).indexOf(item);
				
				if (index!=-1) {
					(items as Array).splice(index,1);
					return true;
				}
				else {
					return false;
				}
				
				throw new Error("Array not tested yet.");
				
			}
			else if (items is Vector) {
				throw new Error("Vector not supported yet.");
			}
			else if (items!=null) {
				// if target list is defined but adding to the target list is not supported
				throw new Error("The target list is not a type that this class can remove items from. You must manually remove the item. See lastRemovedItem.");
			}
			
			return true;
		}

		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}