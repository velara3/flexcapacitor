
/**
 * NOTES: 
 * This should really allow for custom buttons array. 
 * */
package com.flexcapacitor.prompt {
	import com.flexcapacitor.prompt.supportClasses.IPrompt;
	import com.flexcapacitor.prompt.view.PromptDialog;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	/**
	 * Displays a Prompt message showing icons and buttons with the component of your choice. 
	 * Credits: http://forums.adobe.com/thread/756516
	 * */
	public class PromptManager {
		
		/**
		 * Constant for the name of the state in the view to display. 
		 * */
		public static const OK_BUTTON_VIEW:String			= "ok";
		public static const OK_CANCEL_BUTTON_VIEW:String	= "okCancel";
		public static const YES_NO_BUTTON_VIEW:String		= "yesNo";
		public static const NO_BUTTONS_VISIBLE_VIEW:String	= "none";
		
		/**
		 * Label of buttons
		 * */
		public static const OK_BUTTON_LABEL:String		= "ok";
		public static const CANCEL_BUTTON_LABEL:String	= "cancel";
		public static const YES_BUTTON_LABEL:String		= "yes";
		public static const NO_BUTTON_LABEL:String		= "no";
		
		/**
		 * Constant for the name of the icon to display
		 * */
		public static const ADD:String		= "add";
		public static const ALERT:String	= "alert";
		public static const CANCEL:String	= "cancel";
		public static const CLEAR:String	= "clear";
		public static const CLOSE:String	= "close";
		public static const DELETE:String	= "delete";
		public static const EDIT:String		= "edit";
		public static const HELP:String		= "help";
		public static const INFO:String 	= "info";
		public static const MORE:String		= "more";
		public static const SAVE:String		= "save";
		public static const NO_ICON:String	= "noIcon";
		
		/**
		 * Reference to the class used to create the view. Used with the show method.
		 * Must be of type IAlertable. 
		 * */
		public static var PromptDialogClass:Class = PromptDialog;
		
		
		public function PromptManager() {
			
		}
		
		/**
		 * Opens a dialog box. Set defaults on the view class or an instance of the view class. 
		 * */
		public static function show(message:String, title:String = null, buttons:String = null, icon:String = null, parent:DisplayObject = null):* {
			var messageBox:IPrompt = new PromptDialogClass();
			
			messageBox.message	= message;

			if (buttons) messageBox.buttons = buttons;
			if (icon) messageBox.icon = icon;
			if (title) messageBox.title = title;
			
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
			
			PopUpManager.addPopUp(IFlexDisplayObject(messageBox), parent, true);
			PopUpManager.centerPopUp(IFlexDisplayObject(messageBox));
			
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