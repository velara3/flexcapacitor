

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.RefreshCollection;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	
	
	/**
	 * @copy RefreshCollection
	 */  
	public class RefreshCollectionInstance extends ActionEffectInstance {
		
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
		public function RefreshCollectionInstance(target:Object) {
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
			
			var action:RefreshCollection = RefreshCollection(effect);
			var collection:ICollectionView = action.collection;
			var allowNullCollection:Boolean = action.allowNullCollection;
			var refreshComplete:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (collection==null && !allowNullCollection) {
					dispatchErrorEvent("Target cannot be null");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			

			if (collection) {
				
				refreshComplete = collection.refresh();
				
				if (refreshComplete) {
					
					if (action.refreshCompleteEffect) {
						playEffect(action.refreshCompleteEffect);
					}
					
					if (action.hasEventListener(RefreshCollection.REFRESH_COMPLETE)) {
						dispatchActionEvent(new Event(RefreshCollection.REFRESH_COMPLETE));
					}
				}
				else {
					
					if (action.refreshNotCompleteEffect) {
						playEffect(action.refreshNotCompleteEffect);
					}
					
					if (action.hasEventListener(RefreshCollection.REFRESH_NOT_COMPLETE)) {
						dispatchActionEvent(new Event(RefreshCollection.REFRESH_NOT_COMPLETE));
					}
				}
			}
			else {
				
				if (action.collectionNotSetEffect) {
					playEffect(action.collectionNotSetEffect);
				}
				
				if (action.hasEventListener(RefreshCollection.COLLECTION_NOT_SET)) {
					dispatchActionEvent(new Event(RefreshCollection.COLLECTION_NOT_SET));
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