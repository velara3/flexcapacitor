

package com.flexcapacitor.effects.status {
	
	import com.flexcapacitor.effects.status.supportClasses.IStatusMessage;
	import com.flexcapacitor.effects.status.supportClasses.ShowStatusMessageInstance;
	import com.flexcapacitor.effects.status.supportClasses.StatusMessage;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.Sprite;
	
	/**
	 * Displays a message and then fades out the message. 
	 * The duration must be more than 1 second.
	 * */
	public class ShowStatusMessage extends ActionEffect {
		
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var CENTER:Number = .5;
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var TOP:Number = .25;
		
		/**
		 * Constant defining the location the pop up will appear
		 * */
		public static var BOTTOM:Number = .75;
		
		/**
		 *  Constructor.
		 * */
		public function ShowStatusMessage(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 2000;
			
			instanceClass = ShowStatusMessageInstance;
		}
		
		/**
		 * Status message class
		 * */
		public var statusMessageClass:Class = StatusMessage;
		
		/**
		 * Status message class properties
		 * */
		public var statusMessageProperties:Object;
		
		/**
		 * Title of item
		 * */
		public var title:String;
		
		/**
		 * The parent display object that this will be centered above. 
		 * */
		public var parentView:Sprite;
		
		/**
		 * Message to display
		 * */
		public var message:String;
		
		/**
		 * If the modal is true then 
		 * no interaction is possible until the status message is closed.
		 * */
		public var modal:Boolean;
		
		/**
		 * Display message until clicked 
		 * */
		public var doNotClose:Boolean;
		
		/**
		 * Show busy icon
		 * */
		public var showBusyIcon:Boolean;
		
		/**
		 * The location the message will appear at. 
		 * Top is a quarter of the way down, middle is half and bottom is 3/4ths.
		 * You can set a specific value with the locationPosition property. 
		 * @see locationPosition
		 * */
		[Inspectable(enumeration="top,center,bottom")]
		public var location:String = "center";
		
		/**
		 * The location the message will appear at. 
		 * This is a value from 0 to 1 that signifies how far down
		 * the message should appear. For example, .8 would be 80% of the way down.
		 * This overrides the location value. 
		 * */
		public var locationPosition:Number;
		
		/**
		 * Function to run when item is clicked on
		 * */
		public var closeHandler:Function;
		
		/**
		 * If true and part of a sequence moves right to the next effect.
		 * Otherwise the next effect starts at the end of this effects duration. 
		 * */
		public var nonBlocking:Boolean = true;
		
		/**
		 * Keeps a reference of the status message object
		 * */
		public var keepReference:Boolean = false;
		
		/**
		 * Reference to the status message object. Must set keep reference to true.
		 *  
		 * @see keepReference
		 * */
		[Bindable]
		public var statusMessagePopUp:Object;
	}
}