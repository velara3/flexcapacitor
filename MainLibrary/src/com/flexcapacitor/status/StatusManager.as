

package com.flexcapacitor.status {
	import com.flexcapacitor.status.supportClasses.IStatusMessage;
	import com.flexcapacitor.status.view.StatusMessage;
	
	import flash.display.Sprite;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	
	/**
	 * Used to create a status message. 
	 * */
	public class StatusManager {
		
		/**
		 * Reference to the class that is used to create a status message view. 
		 * Used with the statusUpdate method.
		 * Must be of type IStatusMessage
		 * */
		public static var StatusMessageClass:Class = StatusMessage;
		
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
		 * Displays a status type message.
		 * Visually there is no icon and no buttons. The message fades in and then fades out.  
		 * Typically used in reply to an action. A status message on an action performed. 
		 * To use call the reply method instead of the show method. 
		 * IE "Item Added." "Message sent successfully."
		 * */
		public function StatusManager() {
			
		}
		
		
		/**
		 * Shows a status type message. Creates an instance of the statusMessageClass.
		 * */
		public static function show(message:String, duration:int = 3000, showBusyIndicator:Boolean = false, parent:Sprite = null, modal:Boolean = false, location:Number = .5):* {
			var messageBox:IStatusMessage = new StatusMessageClass();
			
			messageBox.message = message;
			messageBox.duration = duration;
			messageBox.showBusyIndicator = showBusyIndicator;
			//if (title) messageBox.title = title;
			
			if (!parent) {
				var systemManager:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				
				// no types so no dependencies
				var marshallPlanSystemManager:Object = systemManager.getImplementation("mx.managers.IMarshallPlanSystemManager");
				
				if (marshallPlanSystemManager && marshallPlanSystemManager.useSWFBridge()) {
					parent = Sprite(systemManager.getSandboxRoot());
				}
				else {
					parent = Sprite(FlexGlobals.topLevelApplication);
				}
			}
			
			PopUpManager.addPopUp(IFlexDisplayObject(messageBox), parent, modal);
			PopUpManager.centerPopUp(IFlexDisplayObject(messageBox));
			
			IFlexDisplayObject(messageBox).y = parent.height*location - IFlexDisplayObject(messageBox).height/2;
			
			return messageBox;
		}
		
		
		/**
		 * Removes the view from the display
		 * */
		public static function close(view:IFlexDisplayObject):void {
			PopUpManager.removePopUp(view);
		}	
	}
}