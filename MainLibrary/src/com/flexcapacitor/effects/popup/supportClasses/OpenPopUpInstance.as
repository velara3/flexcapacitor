
package com.flexcapacitor.effects.popup.supportClasses
{

/////////////////////////////////////////////////////////////////////////
//
// EFFECT INSTANCE
//
/////////////////////////////////////////////////////////////////////////

import com.flexcapacitor.effects.popup.OpenPopUp;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;

import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import mx.core.ClassFactory;
import mx.core.FlexGlobals;
import mx.core.FlexSprite;
import mx.core.IFlexDisplayObject;
import mx.managers.PopUpManager;
import mx.managers.SystemManager;

	
	/**
	 *
	 * @copy OpenPopUp
	 */ 
	public class OpenPopUpInstance extends ActionEffectInstance {
		
		
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
		public function OpenPopUpInstance(target:Object) {
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
			super.play(); // dispatches startEffect
			
			var action:OpenPopUp = OpenPopUp(effect);
			var classFactory:ClassFactory;
			var popUpType:Class = action.popUpType;
			var options:Object = action.options;
			var percentWidth:int = action.percentWidth;
			var percentHeight:int = action.percentHeight;
			var dropShadow:DropShadowFilter = action.dropShadow;
			var showDropShadow:Boolean = action.showDropShadow;
			var closeOnMouseDownOutside:Boolean = action.closeOnMouseDownOutside;
			var closeOnMouseDownInside:Boolean = action.closeOnMouseDownInside;
			var modalTransparencyColor:Number = action.backgroundColor;
			var modalTransparencyAlpha:Number = action.backgroundAlpha;
			var modalBlurAmount:Number = action.modalBlurAmount;
			var modalDuration:int = action.modalDuration;
			var addMouseEvents:Boolean = action.addMouseEvents;
			var parent:Sprite = action.parent;
			var setBackgroundBlendMode:Boolean;
			var height:int = action.height;
			var width:int = action.width;
			var popUp:Object;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (!popUpType) {
				dispatchErrorEvent("Please set the pop up class type");
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			classFactory = new ClassFactory();
			classFactory.generator = popUpType;
			classFactory.properties = options;
			
			popUp = classFactory.newInstance();
			
			// item renderers use the data property to pass information into the view
			if ("data" in popUp && action.data!=null) {
				popUp.data = action.data;
			}
			
			if (!(popUp is IFlexDisplayObject)) {
				dispatchErrorEvent("The pop up class type must be of a type 'IFlexDisplayObject'");
			}
			
			// more options could be set provided for these
			popUp.setStyle("modalTransparency", modalTransparencyAlpha);
			popUp.setStyle("modalTransparencyBlur", modalBlurAmount);
			popUp.setStyle("modalTransparencyColor", modalTransparencyColor);
			popUp.setStyle("modalTransparencyDuration", modalDuration);
			
			if (percentWidth!=0) {
				popUp.percentWidth = percentWidth;
			}
			if (percentHeight!=0) {
				popUp.percentHeight = percentHeight;
			}
			if (width!=0) {
				popUp.width = width;
			}
			if (height!=0) {
				popUp.height = height;
			}
			
			// add drop shadow
			if (showDropShadow) {
				var filters:Array = popUp.filters ? popUp.filters : [];
				var length:int = filters ? filters.length : 1;
				var found:Boolean;
				
				for (var i:int;i<length;i++) {
					if (filters[i] == action.dropShadow) {
						found = true;
					}
				}
				
				if (!found) {
					filters.push(action.dropShadow);
					popUp.filters = filters;
				}
				else {
					// filter already added
				}
			}
			
			if (addMouseEvents || closeOnMouseDownOutside) {
				IFlexDisplayObject(popUp).addEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler, false, 0, true);
				IFlexDisplayObject(parent).addEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler, false, 0, true);
			}
			
			if (addMouseEvents || closeOnMouseDownInside) {
				IFlexDisplayObject(popUp).addEventListener(MouseEvent.MOUSE_UP, mouseUpInsideHandler, false, 0, true);
			}
			
			if (action.autoCenter) {
				if (parent.stage) {
					parent.stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
				}
				else {
					parent.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
				}
			}
			
			
			PopUpManager.addPopUp(popUp as IFlexDisplayObject, parent, true);
			PopUpManager.centerPopUp(popUp as IFlexDisplayObject);
			
			
			if (setBackgroundBlendMode) {
				var modalWindow:FlexSprite;
				var systemManager:Object = SystemManager.getSWFRoot(FlexGlobals.topLevelApplication);
				var index:int = systemManager.rawChildren.getChildIndex(popUp);
				
				if (index>=0) {
					modalWindow = systemManager.rawChildren.getChildAt(index-1) as FlexSprite;
					
					if (modalWindow) {
						modalWindow.blendMode = BlendMode.NORMAL; //
					}
				}
			}
			
			
			if (action.autoCenter || action.keepReference) {
				action.popUp = popUp as IFlexDisplayObject;
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			//waitForHandlers();
			
			// we let the effect duration run until it is done
			if (action.nonBlocking) {
				finish();
				return;
			}
			
			
			///////////////////////////////////////////////////////////
			// Wait for handlers
			///////////////////////////////////////////////////////////
			waitForHandlers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
		private function mouseUpOutsideHandler(event:MouseEvent):void
		{
			var action:OpenPopUp = OpenPopUp(effect);
			
			IFlexDisplayObject(event.currentTarget).removeEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler);
			IFlexDisplayObject(event.currentTarget).removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideHandler);
			
			if (action.autoCenter) {
				if (action.parent.stage) {
					action.parent.stage.removeEventListener(Event.RESIZE, resizeHandler);
				}
				else {
					action.parent.removeEventListener(Event.RESIZE, resizeHandler);
				}
			}
			
			if (action.closeOnMouseDownOutside) {
				PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
			}
			
			if (action.hasEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE)) {
				action.dispatchEvent(new Event(OpenPopUp.MOUSE_DOWN_OUTSIDE));
			}
			
			if (action.mouseDownOutsideEffect) { 
				playEffect(action.mouseDownOutsideEffect);
				return;
			}
			
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		private function mouseUpInsideHandler(event:MouseEvent):void
		{
			var action:OpenPopUp = OpenPopUp(effect);
			
			IFlexDisplayObject(event.currentTarget).removeEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler);
			IFlexDisplayObject(event.currentTarget).removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideHandler);
			
			if (action.autoCenter) {
				if (action.parent.stage) {
					action.parent.stage.removeEventListener(Event.RESIZE, resizeHandler);
				}
				else {
					action.parent.removeEventListener(Event.RESIZE, resizeHandler);
				}
			}
			
			if (action.closeOnMouseDownOutside) {
				PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
			}
		
			if (action.hasEventListener(OpenPopUp.MOUSE_DOWN_INSIDE)) {
				action.dispatchEvent(new Event(OpenPopUp.MOUSE_DOWN_INSIDE));
			}
			
			if (action.mouseDownInsideEffect) { 
				playEffect(action.mouseDownInsideEffect);
				return;
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		private function resizeHandler(event:Event):void
		{
			var action:OpenPopUp = OpenPopUp(effect);
			
			PopUpManager.centerPopUp(action.popUp as IFlexDisplayObject);
		}
		
	}

}