

package com.flexcapacitor.effects.collections.supportClasses {
	import com.flexcapacitor.effects.collections.ShuffleCollection;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;

	
	/**
	 * @copy ShuffleCollection
	 * */  
	public class ShuffleCollectionInstance extends ActionEffectInstance {
		
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
		public function ShuffleCollectionInstance(target:Object) {
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
			
			var action:ShuffleCollection = ShuffleCollection(effect);
			var getRandomItem:Boolean = action.getRandomItem;
			var createCopyOfArray:Boolean = action.createCopyOfArray;
			var playItemsAtLeastOnce:Boolean = action.playItemsAtLeastOnce;
			var accessedItems:Array = action.accessedItems || [];
			var unaccessedItems:Array = action.unaccessedItems;
			var wrapToBeginning:Boolean = action.wrapToBeginning;
			var collection:ICollectionView;
			var shuffledArray:Array;
			var original:Array;
			var source:Array;
			var vector:Vector;
			var length:uint;
			var list:IList;
			var item:Object;
			var number:int;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				
				if (target==null) {
					dispatchErrorEvent("The target cannot be null");
				}
				
				if (!(target is IList) && !(target is Array) && !(target is Vector)) {
					dispatchErrorEvent("Target must be of type collection view, array or vector");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			
			if (target is Array) {
				source = target as Array;
			}
			else if (target is IList) {
				source = Object(target).source;
				list = target as IList;
			}
			else if (target is Vector) {
				vector = Vector(target);
			}
			

			if (getRandomItem) {
				
				if (action.repeatSameItem) {
					
					if (!action.dataSetOnce) {
						item = getRandomItemFromArray(source);
						action.dataSetOnce = true;
					}
					else {
						item = action.data;
					}
					
				}
				// get random item
				else if (!playItemsAtLeastOnce) {
					item = getRandomItemFromArray(source);
				}
				else {
					unaccessedItems = getArrayMinusItems(source, accessedItems);
					item = getRandomItemFromArray(unaccessedItems, accessedItems, true, wrapToBeginning);
					
					accessedItems.push(item);
					
					action.accessedItems = accessedItems;
					action.unaccessedItems = unaccessedItems;
				}
				
				action.data = item;
			}
			else {
				
				// duplicates the array
				original = source.slice();
				length = original.length;
				
				shuffledArray = getRandomizedArray(source, createCopyOfArray);
				
				// store shuffled array
				action.shuffledArray = shuffledArray;
				
				// set collection source to shuffled array
				if (!createCopyOfArray) {
					Object(list).source = shuffledArray;
				}
				
				if (list) {
					collection = ICollectionView(list);
				}
				
				// refresh collection
				if (action.refresh && list) {
					collection = ICollectionView(list);
					collection.refresh();
				}
				
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Utils
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Randomizes an array
		 * */
		public function getRandomizedArray(original:Array, cloneArray:Boolean = true):Array {
			var length:int = original.length;
			var shuffledArray:Array = [];
			var newArray:Array = original.slice();
			var randomNumber:Number;
			
			while (length) {
				randomNumber = Math.floor(Math.random() * length);
				shuffledArray.push(newArray.splice(randomNumber, 1)[0]);
				length--;
			}
			
			if (!cloneArray) {
				// the following line can cause internal bug in FB during debugging 
				// An internal error has occurred.
				// Asynchronous viewer update
				// java.lang.ArrayIndexOutOfBoundsException
				original.splice(0, shuffledArray.length);
				original.push.apply(this, shuffledArray);
				return original;
			}
			
			return shuffledArray;
			
		}
			
		/**
		 * Get an array of the range of numbers from 1 to the number specified and randomize them.
		 * */
		public function getRandomNumberArray(count:int):Array {
			var array:Array = new Array(count).map(function (item:Object, index:int, a:Array):* { return index + 1; });
			
			return getRandomizedArray(array);;
		}
		
		/**
		 * Get random item in an array
		 * */
		public function getRandomItemFromArray(array:Array, itemsToSkip:Array = null, remove:Boolean = false, recycle:Boolean = true):Object {
			var length:int = array ? array.length : 0;
			var randomNumber:Number;
			var recycled:Boolean;
			
			if (itemsToSkip==null || itemsToSkip.length==0) {
				randomNumber = Math.floor(Math.random() * length);
				return remove ? array.splice(randomNumber, 1)[0] : array[randomNumber];
			}
			
			var availableItems:Array = getArrayMinusItems(array, itemsToSkip);
			
			if (availableItems.length==0) {
				if (recycle && itemsToSkip && itemsToSkip.length>0) {
					availableItems = itemsToSkip ? itemsToSkip.splice(0, itemsToSkip.length) : [];
					recycled = true;
				}
				else {
					return null;
				}
			}
			
			length = availableItems ? availableItems.length : 0;
			
			randomNumber = Math.floor(Math.random() * length);
			
			// if array is empty and no items to remove is empty 
			if (length==0 && (itemsToSkip==null || itemsToSkip.length==0)) {
				return null;
			}
			
			if (remove) {
				if (recycled) {
					array.push.apply(this, availableItems);
				}
				
				return array.splice(array.indexOf(availableItems.splice(randomNumber,1)[0]),1)[0];
				
			}
			else {
				return availableItems[randomNumber];
			}
			
		}
		
		/**
		 * Get all the items not in the second array 
		 * */
		public function getArrayMinusItems(array:Array, items:Array):Array {
			var cloneArray:Array = array ? array.slice() : [];
			var difference:Array = [];
			var length:int = items ? items.length : 0;
			var index:int = -1;
			
			for (var i:int;i<length;i++) {
			    if ((index=cloneArray.indexOf(items[i]))>-1) {
					cloneArray.splice(index, 1);
				}
			}
			
			return cloneArray;
		}
		
	}
}