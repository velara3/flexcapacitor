package com.flexcapacitor.events {
	import flash.events.Event;
	

	public class HistoryEventEvent extends Event {
		
		public function HistoryEventEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Dispatched when an item (usually a display object) is added
		 * */
		public static const ADD_ITEM:String = "addItem";
		
		/**
		 * Dispatched when an item (usually a display object) is moved
		 * */
		public static const MOVE_ITEM:String = "moveItem";
		
		/**
		 * Dispatched when an item (usually a display object) is removed
		 * */
		public static const REMOVE_ITEM:String = "removeItem";
		
		/**
		 * Dispatched when at the beginning of the undo history stack
		 * */
		public static const BEGINNING_OF_UNDO_HISTORY:String = "beginningOfUndoHistory";
		
		/**
		 * Dispatched when at the end of the undo history stack
		 * */
		public static const END_OF_UNDO_HISTORY:String = "endOfUndoHistory";
		
		/**
		 * Dispatched when history is changed.
		 * */
		public static const HISTORY_CHANGE:String = "historyChange";
		
		/**
		 * Dispatched when a property on the target is changed
		 * */
		public static const PROPERTY_CHANGED:String = "propertyChanged";
		
		/*
		public var data:Object;
		public var selectedItem:Object;
		public var property:String;
		public var properties:Array;
		public var propertiesAndStyles:Array;
		public var propertiesStylesEvents:Array;
		public var events:Array;
		public var changes:Array;
		public var value:*;
		public var multipleSelection:Boolean;
		public var addItemsInstance:AddItems;
		public var moveItemsInstance:AddItems;
		public var newIndex:int;
		public var oldIndex:int;
		public var historyEvent:HistoryEvent;
		public var historyEventItem:HistoryEventItem;
		public var historyEventItems:Array;
		public var targets:Array;
		public var tool:ITool;
		public var previewType:String;
		public var openInBrowser:Boolean;
		public var color:uint;
		public var invalid:Boolean;
		public var isRollOver:Boolean;
		public var scaleX:Number;
		public var scaleY:Number;
		public var status:String;
		public var successful:Boolean;
		public var faultEvent:Event;
		public var serviceEvent:IServiceEvent;
		public var styles:Array;
		public var error:Object;
		public var resized:Boolean;
		public var previewClosed:Boolean;
		public var documentClosed:Boolean;
		*/
		/*
		override public function clone():Event {
			throw new Error("do this");
			return new HistoryEvent(type, bubbles, cancelable, selectedItem);
		}
		*/
	}
		
}