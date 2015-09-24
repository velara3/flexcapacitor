

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.CollectionEmpty;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;

	
	/**
	 * @copy CollectionEmpty
	 * */  
	public class CollectionEmptyInstance extends ActionEffectInstance {
		
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
		public function CollectionEmptyInstance(target:Object) {
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
		 */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:CollectionEmpty = CollectionEmpty(effect);
			var length:uint;
			var list:IList;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (target==null) {
					dispatchErrorEvent("The target cannot be null");
				}
				
				if (!(target is IList)) {
					dispatchErrorEvent("Target must be of type IList");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			list = IList(target);
			length = list.length;
			
			if (length==0) {
				if (action.hasEventListener(CollectionEmpty.EMPTY)) {
					dispatchActionEvent(new Event(CollectionEmpty.EMPTY));
				}
				
				if (action.emptyEffect) {
					playEffect(action.emptyEffect);
				}
			}
			else {
				
				if (action.hasEventListener(CollectionEmpty.NOT_EMPTY)) {
					dispatchActionEvent(new Event(CollectionEmpty.NOT_EMPTY));
				}
				
				if (action.notEmptyEffect) {
					playEffect(action.notEmptyEffect);
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