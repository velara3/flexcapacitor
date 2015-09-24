

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.RemoveItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy RemoveItem
	 */  
	public class RemoveItemInstance extends ActionEffectInstance {
		
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
			super.play(); // dispatches startEffect
			
			var action:RemoveItem = RemoveItem(effect);
			var collection:IList = action.collection || action.target as IList;
			var allowNullCollection:Boolean = action.allowNullCollection;
			var data:Object = action.data;
			var index:int;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!collection && !allowNullCollection) {
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
						
						if (action.hasEventListener(RemoveItem.ITEM_NOT_FOUND)) {
							dispatchActionEvent(new Event(RemoveItem.ITEM_NOT_FOUND));
						}
					}
					else {
						
						// item found - remove item
						collection.removeItemAt(index);
						
						if (action.removedEffect) {
							playEffect(action.removedEffect);
						}
						
						if (action.hasEventListener(RemoveItem.REMOVED)) {
							dispatchActionEvent(new Event(RemoveItem.REMOVED));
						}
					}
				}
				
			}
			else {
				
				// collection is not set
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
				}
				
				if (action.hasEventListener(RemoveItem.COLLECTION_NOT_SET)) {
					dispatchActionEvent(new Event(RemoveItem.COLLECTION_NOT_SET));
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