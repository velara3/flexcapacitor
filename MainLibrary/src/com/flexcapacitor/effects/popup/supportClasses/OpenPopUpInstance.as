
package com.flexcapacitor.effects.popup.supportClasses {

	import com.flexcapacitor.effects.popup.OpenPopUp;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.system.ApplicationDomain;
	import flash.ui.Keyboard;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.FlexSprite;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.ILayoutElement;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.EffectManager;
	import mx.events.SandboxMouseEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	import mx.styles.IStyleClient;
	
	use namespace mx_internal;
	
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
			var popUpType:Object = action.popUpType;
			var options:Object = action.popUpOptions;
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
			var isModal:Boolean = action.isModal;
			var parent:Sprite = action.parent ? action.parent : Sprite(FlexGlobals.topLevelApplication);
			var setBackgroundBlendMode:Boolean;
			var height:int = action.height;
			var width:int = action.width;
			var popUp:IFlexDisplayObject = action.popUp;
			var preventMultipleInstances:Boolean = action.preventMultipleInstances;
			var closePreviousInstanceIfOpen:Boolean = action.closePreviousInstanceIfOpen;
			var closeOnEscapeKey:Boolean = action.closeOnEscapeKey;
			var fitMaxSizeToApplication:Boolean = action.fitMaxSizeToApplication;
			var useHardPercent:Boolean = action.useHardPercent;
			var hasDefinition:Boolean;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (popUpType==null && action.popUpType is String) {
				hasDefinition = ApplicationDomain.currentDomain.hasDefinition(String(action.popUpType));
				
				if (hasDefinition) {
					popUpType = ApplicationDomain.currentDomain.getDefinition(String(action.popUpType));
				}
				else {
					dispatchErrorEvent("Please set the pop up class type to a class reference or qualified class name and ensure a reference to the class is included in your project");
				}
			}
			
			if (!popUpType) {
				dispatchErrorEvent("Please set the pop up class type");
			}
			
			if (popUp && preventMultipleInstances) {
				// could not get this to work at first
				// need to check EffectManager effects in progress???
				//dispatchErrorEvent("Multiple instances are not allowed");
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			action.dispatchedCloseEvent = false;
			
			if (popUp && popUp is UIComponent) {
				UIComponent(popUp).isEffectStarted;
				//trace("Effect started: " + UIComponent(popUp).isEffectStarted);
			}
			
			if (popUp && popUp is IUIComponent) {
				//trace("Ending effect for target: " + UIComponent(popUp).isEffectStarted);
				//EffectManager.endEffectsForTarget(popUp as IUIComponent);
				//trace("Ending effect for target: " + UIComponent(popUp).endEffectsStarted());
			}
			
			if (action.isOpen) {
				
				if (closePreviousInstanceIfOpen) {
					PopUpManager.removePopUp(popUp);
				}
				else {
					// do not add new one
					finish();
					return;
				}
			}
			
			classFactory = new ClassFactory();
			classFactory.generator = popUpType as Class;
			classFactory.properties = options;
			
			popUp = classFactory.newInstance();
			
			// item renderers use the data property to pass information into the view
			if ("data" in popUp && action.data!=null) {
				Object(popUp).data = action.data;
			}
			
			if (!(popUp is IFlexDisplayObject)) {
				dispatchErrorEvent("The pop up class type must be of a type 'IFlexDisplayObject'");
			}
			
			// more options could be set for these
			
			if (popUp is IStyleClient) {
				IStyleClient(popUp).setStyle("modalTransparency", modalTransparencyAlpha);
				IStyleClient(popUp).setStyle("modalTransparencyBlur", modalBlurAmount);
				IStyleClient(popUp).setStyle("modalTransparencyColor", modalTransparencyColor);
				IStyleClient(popUp).setStyle("modalTransparencyDuration", modalDuration);
			}
			
			if (useHardPercent) {
				if (percentWidth!=0 && popUp is ILayoutElement) {
					IFlexDisplayObject(popUp).width = FlexGlobals.topLevelApplication.width*(percentWidth/100);
				}
				
				if (percentHeight!=0 && popUp is ILayoutElement) {
					IFlexDisplayObject(popUp).height = FlexGlobals.topLevelApplication.height*(percentHeight/100);
				}
			}
			else {
				if (percentWidth!=0 && popUp is ILayoutElement) {
					ILayoutElement(popUp).percentWidth = percentWidth;
				}
				
				if (percentHeight!=0 && popUp is ILayoutElement) {
					ILayoutElement(popUp).percentHeight = percentHeight;
				}
			}
			
			if (width!=0) {
				popUp.width = width;
			}
			if (height!=0) {
				popUp.height = height;
			}
			
			if (fitMaxSizeToApplication && "maxHeight" in popUp) {
				Object(popUp).maxHeight = FlexGlobals.topLevelApplication.height;
				Object(popUp).maxWidth = FlexGlobals.topLevelApplication.width;
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
			
			
			IFlexDisplayObject(popUp).addEventListener(OpenPopUp.CLOSING, closingHandler, false, 0, true);
			
			if (addMouseEvents || closeOnMouseDownOutside) {
				IFlexDisplayObject(popUp).addEventListener(Event.REMOVED, removedHandler, false, 0, true);
				IFlexDisplayObject(popUp).addEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler, false, 0, true);
				IFlexDisplayObject(parent).addEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler, false, 0, true);
				IFlexDisplayObject(parent).addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpOutsideHandler, false, 0, true);
			}
			
			if (addMouseEvents || closeOnMouseDownInside) {
				IFlexDisplayObject(popUp).addEventListener(MouseEvent.MOUSE_UP, mouseUpInsideHandler, false, 0, true);
			}
			
			if (closeOnEscapeKey) {
				IFlexDisplayObject(popUp).addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
			}
			
			if (action.autoCenter) {
				if (parent.stage) {
					parent.stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
				}
				else {
					parent.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
				}
			}
			
			
			PopUpManager.addPopUp(popUp as IFlexDisplayObject, parent, isModal);
			PopUpManager.centerPopUp(popUp as IFlexDisplayObject);
			
			var systemManager:Object;
				
			// we have to set this after adding the pop up
			// so we can access the display object the pop up is apart of
			if (setBackgroundBlendMode) {
				var modalWindow:FlexSprite;
				systemManager = SystemManager.getSWFRoot(FlexGlobals.topLevelApplication);
				var index:int = systemManager.rawChildren.getChildIndex(popUp);
				
				if (index>=0) {// need to check id? because other display objects could be open (rare)
					modalWindow = systemManager.rawChildren.getChildAt(index-1) as FlexSprite;
					
					if (modalWindow) {
						modalWindow.blendMode = BlendMode.NORMAL;
						//modalWindow.addEventListener(MouseEvent.CLICK, mouseUpOutsideHandler, false, 0, true);
					}
				}
			}
			else {
				//systemManager = SystemManager.getSWFRoot(FlexGlobals.topLevelApplication);
				//systemManager.addEventListener(MouseEvent.CLICK, mouseUpOutsideHandler, false, 0, true);
			}
			
			
			//if (action.autoCenter || action.keepReference) { // we need to keep it for remove handler?
			if (true) {
				action.popUp = IFlexDisplayObject(popUp);
				//action.popUpParent = popUp.parent;
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
		
		public function closingHandler(event:Event):void {
			removeEventListeners();
			close();
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		public function keyUpHandler(event:KeyboardEvent):void {
			if (event.keyCode==Keyboard.ESCAPE) {
				removeEventListeners();
				close();
				
				///////////////////////////////////////////////////////////
				// End the effect
				///////////////////////////////////////////////////////////
				finish();
			}
		}
		
		public function close(removePopUps:Boolean = false):void {
			
			var action:OpenPopUp = OpenPopUp(effect);
			var popUp:Object = action.popUp;
			var actionProperty:String = action.actionPropertyName;
			var continueValue:String = action.continueActionValue;
			var cancelValue:String = action.cancelActionValue;
			
			if (removePopUps) {
				
			}
			
			if (!action.dispatchedCloseEvent) {
				
				removeEventListeners();
				
				if (action.hasEventListener(OpenPopUp.CLOSE)) {
					dispatchActionEvent(new Event(OpenPopUp.CLOSE));
				}
				
				if (action.closeEffect) { 
					playEffect(action.closeEffect);
				}
				
				if (actionProperty in popUp && popUp[actionProperty]==continueValue) {
					if (action.hasEventListener(OpenPopUp.CONTINUE_ACTION)) {
						dispatchActionEvent(new Event(OpenPopUp.CONTINUE_ACTION));
					}
					
					if (action.continueEffect) { 
						playEffect(action.continueEffect);
					}
				}
				else if (actionProperty in popUp && popUp[actionProperty]==cancelValue) {
					if (action.hasEventListener(OpenPopUp.CANCEL_ACTION)) {
						dispatchActionEvent(new Event(OpenPopUp.CANCEL_ACTION));
					}
					
					if (action.cancelEffect) { 
						playEffect(action.cancelEffect);
					}
				}
				
				action.dispatchedCloseEvent = true;
			}
			
			//traceMessage("Closing pop up");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Mouse up outside of parent or pop up
		 * */
		private function mouseUpOutsideHandler(event:Event):void {
			var action:OpenPopUp = OpenPopUp(effect);
			var close:Boolean;
			var popUp:IFlexDisplayObject = action.popUp;
			
			if (popUp && popUp as IUIComponent && UIComponent(popUp).isEffectStarted) {
				if (action.endEffectsPlaying && popUp && popUp as IUIComponent) {
					EffectManager.endEffectsForTarget(popUp as IUIComponent);
				}
				
				// we exit out because if we continue, we would close the pop up.
				// but if we did that then when the effect ends it puts up a 
				// display object "shield" and there would be no way to close 
				// the display object shield since we removed the pop up 
				// display object that has our closing event listeners 
				return;
			}
			
			if (action.closeOnMouseDownOutside) {
				PopUpManager.removePopUp(action.popUp as IFlexDisplayObject);
				removeEventListeners();
				close = true;
			}
			
			if (action.hasEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE)) {
				dispatchActionEvent(new Event(OpenPopUp.MOUSE_DOWN_OUTSIDE));
			}
			
			if (action.mouseDownOutsideEffect) { 
				playEffect(action.mouseDownOutsideEffect);
			}
			
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			if (close) {
				finish();
			}
		}
		
		/**
		 * Mouse up inside pop up
		 * */
		private function mouseUpInsideHandler(event:Event):void {
			var action:OpenPopUp = OpenPopUp(effect);
			var close:Boolean;
			
			
			if (action.closeOnMouseDownInside) {
				PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
				removeEventListeners();
				close = true;
			}
		
			if (action.hasEventListener(OpenPopUp.MOUSE_DOWN_INSIDE)) {
				dispatchActionEvent(new Event(OpenPopUp.MOUSE_DOWN_INSIDE));
			}
			
			if (action.mouseDownInsideEffect) { 
				playEffect(action.mouseDownInsideEffect);
			}
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			if (close) {
				finish();
			}
		}
		
		/**
		 * Pop up was removed from the stage
		 * */
		private function removedHandler(event:Event):void {
			var action:OpenPopUp = OpenPopUp(effect);
			var popUp:Object = action.popUp;
			var actionProperty:String = action.actionPropertyName;
			var continueValue:String = action.continueActionValue;
			var cancelValue:String = action.cancelActionValue;
			
			// prevent bubbled up removed events from content inside the pop up
			if (event.target != popUp) { return; }
			
			close();
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		/**
		 * Remove event listeners
		 * */
		private function removeEventListeners():void {
			var action:OpenPopUp = OpenPopUp(effect);
			var popUp:IFlexDisplayObject = action.popUp;
			var parent:DisplayObject;
			
			if (popUp && popUp.parent) {
				parent = popUp.parent;
			}
			else if (action.parent) {
				parent = action.parent;
			}
			
			
			if (popUp) {
				IFlexDisplayObject(popUp).removeEventListener(OpenPopUp.CLOSING, closingHandler);
				IFlexDisplayObject(popUp).removeEventListener(Event.REMOVED, removedHandler);
				IFlexDisplayObject(popUp).removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideHandler);
				IFlexDisplayObject(popUp).removeEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler);
				IFlexDisplayObject(popUp).removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			
			if (parent) {
				IFlexDisplayObject(parent).removeEventListener(OpenPopUp.MOUSE_DOWN_OUTSIDE, mouseUpOutsideHandler);
				IFlexDisplayObject(parent).removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpOutsideHandler);
			}
			
			if (action.autoCenter) {
				if (parent && parent.stage) {
					parent.stage.removeEventListener(Event.RESIZE, resizeHandler);
				}
				else if (parent) {
					parent.removeEventListener(Event.RESIZE, resizeHandler);
				}
			}
		}
		
		private function resizeHandler(event:Event):void {
			var action:OpenPopUp = OpenPopUp(effect);
			
			if (action.closeOnResize) {
				close();
				finish();
				return;
			}
			
			if (action.fitMaxSizeToApplication && "maxHeight" in action.popUp) {
				Object(action.popUp).maxHeight = FlexGlobals.topLevelApplication.height;
				Object(action.popUp).maxWidth = FlexGlobals.topLevelApplication.width;
				if (action.popUp is IInvalidating) {
					IInvalidating(action.popUp).validateNow();
				}
			}
			
			PopUpManager.centerPopUp(action.popUp as IFlexDisplayObject);
		}
		
	}

}