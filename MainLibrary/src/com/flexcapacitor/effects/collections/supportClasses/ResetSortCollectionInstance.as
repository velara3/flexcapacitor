

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.SortCollection;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.collections.ICollectionView;
	import mx.collections.ISort;
	
	/**
	 * @copy SortCollection
	 * */  
	public class ResetSortCollectionInstance extends ActionEffectInstance {
		
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
		public function ResetSortCollectionInstance(target:Object) {
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
			
			var action:SortCollection = SortCollection(effect);
			var sort:ISort = action.sort;
			var fields:Array = action.fields;
			var length:uint = fields ? fields.length : 0;
			var sortFields:Array = [];
			var descending:Boolean = action.descending;
			var previousSortDirection:int = action.lastSortDirection;
			var numeric:Object = action.numeric;
			var locale:String = action.locale;
			var collection:ICollectionView;
			var field:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (target==null) {
					dispatchErrorEvent("The target cannot be null");
				}
				
				if (!(target is ICollectionView)) {
					dispatchErrorEvent("Target must be of type collection view");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			collection = ICollectionView(action.target);
			
			collection.sort = null;
			
			if (action.refresh) {
				collection.refresh();
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