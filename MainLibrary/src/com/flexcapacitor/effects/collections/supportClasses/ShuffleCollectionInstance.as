

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
			var shuffleSourceArray:Boolean = action.shuffleSourceArray;
			var collection:ICollectionView;
			var shuffledArray:Array;
			var original:Array;
			var source:Array;
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
					dispatchErrorEvent("Target must be of type collection view");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////

			list = IList(target);
			
			// @author - NBilyk - http://nbflexlib.googlecode.com/svn
			// @modified 
			
			// duplicates the array
			source = Object(list).source;
			original = source.slice();
			length = original.length;
			
			//if (shuffleSourceArray) {
			//	shuffledArray = source;
			//	dispatchErrorEvent("ShuffleSourceArray is not implemented yet");
			//}
			
			
			shuffledArray = [];
			
			// testing...
			var so:Number;
			var something:Array;
			
			while (length) {
				so = Math.random() * length;
				so = Math.floor(so);
				something = original.splice(so, 1);
				shuffledArray.push(something[0]);
				length--;
			}
			
			
			// store shuffled array
			action.shuffledArray = shuffledArray;
			
			// set collection source to shuffled array
			Object(list).source = shuffledArray;
			
			collection = ICollectionView(list);
			
			// refresh collection
			if (action.refresh && collection) {
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