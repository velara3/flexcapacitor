

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.AddItem;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy AddItem
	 */  
	public class AddItemInstance extends ActionEffectInstance {
		
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
			super.play(); // dispatches startEffect
			
			var action:AddItem = AddItem(effect);
			var collection:IList = action.collection || action.target as IList;
			var allowNullCollection:Boolean = action.allowNullCollection;
			var allowNullData:Boolean = action.allowNullData;
			var data:Object = action.data;
			var index:int;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!collection && !allowNullCollection) {
					dispatchErrorEvent("Target cannot be null");
				}
				if (data==null && !allowNullData) {
					dispatchErrorEvent("Target collection data cannot be null");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			

			if (collection) {
				
				// data exists
				if (data) {

					// if null or end then add to end
					if (action.location==null || action.location==AddItem.END ) {
						collection.addItem(data);
					}
					else {
						collection.addItemAt(data, 0);
					}
				}
				else {
					
					if (action.hasEventListener(AddItem.DATA_NOT_SET)) {
						action.dispatchEvent(new Event(AddItem.DATA_NOT_SET));
					}
					
					if (action.dataNotSetEffect) {
						playEffect(action.dataNotSetEffect);
					}
				}
				
				
				
			}
			else {
				
				if (action.hasEventListener(AddItem.COLLECTION_NOT_SET)) {
					action.dispatchEvent(new Event(AddItem.COLLECTION_NOT_SET));
				}
				
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
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