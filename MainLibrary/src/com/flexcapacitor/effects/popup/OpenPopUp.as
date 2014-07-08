
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
	
	import mx.core.IFlexDisplayObject;
	import mx.effects.IEffect;
	
	/**
	 * Pop up close event
	 * */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Pop up close event when continue condition is met
	 * */
	[Event(name="continue", type="flash.events.Event")]
	
	/**
	 * Pop up close event when cancel condition is met
	 * */
	[Event(name="cancel", type="flash.events.Event")]
	
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
&lt;popup:OpenPopUp id="openExportEffect" 
		 popUpType="{ExportPopUp}" 
		 modalDuration="250"
		 showDropShadow="true"
		 modalBlurAmount="1"
		 keepReference="true"
		 percentWidth="75"
		 percentHeight="90"
		 popUpOptions="{{source:myImage.source, item:list.selectedItem}}"
		 data="{myData}"
		 close="openpopup_closeHandler(event)"
&lt;/popup:OpenPopUp>
 * 

protected function openpopup_closeHandler(event:Event):void {
	var code:String = ExportPopUp(openExportEffect.popUp).code;
	
}
</pre>

	 * ExportPopUp.mxml: 
	<pre>&lt;s:Group width="100%">&lt;s:Button label="Hello world"/>&lt;/s:Group>
	</pre>
	 * When inside the pop up call ClosePopUp to close the pop up:<br/>
<pre>
&lt;popup:ClosePopUp popUp="{this}" />
</pre>
	 * 
	 * When outside of the pop up you can close the pop up with:<br/>
<pre>
&lt;popup:ClosePopUp popUp="{openExportToImageEffect.popUp}" />
</pre>
	 * 
	 * 
	 * Note: If the pop up is not centered the pop up width may too low. 
	 * You may try removing the width on the pop up (so it will be sized to it's contents). 
	 * Or the pop up parent may need to be set.<br/><br/> 
	 * 
	 * Note: If you call this too quickly and effects are applied to the 
	 * pop up the modal overlay window may display above the application. 
	 * 
	 * */
	public class OpenPopUp extends ActionEffect {
		
		/**
		 * Event name constant when pop up is closed
		 * */
		public static const CLOSE:String = "close";
		
		/**
		 * Event name constant when pop up is closed and user cancels
		 * */
		public static const CANCEL_ACTION:String = "cancel";
		
		/**
		 * Event name constant when pop up is closed and user continues
		 * */
		public static const CONTINUE_ACTION:String = "continue";
		
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
		 * Popup options. Object of name value pairs used by the ClassFactory properties object.
		 * */
		public var popUpOptions:Object;
		
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
		public var parent:Sprite;
		
		/**
		 * If true then window is modal. 
		 * */
		public var isModal:Boolean = true;
		
		/**
		 * If true and part of a sequence moves right to the next effect.
		 * Otherwise the next effect starts at the end of this effects duration. 
		 * @see modalDuration
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
		 * When true only allows one instance at a time
		 * */
		public var preventMultipleInstances:Boolean = true;
		
		/**
		 * When preventMultipleInstances is true and this is true then 
		 * closes previous open instances
		 * */
		public var closePreviousInstanceIfOpen:Boolean;
		
		/**
		 * Indicates if close event has been dispatched yet.
		 * */
		public var dispatchedCloseEvent:Boolean;
		
		/**
		 * Keeps a reference of the pop up 
		 * 
		 * @see #keepReference
		 * */
		[Bindable]
		public var popUp:IFlexDisplayObject;
		
		/**
		 * Name of property to check for additional action. Default is action. 
		 * */
		[Bindable]
		public var actionPropertyName:String = "action";
		
		/**
		 * Value of property to action variable contains to play the continue effect
		 * */
		[Bindable]
		public var continueActionValue:String = CONTINUE_ACTION;
		
		/**
		 * Value of property that action variable contains to play cancel effect
		 * */
		[Bindable]
		public var cancelActionValue:String = CANCEL_ACTION;
		
		/**
		 * If you want to stop playing effects on mouse down outside
		 * */
		public var endEffectsPlaying:Boolean;
		
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
		 * Effect that is played when the pop up is closed
		 * 
		 * @see continueEffect
		 * @see cancelEffect
		 * */
		public var closeEffect:IEffect;
		
		/**
		 * Effect that is played when the pop up is closed but has a continue value.
		 * 
		 * @see action
		 * @see continueActionValue
		 * @see cancelActionValue
		 * @see closeEffect
		 * @see cancelEffect
		 * */
		public var continueEffect:IEffect;
		
		/**
		 * Effect that is played when the pop up is closed but has a cancel value.
		 * 
		 * @see action
		 * @see continueActionValue
		 * @see cancelActionValue
		 * @see closeEffect
		 * @see cancelEffect
		 * */
		public var cancelEffect:IEffect;
	}
}
