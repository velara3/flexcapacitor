
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.popup.supportClasses.OpenPopUpInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.effects.IEffect;
	
	/**
	 * Mouse down outside event
	 * */
	[Event(name="mouseDownOutside", type="flash.events.MouseEvent")]
	
	/**
	 * Mouse down inside event
	 * */
	[Event(name="mouseDownInside", type="flash.events.MouseEvent")]
	
	/**
	 * Opens a pop up. 
	 * Pop up is sized to the default size of the pop up type unless otherwise specified.
	 * 
	 * To Use:<br/>
	 * <pre>
&lt;popup:OpenPopUp id="openExportToImageEffect" 
		 popUpType="{ExportToImage}" 
		 modalDuration="250"
		 showDropShadow="true"
		 modalBlurAmount="1"
		 keepReference="true"
		 options="{{source:myImage.source, data:dataGrid.selectedItem}}">
&lt;/popup:OpenPopUp>

	 * </pre>
	 * 
	 * Typically you will want to close the pop up. You can do so with ClosePopUp:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{openExportToImageEffect.popUp}" />
	 * </pre>
	 * 
	 * When inside the pop up itself use:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{this}" />
	 * </pre>
	 * 
	 * Note: If the pop up is not centered the pop up width may too low. 
	 * You may try removing the width on the pop up (so it will be sized to it's contents). 
	 * Or the pop up parent may need to be set. 
	 * */
	public class OpenPopUp extends ActionEffect {
		
		/**
		 * Event name constant when mouse down outside
		 * */
		public static const MOUSE_DOWN_OUTSIDE:String = "mouseDownOutside";
		
		/**
		 * Event name constant when mouse down inside
		 * */
		public static const MOUSE_DOWN_INSIDE:String = "mouseDownInside";
		
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
		 * Background alpha behind pop up
		 * */
		public var backgroundAlpha:Number = 0.75;
		
		/**
		 * Amount of blur on the modal background.
		 * Typical values are 1 to 10.
		 * */
		public var modalBlurAmount:int = 0;
		
		/**
		 * Duration of the modal fade in effect
		 * */
		public var modalDuration:int = 500;
		
		/**
		 * Data object that is passed to pop up if pop up contains a data property
		 * */
		public var data:Object;
		
		/**
		 * @copy mx.managers.PopUpManager#addPopUp
		 * */
		[Bindable]
		public var parent:Sprite = Sprite(FlexGlobals.topLevelApplication);
		
		/**
		 * Effect that is played when mouse down outside
		 * 
		 * @see #closeOnMouseDownOutside
		 * */
		public var mouseDownOutsideEffect:IEffect;
		
		/**
		 * Effect that is played when mouse down inside
		 * 
		 * @see #closeOnMouseDownInside
		 * */
		public var mouseDownInsideEffect:IEffect;
		
		/**
		 * If true and part of a sequence moves right to the next effect.
		 * Otherwise the next effect starts at the end of this effects duration. 
		 * */
		public var nonBlocking:Boolean = true;
		
		/**
		 * If true then mouse down inside and mouse down outside events are dispatched 
		 * */
		public var addMouseEvents:Boolean;
		
		/**
		 * Keeps a reference of the pop up 
		 * */
		public var keepReference:Boolean = false;
		
		/**
		 * Centers the pop up when stage resize
		 * */
		public var autoCenter:Boolean = true;
		
		/**
		 * Keeps a reference of the pop up 
		 * 
		 * @see #keepReference
		 * */
		[Bindable]
		public var popUp:IFlexDisplayObject;
	}
}
