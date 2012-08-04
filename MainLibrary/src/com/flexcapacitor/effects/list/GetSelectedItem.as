

package com.flexcapacitor.effects.list {
	
	import com.flexcapacitor.effects.list.supportClasses.GetSelectedItemInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when there is no selected item.
	 * 
	 * The default action is to cancel out of the sequence if the 
	 * property is not set. 
	 * */
	[Event(name="noSelectedItem", type="flash.events.Event")]
	
	/**
	 * Gets the selected item in the List. 
	 * The selected item is set to the data property.
	 * If there is no selected item then the noSelectedItemEffect is played.
	 * */
	public class GetSelectedItem extends ActionEffect {
		
		/**
		 * Event name constant when there is no selected item.
		 * */
		public static const NO_SELECTED_ITEM:String = "noSelectedItem";
		
		
		/**
		 *  Constructor.
		 * */
		public function GetSelectedItem(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = GetSelectedItemInstance;
			
		}
		
		/**
		 * Effect that is played if there is no selected item.
		 * */
		public var noSelectedItemEffect:Effect;
		
		/**
		 * The reference to the selected item. 
		 * */
		public var data:Object;
		
		/**
		 * The index of the selected item 
		 * */
		public var dataIndex:int;
		
	}
}