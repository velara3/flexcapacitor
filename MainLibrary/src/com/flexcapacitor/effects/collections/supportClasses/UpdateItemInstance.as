

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.UpdateItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy UpdateItem
	 */  
	public class UpdateItemInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function UpdateItemInstance(target:Object) {
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
			super.play(); // dispatches startEffect
			
			var action:UpdateItem = UpdateItem(effect);
			var collection:IList = action.collection;
			var allowNull:Boolean = action.allowNull;
			var data:Object = action.data;
			var index:int = action.index;
			var outOfBounds:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!collection && !allowNull) {
					dispatchErrorEvent("Target cannot be null");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check if collection is set
			if (collection) {
				
				// check if data is set
				if (data) {
					// check if data is in collection
					index = collection.getItemIndex(data);
					
					// is item found
					if (index==-1) {
						
						// item is not found
						if (action.itemNotFoundEffect) {
							playEffect(action.itemNotFoundEffect);
						}
						
						if (action.hasEventListener(UpdateItem.ITEM_NOT_FOUND)) {
							dispatchActionEvent(new Event(UpdateItem.ITEM_NOT_FOUND));
						}
					}
					else {
						
						// item found - update item
						collection.itemUpdated(data, action.propertyName, action.oldValue, action.newValue);
						
						if (action.updatedEffect) {
							playEffect(action.updatedEffect);
						}
						
						if (action.hasEventListener(UpdateItem.UPDATED)) {
							dispatchActionEvent(new Event(UpdateItem.UPDATED));
						}
					}
				}
				else if (index>-1) {
					
					// index is set
					// check if it is in bounds
					if (index<collection.length) {
						data = collection.getItemAt(index);
						collection.itemUpdated(data, action.propertyName, action.oldValue, action.newValue);
					}
					else {
						// item is out of bounds
						if (action.outOfBoundsEffect) {
							playEffect(action.outOfBoundsEffect);
						}
						
						if (action.hasEventListener(UpdateItem.OUT_OF_BOUNDS)) {
							dispatchActionEvent(new Event(UpdateItem.OUT_OF_BOUNDS));
						}
					}
					
				}
				
			}
			else {
				
				// collection is not set
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
				}
				
				if (action.hasEventListener(UpdateItem.COLLECTION_NOT_SET)) {
					dispatchActionEvent(new Event(UpdateItem.COLLECTION_NOT_SET));
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}