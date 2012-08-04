
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	import mx.core.FlexGlobals;
	
	
	/**
	 * Opens a pop up. 
	 * Pop up is sized to the default size of the pop up type unless otherwise specified.
	 * */
	public class OpenPopUp extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 * 
		 */
		public function OpenPopUp(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = OpenPopUpInstance;
		}
		
		/**
		 * Popup class
		 * */
		public var popUpType:Class;
		
		/**
		 * Popup options. Object of name value pairs.
		 * */
		public var options:Object;
		
		/**
		 * Percent width. This is the percent of pop up's size
		 * */
		public var percentWidth:int;
		
		/**
		 * Percent height. This is the percent of pop up's size
		 * */
		public var percentHeight:int;
		
		/**
		 * Width
		 * */
		public var width:int;
		
		/**
		 * Height
		 * */
		public var height:int;
		
		/**
		 * Drop shadow
		 * */
		public var dropShadow:DropShadowFilter = new DropShadowFilter(0,45,0,1,8,8,.47);
		
		/**
		 * Show drop shadow
		 * */
		public var showDropShadow:Boolean;
		
		/**
		 * Close the pop up on mouse down outside
		 * */
		public var closeOnMouseDownOutside:Boolean = true;
		
		/**
		 * Close the pop up on mouse down inside
		 * */
		public var closeOnMouseDownInside:Boolean = false;
		
		/**
		 * Background color behind pop up
		 * */
		public var backgroundColor:Number = 0;
		
		/**
		 * Data object that is passed to pop up if pop up contains a data property
		 * */
		public var data:Object;
		
		/**
		 * @copy mx.managers.PopUpManager#addPopUp
		 * */
		public var parent:Sprite = Sprite(FlexGlobals.topLevelApplication);
	}
}



/////////////////////////////////////////////////////////////////////////
//
// EFFECT INSTANCE
//
/////////////////////////////////////////////////////////////////////////

import com.flexcapacitor.effects.popup.OpenPopUp;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;

import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
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
class OpenPopUpInstance extends ActionEffectInstance {
	
	
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
		popUp.setStyle("modalTransparency", .75);
		popUp.setStyle("modalTransparencyBlur", 0);
		popUp.setStyle("modalTransparencyColor", modalTransparencyColor);
		popUp.setStyle("modalTransparencyDuration", 500);
		
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
		
		if (closeOnMouseDownOutside) {
			IFlexDisplayObject(popUp).addEventListener("mouseDownOutside", mouseUpOutsideHandler, false, 0, true);
			IFlexDisplayObject(parent).addEventListener("mouseDownOutside", mouseUpOutsideHandler, false, 0, true);
		}
		
		if (closeOnMouseDownInside) {
			IFlexDisplayObject(popUp).addEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideHandler, false, 0, true);
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
		
		
		///////////////////////////////////////////////////////////
		// End the effect
		///////////////////////////////////////////////////////////
		finish();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	
	private function mouseUpOutsideHandler(event:MouseEvent):void
	{
		PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
		IFlexDisplayObject(event.currentTarget).removeEventListener("mouseDownOutside", mouseUpOutsideHandler);
		IFlexDisplayObject(event.currentTarget).removeEventListener(MouseEvent.MOUSE_UP, mouseUpOutsideHandler);
	}
	
} 