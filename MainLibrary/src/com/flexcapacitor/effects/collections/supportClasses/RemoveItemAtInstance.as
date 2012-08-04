

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.RemoveItemAt;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy RemoveItemAt
	 */  
	public class RemoveItemAtInstance extends ActionEffectInstance {
		
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
		public function RemoveItemAtInstance(target:Object) {
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
			
			var action:RemoveItemAt = RemoveItemAt(effect);
			var collection:IList = action.collection || action.target as IList;
			var index:int = action.index;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!collection && !action.allowNullCollection) {
					dispatchErrorEvent("Target cannot be null");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			
			// check if collection is set
			if (collection) {
				
				// check if data is set
				if (index>-1) {
					
					// index is set
					// check if it is in bounds
					if (index<collection.length) {
						action.data = collection.removeItemAt(index);
					}
					else {
						// item is out of bounds
						if (action.outOfBoundsEffect) {
							playEffect(action.outOfBoundsEffect);
						}
						
						if (action.hasEventListener(RemoveItemAt.OUT_OF_BOUNDS)) {
							action.dispatchEvent(new Event(RemoveItemAt.OUT_OF_BOUNDS));
						}
					}
					
				}
				
			}
			else {
				
				// collection is not set
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
				}
				
				if (action.hasEventListener(RemoveItemAt.COLLECTION_NOT_SET)) {
					action.dispatchEvent(new Event(RemoveItemAt.COLLECTION_NOT_SET));
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