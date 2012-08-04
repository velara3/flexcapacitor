

package com.flexcapacitor.effects.prompt.supportClasses {
	import com.flexcapacitor.effects.prompt.PromptAction;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.performance.PerformanceMeter;
	import com.flexcapacitor.prompt.PromptManager;
	import com.flexcapacitor.prompt.supportClasses.PromptEvent;
	import com.flexcapacitor.prompt.view.PromptDialog;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	
	
	/**
	 *  The AlertActionInstance class implements the instance class
	 *  for the XML AddItem effect.
	 *  Flex creates an instance of this class when it plays a AddItem
	 *  effect; you do not create one yourself.
	 *
	 *  @see com.flexcapacitor.effects.xml.AddItem
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */  
	public class PromptActionInstance extends ActionEffectInstance {
		
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
		public function PromptActionInstance(target:Object) {
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
		 * */
		override public function play():void {
			super.play();
			
			var action:PromptAction = PromptAction(effect);
			
			target = PromptManager.show(action.message, action.title, action.buttons, action.icon, action.parentView);
			target.addEventListener(PromptEvent.PROMPT, handleButtonPress);
			
			
			waitForHandlers();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		protected function handleButtonPress(event:PromptEvent):void {
			var action:PromptAction = PromptAction(effect);
			
			if (action.continueAfterButtonNamed!=event.buttonPressed) {
				cancel();
			}
			else {
				finish();
			}
		}
		
	}
}