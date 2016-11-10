package com.flexcapacitor.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.MXFTETextInput;
	import mx.core.IVisualElement;
	
	import spark.events.TextOperationEvent;
	
	//--------------------------------------
	//  Event
	//--------------------------------------
	
	/**
	 * Dispatched when the clear button is pressed. 
	 * */ 
	[Event(name=CLEAR_TEXT,type="spark.events.TextOperationEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 * Border color. Added to overcome mobile profile that disabled it
	 * */ 
	[Style(name="borderColorMobile", type="uint", format="Color", inherit="yes")]
	
	/**
	 * Rounds the corners of the border automatically.
	 * */ 
	[Style(name="roundCorners", type="Boolean", inherit="yes")]
	
	/**
	 * Color of the clear button
	 * */
	[Style(name="clearButtonFillColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 * Adds a search icon and a clear button to the right side of the text display.
	 * Also adds rounded design look. 
	 * Adds borderColor style
	 * Extends MXFTETextInput (which extends Spark TextInput) to work in ColorPicker as a substitute text field
	 * */
	public class ClearButtonTextInput extends MXFTETextInput {
		
		/**
		 * Dispatched when the clear button is pressed
		 * */
		public static const CLEAR_TEXT:String = "clearText";
		
		public function ClearButtonTextInput():void {
			
		}
		
		/**
		 * When true show clear text button
		 * */
		public var showClearIcon:Boolean = true;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == clearButton) {
				clearButton.addEventListener(MouseEvent.CLICK, clearButtonHandler, false, 0, true);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == clearButton) {
				clearButton.removeEventListener(MouseEvent.CLICK, clearButtonHandler);
			}
		}
		
		/**
		 * Clear the text
		 * */
		protected function clearButtonHandler(event:Event):void {
			
			if (showClearIcon) {
				text = "";
				// dispatch value commit?
				textDisplay.text = "";
				textDisplay.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				
				//if (hasEventListener(CLEAR_TEXT)) {
					dispatchEvent(new TextOperationEvent(CLEAR_TEXT));
				//}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  clear button
		//----------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 *  The clear button 
		 * */
		public var clearButton:IVisualElement;
	}
}