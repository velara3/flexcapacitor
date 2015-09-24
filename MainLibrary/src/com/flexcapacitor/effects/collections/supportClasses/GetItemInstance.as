

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.GetItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy GetItem
	 */  
	public class GetItemInstance extends ActionEffectInstance {
		
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
		public function GetItemInstance(target:Object) {
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
			
			var action:GetItem = GetItem(effect);
			var collection:IList = action.collection || action.target as IList;
			var allowNullCollection:Boolean = action.allowNullCollection;
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
				
				// if null or start then first item otherwise last item
				index = action.location==null || action.location==GetItem.START ? 0 : collection.length-1;
				
				
				// index is set
				if (collection.length>0) {
					action.data = collection.getItemAt(index);
				}
				else {
					
					if (action.hasEventListener(GetItem.COLLECTION_EMPTY)) {
						dispatchActionEvent(new Event(GetItem.COLLECTION_EMPTY));
					}
					
					// collection is empty
					if (action.collectionEmptyEffect) {
						playEffect(action.collectionEmptyEffect);
						return;
					}
				}
				
			}
			else {
				
				if (action.hasEventListener(GetItem.COLLECTION_NOT_SET)) {
					dispatchActionEvent(new Event(GetItem.COLLECTION_NOT_SET));
				}
				
				// collection is not set
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
					return;
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