

package com.flexcapacitor.effects.collections {
	
	import com.flexcapacitor.effects.collections.supportClasses.ShuffleCollectionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * <p>Shuffles an array or an array in a collection or optionally gets an 
	 * item out of an array or an array in a collection and stores that in the data
	 * property of this effect. If playItemsAtLeastOnce is 
	 * set to true it will not set the same item until it has gone through 
	 * all the items in the array.</p>
	 * 
	 * <b>Examples</b>
	 * <b>The following shuffles the items in the collection:</b>
	 * <pre>
	&lt;data:ShuffleCollection target="{listCollection}" refresh="true">
	&lt;/data:ShuffleCollection>
	 * </pre>
	 * <b>The following gets a random item from the collection and stores it in the data property:</b>
	 * <pre>
&lt;data:ShuffleCollection id="shuffleCollection" 
	   target="{soundsCollection}"
	   getRandomItem="true"
	   playItemsAtLeastOnce="true"
	   wrapToBeginning="true" />
	 * </pre>
	 * */
	public class ShuffleCollection extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function ShuffleCollection(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ShuffleCollectionInstance;
		}
		
		
		/**
		 * Updates the collection immediately
		 * */
		public var refresh:Boolean = true;
		
		/**
		 * Reference to the shuffled array
		 * */
		[Bindable]
		public var shuffledArray:Array;
		
		/**
		 * Reference to the items that have been stored at least one time through.
		 * @see getRandomItem
		 * */
		[Bindable]
		public var accessedItems:Array;
		
		/**
		 * Reference to the items that have not been stored at least one time through.
		 * @see getRandomItem
		 * */
		[Bindable]
		public var unaccessedItems:Array;
		
		/**
		 * If true creates a new array and shuffles that (the original array remains unchanged).
		 * The new array is placed into the shuffledArray property. 
		 * 
		 * @see shuffledArray;
		 * */
		public var createCopyOfArray:Boolean;
		
		/**
		 * If false the array or array collection is shuffled. 
		 * If true gets a random item from the array and places it into the data property. 
		 * 
		 * @see shuffledArray;
		 * @see shuffleArray
		 * @see doNotRepeatItems
		 * @see accessedItems
		 * @see unaccessedItems
		 * */
		public var getRandomItem:Boolean;
		
		/**
		 * When storeArrayItem is true then a random item is stored in the 
		 * data property each time this effect is run. When do not repeat 
		 * items is true then none of the items are repeated until  
		 * every item in the array has been accessed at least once.
		 * 
		 * @see data
		 * @see shuffleArray
		 * @see wrapToBeginning
		 * @see accessedItems
		 * @see unaccessedItems
		 * */
		public var playItemsAtLeastOnce:Boolean = true;
		
		/**
		 * When getRandomItem is true and this property is true than
		 * the data property stays the same after the first shuffle. 
		 * Anytime after this effect is run the data property will 
		 * remain the same.
		 * 
		 * You would use this, for example, if you want to show a random 
		 * background image each time the app is opened but that image
		 * does not change through the life time of the app even
		 * when this effect is called multiple times.  
		 * 
		 * @see data
		 * @see shuffleArray
		 * @see wrapToBeginning
		 * @see accessedItems
		 * @see unaccessedItems
		 * */
		public var repeatSameItem:Boolean = false;
		
		/**
		 * When get random item and repeat same item are set to true than this property is 
		 * true after the data has been set once. You do not set this. 
		 * */
		public var dataSetOnce:Boolean;
		
		/**
		 * When get random item is set to true and do not repeat item is true than
		 * and this value is true then refill the array and wrap to the start. 
		 * 
		 * @see data
		 * @see shuffleArray
		 * @see doNotRepeatItems
		 * @see accessedItems
		 * @see unaccessedItems
		 * */
		public var wrapToBeginning:Boolean = true;
		
		/**
		 * When get random item from array is set to true then this property 
		 * contains the random item from the collection or array. 
		 * 
		 * @see shuffleArray
		 * @see doNotRepeatItems
		 * @see accessedItems
		 * @see unaccessedItems
		 * @see wrapToBeginning
		 * */
		[Bindable]
		public var data:Object;
	}
}