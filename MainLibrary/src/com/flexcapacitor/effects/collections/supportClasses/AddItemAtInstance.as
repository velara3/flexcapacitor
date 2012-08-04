

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.AddItemAt;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy AddItemAt
	 */  
	public class AddItemAtInstance extends ActionEffectInstance {
		
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
		public function AddItemAtInstance(target:Object) {
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
			
			var action:AddItemAt = AddItemAt(effect);
			var collection:IList = action.collection || action.target as IList;
			var allowNullCollection:Boolean = action.allowNullCollection;
			var allowNullData:Boolean = action.allowNullData;
			var data:Object = action.data;
			var index:int = action.index;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (collection==null && !allowNullCollection) {
					dispatchErrorEvent("Target collection cannot be null");
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
				if (data!=null) {
					if (index==-1) {
						collection.addItem(data);
					}
					else {
						collection.addItemAt(data, index);
					}
				}
				else {
					
					if (action.dataNotSetEffect) {
						playEffect(action.dataNotSetEffect);
					}
					
					if (action.hasEventListener(AddItemAt.DATA_NOT_SET)) {
						action.dispatchEvent(new Event(AddItemAt.DATA_NOT_SET));
					}
				}
				
				
				
			}
			else {
				
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
				}
				
				if (action.hasEventListener(AddItemAt.COLLECTION_NOT_SET)) {
					action.dispatchEvent(new Event(AddItemAt.COLLECTION_NOT_SET));
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