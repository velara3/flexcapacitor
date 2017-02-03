
package com.flexcapacitor.model {
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.effects.effectClasses.PropertyChanges;
	import com.flexcapacitor.states.AddItems;
	
	/**
	 * Contains the information used to go forward and back in history.
	 * 
	 * This is a description value object of a history event not a dispatched Event object. 
	 * 
	 * There are three types of events, 
	 * add display object
	 * remove display object
	 * set property / style
	 * */
	public class HistoryEventItem {
		
		public static const ADD_ITEM:String = "addItem";
		public static const REMOVE_ITEM:String = "removeItem";
		public static const PROPERTY_CHANGE:String = "propertyChanged";
		public static const STYLE_CHANGE:String = "styleChanged";
		
		public function HistoryEventItem() {
			
		}
		
		/**
		 * Names of affected properties
		 * */
		public var properties:Array;
		
		/**
		 * Names of affected styles
		 * */
		public var styles:Array;
		
		/**
		 * Names of affected events
		 * */
		public var events:Array;
		
		/**
		 * Contains the original property changes object
		 * */
		public var propertyChanges:PropertyChanges;
		
		/**
		 * List of targets
		 * */
		public var targets:Array = [];
		
		/**
		 * Indicates if the property change has been reversed
		 * */
		[Bindable]
		public var reversed:Boolean;
		
		/**
		 * Description of change. 
		 * */
		public var description:String;
		
		/**
		 * Description of the action this event contains
		 * */
		[Inspectable(enumeration="addItem,removeItem,propertyChanged,styleChanged")]
		public var action:String;
		
		/**
		 * @copy mx.states.AddItems
		 * */
		public var addItemsInstance:AddItems;
		
		/**
		 * @copy mx.states.AddItems
		 * */
		public var removeItemsInstance:AddItems;
		
		/**
		 * @copy mx.states.AddItems
		 * */
		public var reverseItemsInstance:AddItems;
		
		/**
		 * @copy mx.states.AddItems.apply()
		 * */
		public var parent:UIComponent;
		
		/**
		 * Stores the parents
		 * */
		public var reverseRemoveItemsDictionary:Dictionary = new Dictionary();
		
		/**
		 * Stores the parents
		 * */
		public var reverseAddItemsDictionary:Dictionary = new Dictionary();
		
		/**
		 * Called when item is removed from history. 
		 * Needs to null out all references??? Does GC do that?
		 * We are only nulling targets.
		 * */
		public function purge():void {
			targets = null;
		}
	}
}