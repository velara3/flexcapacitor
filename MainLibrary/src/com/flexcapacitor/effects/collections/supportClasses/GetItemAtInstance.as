

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.GetItemAt;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	
	/**
	 * @copy GetItemAt
	 */  
	public class GetItemAtInstance extends ActionEffectInstance {
		
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
		public function GetItemAtInstance(target:Object) {
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
			
			var action:GetItemAt = GetItemAt(effect);
			var collection:IList = action.collection || action.target as IList;
			var allowNullCollection:Boolean = action.allowNullCollection;
			var index:int = action.index;
			
			
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
				if (index>-1 && index<collection.length) {
					
					// index is set
					// check if it is in bounds
					action.data = collection.getItemAt(index);
				}
				else {
					
					if (action.hasEventListener(GetItemAt.OUT_OF_BOUNDS)) {
						dispatchActionEvent(new Event(GetItemAt.OUT_OF_BOUNDS));
					}
					
					// item is out of bounds
					if (action.outOfBoundsEffect) {
						playEffect(action.outOfBoundsEffect);
						return;
					}
				}
					
			}
			else {
				
				if (action.hasEventListener(GetItemAt.COLLECTION_NOT_SET)) {
					dispatchActionEvent(new Event(GetItemAt.COLLECTION_NOT_SET));
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