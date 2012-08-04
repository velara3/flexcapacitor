package com.flexcapacitor.controls
{
	import com.flexcapacitor.skins.SearchTextInputSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	//--------------------------------------
	//  Event
	//--------------------------------------
	
	/**
	 * Dispatched when the clear button is pressed. 
	 * */ 
	[Event(name="clearText",type="spark.events.TextOperationEvent")]
	
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
	 * If true shows the search icon when empty
	 * */ 
	[Style(name="showSearchIcon", type="Boolean")]
	
	/**
	 * Adds an clear icon to the right side of the text display
	 * Adds borderColor style
	 * */
	public class SearchTextInput extends TextInput {
		
		/**
		 * Dispatched when the clear button is pressed
		 * */
		public static const CLEAR_TEXT:String = "clearText";
		
		public function SearchTextInput():void {
			super();
			
			setStyle("skinClass", com.flexcapacitor.skins.SearchTextInputSkin);
			setStyle("borderColorMobile", 0xCCCCCC);
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
		 * Clear the text
		 * */
		protected function clearButtonHandler(event:Event):void {
			
			if (showClearIcon) {
				text = "";
				// dispatch value commit?
				textDisplay.text = "";
				textDisplay.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				
				if (hasEventListener(CLEAR_TEXT)) {
					dispatchEvent(new TextOperationEvent(CLEAR_TEXT));
				}
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