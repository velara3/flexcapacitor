

package com.flexcapacitor.effects.prompt {
	
	import com.flexcapacitor.effects.prompt.supportClasses.PromptActionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.Sprite;
	
	/**
	 * Shows a prompt message with ok and cancel action. 
	 * */
	public class PromptAction extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function PromptAction(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = PromptActionInstance;
		}
		
		/**
		 * Title of prompt.
		 * */
		public var title:String;
		
		/**
		 * The parent display object that this prompt will be shown and centered above. 
		 * */
		public var parentView:Sprite;
		
		/**
		 * Message to display in the prompt. 
		 * */
		public var message:String;
		
		/**
		 * The buttons to show. Valid values are "ok", "yesNo", "okCancel".
		 * */
		public var buttons:String;
		
		/**
		 * Icon to show. 
		 * */
		public var icon:String;
		
		/**
		 * The sequence continues if the button with the matching label is pressed.
		 * This is almost always set to "ok" or "yes". 
		 * */
		public var continueAfterButtonNamed:String;
	}
}