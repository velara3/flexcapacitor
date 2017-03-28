package com.flexcapacitor.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexMouseEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Callout;
	
	
	[Style(name="borderAlpha", type="Number", format="Length", inherit="no", minValue="0.0", maxValue="1")]
	[Style(name="borderWeight", type="int", format="Length", inherit="no")]
	[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark")]
	[Style(name="frameThickness", type="Number", format="Length", inherit="no")]
	[Style(name="useBackgroundGradient", type="Boolean", format="Length", inherit="no")]
	
	[Style(name="arrowWidth", type="int", format="Length", inherit="no")]
	[Style(name="arrowHeight", type="int", format="Length", inherit="no")]
	
	[Style(name="backgroundCornerRadius", type="int", format="Length", inherit="no")]
	[Style(name="contentCornerRadius", type="int", format="Length", inherit="no")]
	
	[Style(name="dropShadowBlurX", type="int", format="Length", inherit="no")]
	[Style(name="dropShadowBlurY", type="int", format="Length", inherit="no")]
	[Style(name="dropShadowDistance", type="int", format="Length", inherit="no")]
	[Style(name="dropShadowAngle", type="int", format="Length", inherit="no")]
	[Style(name="dropShadowAlpha", type="Number", format="Length", inherit="no", minValue="0.0", maxValue="1")]
	
	/**
	 * Adds additional styles to the callout for CSS code completion
	 * 
	 * Adds options to close the callout on mouse down outside and
	 * adds the option to update the position when the owner is resized.
	 * 
	 * @copy spark.components.Callout
	 * */
	public class Callout extends spark.components.Callout
	{
		public function Callout()
		{
			super();
		}
		
		/**
		 * Hides the callout when the mouse clicked outside of the editor 
		 * and outside of the rich editable text component.
		 * */
		public var hideOnMouseDownOutside:Boolean = false;
		
		/**
		 * Updates the call out position when the owner is resized
		 * */
		public var updatePositionOnOwnerResize:Boolean = true;
		
		/**
		 * 
		 * */
		override public function open(owner:DisplayObjectContainer, modal:Boolean = false):void {
			super.open(owner, modal);
			
			
			if (hideOnMouseDownOutside && !hasEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE)) {
				addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler, false, 0, true);
			}
			else if (!hideOnMouseDownOutside) {
				removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler);
			}
			
			if (updatePositionOnOwnerResize) {
				owner.addEventListener(Event.RESIZE, owner_resizeHandler, false, 0, true);
			}
			
		}
		
		/**
		 *  @private
		 */
		override public function close(commit:Boolean=false, data:*=null):void {
			
			if (updatePositionOnOwnerResize) {
				owner.removeEventListener(Event.RESIZE, owner_resizeHandler);
			}
			
			if (hideOnMouseDownOutside) {
				removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler);
			}
			
			super.close(commit, data);
		}
		
		public function mouseDownOutsideHandler(event:MouseEvent):void {
			var focusedComponent:Object = focusManager.getFocus();
			var relatedObject:Object = event.relatedObject;
			var isRelatedObjectRelated:Boolean;
			
			isRelatedObjectRelated = owner.contains(relatedObject as DisplayObject);
			
			if (focusedComponent!=owner || 
				(relatedObject!=owner && !isRelatedObjectRelated)) {
				close(false);
			}
			
		}
		
		protected function owner_resizeHandler(event:ResizeEvent):void {
			updatePopUpPosition();
		}
	}
}