////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.controls
{
	import com.flexcapacitor.controls.richTextEditorClasses.AlignTool;
	import com.flexcapacitor.controls.richTextEditorClasses.BoldTool;
	import com.flexcapacitor.controls.richTextEditorClasses.BulletTool;
	import com.flexcapacitor.controls.richTextEditorClasses.ClearFormattingTool;
	import com.flexcapacitor.controls.richTextEditorClasses.ColorTool;
	import com.flexcapacitor.controls.richTextEditorClasses.FontSizeTool;
	import com.flexcapacitor.controls.richTextEditorClasses.FontTool;
	import com.flexcapacitor.controls.richTextEditorClasses.ImageDetailsView;
	import com.flexcapacitor.controls.richTextEditorClasses.ImageTool;
	import com.flexcapacitor.controls.richTextEditorClasses.ItalicTool;
	import com.flexcapacitor.controls.richTextEditorClasses.LinkButtonTool;
	import com.flexcapacitor.controls.richTextEditorClasses.LinkDetailsView;
	import com.flexcapacitor.controls.richTextEditorClasses.UnderlineTool;
	import com.flexcapacitor.utils.TextFlowUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.text.Font;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	
	import spark.components.RichEditableText;
	import spark.components.TextSelectionHighlighting;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.RichEditableTextContainerManager;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.ColorChangeEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.FlowOperationEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.formats.Float;
	import flashx.textLayout.formats.ListStyleType;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.ApplyFormatOperation;
	import flashx.textLayout.property.Property;

	use namespace mx_internal;
	 
	[Event(name = FlexEvent.Change, type = "mx.events.FlexEvent")]
	[Event(name = LINK_SELECTED_CHANGE, type = "flash.events.Event")]
	[Event(name = IMAGE_ICON_CLICKED, type = "flash.events.Event")]
	[Event(name = LINK_ICON_CLICKED, type = "flash.events.Event")]
	
	[Style(name = "borderColor", inherit = "no", type = "unit")]
	[Style(name = "focusColor", inherit = "yes", type = "unit")]
	
	/*
	[SkinState(name="normal", required="false")]
	[SkinState(name="image", required="false")]
	[SkinState(name="link", required="false")]
	*/
	
	/**
	 * Component used to apply rich text formatting to a rich editable text field or text area
	 * 
	 * */
	public class RichTextEditorBar extends SkinnableComponent {
		
		public function RichTextEditorBar() {
			super();
			
			//addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, stateChangeCompleteHandler);
			//addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			
			textFlow = new TextFlow(); //Prevents a stack trace that happends when you try to access the textflow on click.
			
		}
		
		public static var LINK_VIEW:String = "linkView";
		public static var IMAGE_VIEW:String = "imageView";
		public static var NORMAL_VIEW:String = "normal";
		
		/**
		 * List of fonts 
		 * */
		public function get fontDataProvider():IList
		{
			return _fontDataProvider;
		}

		/**
		 * @private
		 */
		public function set fontDataProvider(value:IList):void
		{
			_fontDataProvider = value;
		}

		private var _defaultErrorHandler:Function;

		public function get defaultErrorHandler():Function
		{
			return _defaultErrorHandler;
		}

		public function set defaultErrorHandler(value:Function):void
		{
			_defaultErrorHandler = value;
			
			// set this to define an error handler that doesn't throw errors
			if (_defaultErrorHandler!=null) {
				Property.errorHandler = _defaultErrorHandler
			}
			else {
				//Property.errorHandler = Property.defaultErrorHandler;
			}
		}
		
		private var _fontDataProvider:IList;
		
		public const LINK_SELECTED_CHANGE:String = "linkSelectedChange";
		public const IMAGE_ICON_CLICKED:String = "imageIconClicked";
		public const LINK_ICON_CLICKED:String = "linkIconClicked";
		
		private var _htmlText:String;
		private var _htmlTextChanged:Boolean = false;
		private var _prompt:String = "";
		private var _stylesChanged:Dictionary = new Dictionary;
		private var _text:String;
		private var _textFlow:TextFlow;
		private var _linkSelected:Boolean = false;
		private var _linkElement:LinkElement
		private var _lastRange:ElementRange;
		
		public var _urlRegExpression:RegExp = new RegExp("^(https?://(www\\.)?|www\\.)[-._~:/?#\\[\\]@!$&'()*+,;=a-z0-9]+$", 'i');
		public var defaultLinkText:String = "";//"http://";
		public var defaultLinkTargetText:String = "_blank";
		public var fontSizeVector:Vector.<String> = new <String>["fontSize"];
		public var selectLinkOnFocus:Boolean = true;
		public var focusOnTextAfterFontChange:Boolean = true;
		public var focusOnTextAfterFontSizeChange:Boolean = true;
		
		private var _richEditableText:RichEditableText;

		[SkinPart(required="false")]
		public function get richEditableText():RichEditableText
		{
			return _richEditableText;
		}

		public function set richEditableText(value:RichEditableText):void
		{
			attachRichEditableText(value);
			_richEditableText = value;
		}

		[SkinPart(required="false")]
		public var fontTool:FontTool;
		
		[SkinPart(required="false")]
		public var fontSizeTool:FontSizeTool;
		
		[SkinPart(required="false")]
		public var boldTool:BoldTool;
		
		[SkinPart(required="false")]
		public var italicTool:ItalicTool;
		
		[SkinPart(required="false")]
		public var underlineTool:UnderlineTool;
		
		[SkinPart(required="false")]
		public var colorTool:ColorTool;
		
		[SkinPart(required="false")]
		public var alignTool:AlignTool;
		
		[SkinPart(required="false")]
		public var bulletTool:BulletTool;
		
		[SkinPart(required="false")]
		public var orderedBulletTool:BulletTool;
		
		[SkinPart(required="true")]
		public var linkButton:LinkButtonTool;
		
		[SkinPart(required="true")]
		public var linkDetailsView:LinkDetailsView;
		
		[SkinPart(required="false")]
		public var clearFormattingTool:ClearFormattingTool;
		
		[SkinPart(required="true")]
		public var imageButton:ImageTool;
		
		[SkinPart(required="true")]
		public var imageDetailsView:ImageDetailsView;
		
		/**
		 * Set this to true to set focus on rich text editor on the next frame.
		 * This helps solve an issue to maintain focus on the rich text field 
		 * when the editor bar is in a pop up.  
		 * Deprecated. Not sure if it is necessary. Look up active highlight selection? state on RET
		 * */
		public var setFocusLater:Boolean = true;
		
		public var deferredState:String;
		
		/**
		 * Set to true to automatically add links to text that look like links
		 * */
		public var automaticallyAddLinks:Boolean;

		[Bindable("change")]
		/**
		 *  The htmlText property is here for convenience. It converts the textFlow to TextConverter.TEXT_FIELD_HTML_FORMAT.
		 */
		public function get htmlText():String
		{
			if (_htmlTextChanged)
			{
				if (text == "")
				{
					_htmlText = "";
				}
				else
				{
					_htmlText = TextConverter.export(textFlow, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.STRING_TYPE) as String;
				}
				_htmlTextChanged = false;
			}
			return _htmlText;
		}

		/**
		 *  The htmlText property is here for convenience. It converts the textFlow to TextConverter.TEXT_FIELD_HTML_FORMAT.
		 */
		public function set htmlText(value:String):void
		{
			if (htmlText != value)
			{
				_htmlText = value;
				if (textFlow)
				{
					textFlow = TextConverter.importToFlow(_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
				}
			}
		}

		/**
		 *  @private
		 */
		public function get prompt():String
		{
			return _prompt;
		}

		/**
		 *  @private
		 */
		public function set prompt(value:String):void
		{
			_prompt = value;
			if (richEditableText)
			{
				// rich editable text does not support prompt
				// richEditableText.prompt = _prompt;
			}
		}

		/**
		 *  @private
		 */
		public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			_stylesChanged[styleProp] = getStyle(styleProp);
			this.invalidateDisplayList();
		}

		[Bindable("change")]
		/**
		 *  The text in the textArea
		 */
		public function get text():String
		{
			if (richEditableText)
			{
				return richEditableText.text;
			}
			else
			{
				return _text;
			}
		}

		/**
		 *  @private
		 */
		public function set text(value:String):void {
			_text = value;
			
			if (richEditableText) {
				richEditableText.text = value;
			}
		}

		[Bindable("change")]
		/**
		 *  The textFlow
		 */
		public function get textFlow():TextFlow {
			
			if (richEditableText){
				return richEditableText.textFlow;
			}
			
			return _textFlow;
		}

		/**
		 *  @private
		 */
		public function set textFlow(value:TextFlow):void
		{
			_textFlow = value;
			
			if (richEditableText) {
				richEditableText.textFlow = value;
			}
		}

		/**
		 *  @private
		 */
		protected override function partAdded(partName:String, instance:Object):void {
			
			super.partAdded(partName, instance);
			
			if (instance == richEditableText)
			{
				addTextArea(instance);
			}
			
			if (instance == fontTool)
			{
				fontTool.addEventListener(IndexChangeEvent.CHANGE, handleFontChange, false, 0, true);
				//fontTool.toolTip = "Font Family";
				
				if (fontDataProvider) {
					fontTool.dataProvider = fontDataProvider;
				}
			}
			
			if (instance == fontSizeTool)
			{
				fontSizeTool.addEventListener(IndexChangeEvent.CHANGE, handleSizeChange, false, 0, true);
				//fontSizeTool.toolTip = "Font Size";
			}
			
			if (instance == boldTool)
			{
				boldTool.addEventListener(MouseEvent.CLICK, handleBoldClick, false, 0, true);
				boldTool.toolTip = "Bold";
			}
			
			if (instance == italicTool)
			{
				italicTool.addEventListener(MouseEvent.CLICK, handleItalicClick, false, 0, true);
				italicTool.toolTip = "Italic";
			}
			
			if (instance == underlineTool)
			{
				underlineTool.addEventListener(MouseEvent.CLICK, handleUnderlineClick, false, 0, true);
				underlineTool.toolTip = "Underline";
			}
			
			if (instance == colorTool)
			{
				colorTool.addEventListener(ColorChangeEvent.CHOOSE, handleColorChoose, false, 0, true);
				colorTool.addEventListener(ColorPickerEvent.CHANGE, handleColorChoose, false, 0, true);
				//colorTool.addEventListener(Event.CLOSE, handleColorChoose, false, 0, true);
				colorTool.toolTip = "Color";
			}
			
			if (instance == alignTool) {
				alignTool.addEventListener(IndexChangeEvent.CHANGE, handleAlignChange, false, 0, true);
				alignTool.toolTip = "Set Alignment";
			}
			
			if (instance == bulletTool) {
				bulletTool.addEventListener(MouseEvent.CLICK, handleBulletClick, false, 0, true);
				bulletTool.toolTip = "Add List Items";
			}
			
			if (instance == orderedBulletTool) {
				orderedBulletTool.addEventListener(MouseEvent.CLICK, handleBulletClick, false, 0, true);
				orderedBulletTool.toolTip = "Add Ordered List Items";
			}
			
			if (instance == clearFormattingTool) {
				clearFormattingTool.addEventListener(MouseEvent.CLICK, handleClearFormattingClick, false, 0, true);
				clearFormattingTool.toolTip = "Clear Common Formatting";
			}
			
			if (instance == linkButton) {
				linkButton.addEventListener(MouseEvent.CLICK, showLinkDialogClick, false, 0, true);
				linkButton.toolTip = "Show Link";
				
				if (instance is ToggleButton) {
					toggles.push(instance);
				}
			}
			
			if (instance == imageButton) {
				imageButton.addEventListener(MouseEvent.CLICK, showImageDialogClick, false, 0, true);
				imageButton.toolTip = "Insert Image";
				
				if (instance is ToggleButton) {
					toggles.push(instance);
				}
			}
			
			if (instance == linkDetailsView) {
				linkDetailsView.textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown, false, 0, true);
				linkDetailsView.textDisplay.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate, false, 0, true);
				linkDetailsView.textDisplay.addEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput, false, 0, true);
				linkDetailsView.textDisplay.addEventListener(ClearButtonTextInput.CLEAR_TEXT, clearLinkUpdate, false, 0, true);
				
				linkDetailsView.targetLocations.addEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput, false, 0, true);
				linkDetailsView.targetLocations.addEventListener(Event.CHANGE, handleLinkTargetChange, false, 0, true);
			}
			
			if (instance == imageDetailsView) {
				imageDetailsView.imageSourceInput.addEventListener(KeyboardEvent.KEY_DOWN, handleImageKeydown, false, 0, true);
				imageDetailsView.imageSourceInput.addEventListener(ClearButtonTextInput.CLEAR_TEXT, handleImageURLClearButton, false, 0, true);
				
				imageDetailsView.floatTypeList.addEventListener(Event.CHANGE, handleInlineGraphicFloatListChange, false, 0, true);
				showImageErrorIcon(false);
			}
			
			handleSelectionChange();
		}
		
		protected function handleImageURLClearButton(event:Event):void
		{
			// http://www.gravatar.com/avatar/?d=retro&s=32
			showImageErrorIcon(false);
		}
		
		/**
		 *  @private
		 */
		protected override function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == richEditableText) {
				detachRichEditableText(instance);
			}
			
			if (instance == fontTool) {
				fontTool.removeEventListener(IndexChangeEvent.CHANGE, handleFontChange);
			}
			
			if (instance == fontSizeTool) {
				fontSizeTool.removeEventListener(IndexChangeEvent.CHANGE, handleSizeChange);
			}
			
			if (instance == boldTool) {
				boldTool.removeEventListener(MouseEvent.CLICK, handleBoldClick);
			}
			
			if (instance == italicTool) {
				italicTool.removeEventListener(MouseEvent.CLICK, handleItalicClick);
			}
			
			if (instance == underlineTool) {
				underlineTool.removeEventListener(MouseEvent.CLICK, handleUnderlineClick);
			}
			
			if (instance == colorTool) {
				colorTool.removeEventListener(ColorChangeEvent.CHOOSE, handleColorChoose);
			}
			
			if (instance == alignTool) {
				alignTool.removeEventListener(IndexChangeEvent.CHANGE, handleAlignChange);
			}
			
			if (instance == bulletTool) {
				bulletTool.removeEventListener(MouseEvent.CLICK, handleBulletClick);
			}
			
			if (instance == orderedBulletTool) {
				orderedBulletTool.removeEventListener(MouseEvent.CLICK, handleBulletClick);
			}
			
			if (instance == linkDetailsView) {
				linkDetailsView.textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown);
				linkDetailsView.textDisplay.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate);
				linkDetailsView.textDisplay.removeEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput);
				linkDetailsView.textDisplay.removeEventListener(ClearButtonTextInput.CLEAR_TEXT, clearLinkUpdate);
				
				linkDetailsView.targetLocations.removeEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput);
				linkDetailsView.targetLocations.removeEventListener(Event.CHANGE, handleLinkTargetChange);
			}
			
			if (instance == imageDetailsView) {
				imageDetailsView.imageSourceInput.removeEventListener(KeyboardEvent.KEY_DOWN, handleImageKeydown);
				imageDetailsView.floatTypeList.removeEventListener(Event.CHANGE, handleInlineGraphicFloatListChange);
			}
			
			if (instance == imageButton) {
				imageButton.removeEventListener(MouseEvent.CLICK, showImageDialogClick);
				
				if (instance is ToggleButton) {
					if (toggles.indexOf(instance)!=-1) {
						toggles.splice(toggles.indexOf(instance), 1);
					}
				}
			}
			
			if (instance == linkButton) {
				linkButton.removeEventListener(MouseEvent.CLICK, showImageDialogClick);
				
				if (instance is ToggleButton) {
					if (toggles.indexOf(instance)!=-1) {
						toggles.splice(toggles.indexOf(instance), 1);
					}
				}
			}
		}
		
		override protected function attachSkin():void {
			super.attachSkin();
			
			if (skin) {
				//skin.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, stateChangeCompleteHandler);
				skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			}
		}
		
		override protected function detachSkin():void {
			super.detachSkin();
			
			if (skin) {
				//skin.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, stateChangeCompleteHandler);
				skin.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			}
		}
		
		/**
		 * Array of toggle buttons that are selected in an open state in the skin
		 * */
		public var toggles:Array = [];
		
		/**
		 * Deselects toggle buttons when going from one open skin state to another
		 * */
		public function deselectToggles(selectedToggle:Object=null):void {
			var toggle:ToggleButton;
			
			for (var i:int = 0; i < toggles.length; i++)  {
				toggle = toggles[i] as ToggleButton;
				
				if (toggle!=selectedToggle) {
					toggle.selected = false;
				}
			}
			
		}
		
		/**
		 *  Handle link set by applying the link to the selected text
		 */
		private function handleLinkUpdate(event:Event = null):void {
			var urlText:String;
			var targetText:String;
			
			urlText = linkDetailsView.selectedLink == defaultLinkText ? '' : linkDetailsView.selectedLink;
			targetText = linkDetailsView.selectedTarget !="" ? linkDetailsView.selectedTarget : "_blank";
			applyLink(urlText, targetText, true);
			
			//Set focus to textFlow
			//richEditableText.textFlow.interactionManager.setFocus();
			setEditorFocus(true);
		}
		
		/**
		 * Handle inline graphic float style
		 * */
		protected function handleInlineGraphicFloatListChange(event:Event):void {
			var singleItemSelected:Boolean;
			var inlineGraphicElement:InlineGraphicElement;
			var inlineGraphicElementSelected:Boolean;
			var floatValue:String;
			
			singleItemSelected = Math.abs(richEditableText.selectionAnchorPosition - richEditableText.selectionActivePosition)==1;
			
			if (singleItemSelected) {
				inlineGraphicElement = TextFlowUtils.getInlineGraphicImageFromPosition(richEditableText.textFlow, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				
				if (inlineGraphicElement) {
					floatValue = imageDetailsView.floatValue;
					
					if (floatValue!=inlineGraphicElement.float) {
						modifyInlineImage(inlineGraphicElement.source, inlineGraphicElement.width, inlineGraphicElement.height, floatValue)
					}
					
					updateInlineGraphicElementPadding(inlineGraphicElement);
				}
			}
			
			showImageErrorIcon(false);
		}
		
		protected function handleLinkTargetChange(event:IndexChangeEvent):void {
			var linkElement:LinkElement;
			var selectionStart:int;
			var selectionEnd:int;
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				linkElement = TextFlowUtils.getLinkElementFromPosition(richEditableText.textFlow, selectionStart, selectionEnd);
				
				if (linkElement) {
					linkElement.target = linkDetailsView.targetLocations.selectedItem;
				}
			}
		}
		
		protected function showLinkDialogClick(event:MouseEvent):void {
			var linkVisible:Boolean;
			var iconClickedEvent:Event;
			
			iconClickedEvent = new Event(LINK_ICON_CLICKED, false, true);
			
			dispatchEvent(iconClickedEvent);
			
			if (event.isDefaultPrevented()) {
				return;
			}
			
			if (skin.currentState!=LINK_VIEW) {
				if (skin.currentState != NORMAL_VIEW) {
					deferredState = LINK_VIEW;
					skin.currentState = NORMAL_VIEW;
					deselectToggles(event.currentTarget);
					return;
				}
				
				skin.currentState = LINK_VIEW;
				
				/*
				linkVisible = linkDialog.visible;
				
				linkDialog.visible = !linkVisible;
				linkDialog.includeInLayout = !linkVisible;*/
			}
			else {
				skin.currentState = NORMAL_VIEW;
			}
		}
		
		protected function showImageDialogClick(event:MouseEvent):void {
			var linkVisible:Boolean;
			var iconClickedEvent:Event;
			
			iconClickedEvent = new Event(IMAGE_ICON_CLICKED, false, true);
			
			dispatchEvent(iconClickedEvent);
			
			if (event.isDefaultPrevented()) {
				return;
			}
			
			if (skin.currentState!=IMAGE_VIEW) {
				
				// go to normal state first then go to image view
				if (skin.currentState != NORMAL_VIEW) {
					deferredState = IMAGE_VIEW;
					skin.currentState = NORMAL_VIEW;
					deselectToggles(event.currentTarget);
					return;
				}
				
				skin.currentState = IMAGE_VIEW;
			}
			else {
				skin.currentState = NORMAL_VIEW;
			}
		}
		
		protected function stateChangeCompleteHandler(event:Event):void
		{
			if (deferredState!=null) {
				skin.currentState = deferredState;
				deferredState = null;
			}
		}
		
		protected function handleFocusInLinkTextInput(event:FocusEvent):void {
			//var leaf:SpanElement;
			var linkElement:LinkElement;
			var selectionStart:int;
			var selectionEnd:int;
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				linkElement = TextFlowUtils.getLinkElementFromPosition(richEditableText.textFlow, selectionStart, selectionEnd);
				
				// if there is no selection and cursor is in a link element
				// select the full link element when user places cursor in link editor field
				if (selectLinkOnFocus && linkElement && selectionStart==selectionEnd) {
					selectionStart = linkElement.getAbsoluteStart();
					selectionEnd = selectionStart + linkElement.textLength;
					richEditableText.selectRange(selectionStart, selectionEnd);
					//setEditorFocus();
				}
			}
		}
		
		protected function handleClearFormattingClick(event:MouseEvent):void
		{
			var currentFormat:TextLayoutFormat;
			var currentParagraphFormat:TextLayoutFormat;
			var selectionStart:int;
			var selectionEnd:int;
			var operationState:SelectionState;
			var editManager:IEditManager;
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				editManager = IEditManager(richEditableText.textFlow.interactionManager);
				
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				if (operationState == null) {
					operationState = new SelectionState(richEditableText.textFlow, selectionStart, selectionEnd);
				}
				
				currentFormat = editManager.getCommonCharacterFormat();
				currentParagraphFormat = editManager.getCommonParagraphFormat();
				
				//richEditableText.selectRange(selectionStart, selectionEnd);
				editManager.clearFormat(currentFormat, currentParagraphFormat, currentFormat);
				//editManager.clearFormatOnElement(linkElement.getChildAt(0), currentFormat);
				setEditorFocus();
			}
			
		}
		
		public function addTextArea(instance:Object):void {
			if (richEditableText!=instance) removeTextArea(richEditableText);
			richEditableText = instance as RichEditableText;
			
			instance.addEventListener(TextOperationEvent.CHANGE, handleChange);
			instance.addEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange);
			instance.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			if ("prompt" in richEditableText) {
				instance.prompt = prompt;
			}
			
			instance.textFlow = textFlow;
			
			if (_htmlText) {
				textFlow = TextConverter.importToFlow(_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			}
			else if (_text) {
				instance.text = _text;
			}			
		}
		
		public function removeTextArea(instance:Object):void {
			if (instance) {
				instance.removeEventListener(TextOperationEvent.CHANGE, handleChange);
				instance.removeEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange);
				instance.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				
				instance.visible = false;
				instance.includeInLayout = false;
			}
		}
		
		public function attachRichEditableText(instance:RichEditableText, addToStage:Boolean = false):void {
			
			if (_richEditableText!=instance && _richEditableText) detachRichEditableText(_richEditableText);
			
			_richEditableText = instance;
			
			//instance.focusRect = null;
			//instance.setStyle("focusAlpha", 0);
			instance.clearUndoOnFocusOut = false; // doesn't seem to work
			
			instance.addEventListener(TextOperationEvent.CHANGE, handleChange, false, 0, true);
			instance.addEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange, false, 0, true);
			instance.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
			instance.addEventListener(MouseEvent.CLICK, richEditableText_clickHandler, false, 0, true);
			instance.addEventListener(FlowOperationEvent.FLOW_OPERATION_END, flowOperationHandler, false, 0, true);
			
			// could we listen on the textflow instead or is that too fragile?
			instance.mx_internal::textContainerManager.addEventListener(FlowOperationEvent.FLOW_OPERATION_COMPLETE, 
				flowOperationCompleteHandler, false, 0, true);
			
			if ("prompt" in richEditableText) {
				Object(instance).prompt = prompt;
			}
			
			textFlow = instance.textFlow;
			
			if (_htmlText) {
				instance.textFlow = TextConverter.importToFlow(_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			}
			else if (_text) {
				instance.text = _text;
			}
			
			if (addToStage) {
				
			}
			
			if (selectionHighlighting) {
				instance.selectionHighlighting = selectionHighlighting;
			}
			else {
				instance.selectionHighlighting = TextSelectionHighlighting.WHEN_ACTIVE;
			}
			
			var configuration:Configuration= textFlow.configuration as Configuration;
			
			// listen for bullet lists
			if (configuration) {
				configuration.manageTabKey = true;
			}
			
			
		}
		
		public function detachRichEditableText(instance:Object, removeFromStage:Boolean = false):void {
			
			if (instance) {
				instance.removeEventListener(TextOperationEvent.CHANGE, handleChange);
				instance.removeEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange);
				instance.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				instance.removeEventListener(MouseEvent.CLICK, richEditableText_clickHandler);
				instance.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END, flowOperationHandler);
				instance.mx_internal::textContainerManager.removeEventListener(FlowOperationEvent.FLOW_OPERATION_COMPLETE, 
					flowOperationCompleteHandler);
				
				//instance.visible = false;
				//instance.includeInLayout = false;
				
				if (removeFromStage && instance.owner) {
					//IVisualElementContainer(instance.owner).removeElement(IVisualElement(instance));
				}
			}
			
		}
		
		protected function richEditableText_clickHandler(event:MouseEvent):void {
			//trace("rich editable text clicked");
			event.stopPropagation();
		}
		
		protected function testTextArea_changeHandler(event:TextOperationEvent):void {
			//trace(RichEditableText(testRichEditableText).contentHeight);
			richEditableText.height = RichEditableText(richEditableText).contentHeight + 2;
		}

		/**
		 *  @private
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (richEditableText)
			{
				for (var key:String in _stylesChanged)
				{
					richEditableText.setStyle(key, _stylesChanged[key]);
				}
				_stylesChanged = new Dictionary; //Clear it out
			}
		}
		
		
		/**
		 *  @private
		 *  Remove the link on the selection or at the link element containing the current cursor
		 */
		public function clearLink():void {
			var linkElement:LinkElement;
			var selectionStart:int;
			var selectionEnd:int;
			var operationState:SelectionState;
			var extendToLinkBoundary:Boolean;
			var target:String;
			
			if (richEditableText && richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				linkElement = TextFlowUtils.getLinkElementFromPosition(richEditableText.textFlow, selectionStart, selectionEnd);
				
				//Set the link
				if (operationState == null && linkElement != null) {
					operationState = new SelectionState(richEditableText.textFlow, linkElement.getAbsoluteStart(), linkElement.getAbsoluteStart() + linkElement.textLength);
				}
				
				//IEditManager(richEditableText.textFlow.interactionManager).applyLink("", target, extendToLinkBoundary);
				IEditManager(richEditableText.textFlow.interactionManager).applyLink("", target, extendToLinkBoundary, operationState);
				
				return;
				/*
				//return;
				IEditManager(richEditableText.textFlow.interactionManager).updateAllControllers();
				//Fix the formatting
				if (linkElement) {
					//IEditManager(richEditableText.textFlow.interactionManager).clearFormatOnElement(linkElement.getChildAt(0), currentFormat);
					//IEditManager(richEditableText.textFlow.interactionManager).applyFormatToElement(linkElement, currentFormat);
					//IEditManager(richEditableText.textFlow.interactionManager).applyFormatToElement(linkElement, currentFormat);
					richEditableText.selectRange(selectionStart, selectionEnd);
					//IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(currentFormat);
				}
				else {
					richEditableText.selectRange(selectionStart, selectionEnd);
					IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(currentFormat);
				}*/
				//IEditManager(richEditableText.textFlow.interactionManager).applyFormat(currentFormat, currentFormat, currentFormat);
			}
		}
		
		/**
		 *  @private
		 *  Actually apply the link to the selection. Repair the formating in the process.
		 */
		public function applyLink(href:String, target:String = null, extendToLinkBoundary:Boolean = false, operationState:SelectionState = null):void {
			var linkElement:LinkElement;
			var currentFormat:TextLayoutFormat;
			var selectionStart:int;
			var selectionEnd:int;
			
			if (richEditableText && richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				//Get the current format
				currentFormat = richEditableText.textFlow.interactionManager.getCommonCharacterFormat();
				
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				//Set the link
				if (operationState == null && _linkElement != null) {
					operationState = new SelectionState(richEditableText.textFlow, _linkElement.getAbsoluteStart(), _linkElement.getAbsoluteStart() + _linkElement.textLength);
				}
				
				linkElement = IEditManager(richEditableText.textFlow.interactionManager).applyLink(href, target, extendToLinkBoundary, operationState);
				
				//return;
				IEditManager(richEditableText.textFlow.interactionManager).updateAllControllers();
				//Fix the formatting
				if (linkElement) {
					//IEditManager(richEditableText.textFlow.interactionManager).clearFormatOnElement(linkElement.getChildAt(0), currentFormat);
					//IEditManager(richEditableText.textFlow.interactionManager).applyFormatToElement(linkElement, currentFormat);
					//IEditManager(richEditableText.textFlow.interactionManager).applyFormatToElement(linkElement, currentFormat);
					richEditableText.selectRange(selectionStart, selectionEnd);
					//IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(currentFormat);
				}
				else {
					richEditableText.selectRange(selectionStart, selectionEnd);
					IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(currentFormat);
				}
				//IEditManager(richEditableText.textFlow.interactionManager).applyFormat(currentFormat, currentFormat, currentFormat);
			}
		}
		
		/**
		 *  @private
		 *  Actually apply the link to the selection. Repair the formating in the process.
		 */
		public function applyLinkOriginal(href:String, target:String = null, extendToLinkBoundary:Boolean = false, operationState:SelectionState = null):void {
			var linkElement:LinkElement;
			var currentFormat:TextLayoutFormat;
			var selectionEnd:int;
			
			if (richEditableText && richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				//Get the current format
				currentFormat = richEditableText.textFlow.interactionManager.getCommonCharacterFormat();
				
				//Set the link
				if (operationState == null && _linkElement != null) {
					operationState = new SelectionState(richEditableText.textFlow, _linkElement.getAbsoluteStart(), _linkElement.getAbsoluteStart() + _linkElement.textLength);
				}
				
				linkElement = IEditManager(richEditableText.textFlow.interactionManager).applyLink(href, target, extendToLinkBoundary, operationState);
				
				//Fix the formatting
				if (linkElement) {
					IEditManager(richEditableText.textFlow.interactionManager).clearFormatOnElement(linkElement.getChildAt(0), currentFormat);
					IEditManager(richEditableText.textFlow.interactionManager).applyFormatToElement(linkElement, currentFormat);
				}
				
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				richEditableText.selectRange(selectionEnd, selectionEnd);
				IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(currentFormat);
				//IEditManager(richEditableText.textFlow.interactionManager).applyFormat(currentFormat, currentFormat, currentFormat);
			}
		}
		
		/**
		 * Insert an image
		 * 
		 * source is either 
		 *    a String interpreted as a uri, 
		 *    a Class interpreted as the class of an Embed DisplayObject, 
		 *    a DisplayObject instance or 
		 *    a URLRequest.
		 * width, height is a number or percent
		 * options - none 
		 */
		public function insertImage(source:Object, width:Object = null, height:Object = null, options:Object = null, operationState:SelectionState = null):InlineGraphicElement {
			var inlineGraphicElement:InlineGraphicElement;
			var currentFormat:TextLayoutFormat;
			var selectionStart:int;
			var selectionEnd:int;
			var loader:Loader;
			var displayObject:DisplayObject;
			var sprite:Sprite;
			var uicomponent:UIComponent;
			var editManager:IEditManager;
			
			if (richEditableText && richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				if (operationState == null && _linkElement != null) {
					operationState = new SelectionState(richEditableText.textFlow, _linkElement.getAbsoluteStart(), _linkElement.getAbsoluteStart() + _linkElement.textLength);
				}
				
				editManager =  IEditManager(richEditableText.textFlow.interactionManager);
				inlineGraphicElement = editManager.insertInlineGraphic(source, width, height, options, operationState);
				
				displayObject = inlineGraphicElement.graphic as DisplayObject;
				loader = inlineGraphicElement.graphic as Loader;
				sprite = inlineGraphicElement.graphic as Sprite;
				uicomponent = inlineGraphicElement.graphic as UIComponent;
				
				if (loader) {
					loader.contentLoaderInfo.addEventListener(Event.INIT, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(Event.OPEN, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, inlineGraphicElementLoader_complete, false, 0, true);
					loader.contentLoaderInfo.addEventListener(Event.UNLOAD, inlineGraphicElementLoader_complete, false, 0, true);
					
					loader.addEventListener(Event.ADDED, inlineGraphicElementLoader_complete, false, 0, true);
					loader.addEventListener(Event.ADDED_TO_STAGE, inlineGraphicElementLoader_complete, false, 0, true);
					richEditableText.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, inlineGraphicElementLoader_complete, false, 0, true);
					// add click handler after loaded
					//loader.addEventListener(MouseEvent.CLICK, handleInlineGraphicElementClick);
					//loader.addEventListener(MouseEvent.MOUSE_OUT, inlineGraphicElementMouseOut);
					loader.addEventListener(MouseEvent.MOUSE_MOVE, cursorObject_mouseMove, false, 0, true);
					loader.addEventListener(MouseEvent.ROLL_OVER, cursorObject_rollOver, false, 0, true);
					loader.addEventListener(MouseEvent.ROLL_OUT, cursorObject_rollOut, false, 0, true);
					//loader.addEventListener(MouseEvent.ROLL_OUT, inlineGraphicElementMouseOut);
					
					//loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
					displayObject = loader.parent; // may be null
					
					inlineGraphicElementsDictionary[loader] = inlineGraphicElement;
					
					if (displayObject) {
						displayObjectsDictionary[displayObject] = inlineGraphicElement;
					}
				}
				else if (displayObject) {
					if (uicomponent) {
						uicomponent.validateNow();
					}
					
					if (displayObject is Shape) {
						//addElement(button);
						//editor.addChild(button);
						//sprite = displayObject.parent as Sprite;
						//sprite.addChild(button);
						//removeElement(button);
					}
					
					inlineGraphicElementsDictionary[displayObject] = inlineGraphicElement;
				}
				
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, inlineGraphicElementLoader_complete);
				//loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
				
				//displayObject = loader.parent;
				
				//imageElementsDictionary[displayObject] = inlineGraphicElement;
				
				editManager.updateAllControllers();
				
				if (inlineGraphicElement) {
					TextFlowUtils.selectElement(inlineGraphicElement);
				}
				
			}
			
			return inlineGraphicElement;
		}
		
		/**
		 * Modify the 
		 * */
		public function modifyInlineImage(source:Object, width:Object = null, height:Object= null, options:Object = null, operationState:SelectionState = null):InlineGraphicElement {
			var inlineGraphicElement:InlineGraphicElement;
			var interactionManager:IEditManager;
			
			if (richEditableText && richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				interactionManager = IEditManager(richEditableText.textFlow.interactionManager);
				interactionManager.modifyInlineGraphic(source, width, height, options, operationState);
			}
			
			return inlineGraphicElement;
		}
		
		public var imageElementsDictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Determines when the text selection is highlighted.
		 * 
		 * @see spark.components.RichEditableText.selectionHighlighting
		 * */
		public var selectionHighlighting:String;
		
		/**
		 * Handle inline graphics loaded
		 * */
		public function inlineGraphicElementLoader_complete(event:Event):void {
			var inlineGraphicElement:InlineGraphicElement;
			var displayObject:DisplayObject;
			var loaderInfo:LoaderInfo;
			var loader:Loader;
			var sprite:Sprite;
			var bitmap:Bitmap;
			var actualWidth:int;
			var actualHeight:int;
			var graphicStatus:String;
			var currentTarget:Object;
			var eventType:String;
			var drawGraphics:Boolean;
			
			currentTarget = event.currentTarget;
			eventType = event.type;
			
			//trace("\n" + currentTarget);
			//trace("Event: " +  event.type);
			
			
			if (currentTarget is LoaderInfo) {
				loader = currentTarget.loader as Loader;
			}
			else if (currentTarget is Loader) {
				loader = currentTarget as Loader;
			}
			
			displayObject = loader ? loader.parent : null;
			sprite = displayObject ? displayObject as Sprite : null;
			
			
			// show loading icon???
			if (eventType==Event.OPEN && sprite) {
				/*
				var busyIndicator:BusyCursor = new BusyCursor();
				var button:Button = new Button();
				button.label="Test";
				button.width = 100;
				button.height = 22;
				sprite.width = button.width;
				sprite.height = button.height;
				loader.width = button.width;
				loader.height = button.height;
				button.validateNow();
				//sprite.addChild(button);
				
				//loader.addChild(button);
				sprite.addChild(busyIndicator);
				*/
			}
			
			inlineGraphicElement = inlineGraphicElementsDictionary[loader];
			
			// add to dictionary since the display object may not have been created yet
			if (displayObject && inlineGraphicElement && displayObjectsDictionary[displayObject]==null) {
				displayObjectsDictionary[displayObject] = inlineGraphicElement;
			}
			
			graphicStatus = inlineGraphicElement ? inlineGraphicElement.status : "inline graphic element not found";
			
			//trace("Graphic status: " + graphicStatus);
			
			if (eventType==IOErrorEvent.IO_ERROR) {
				//trace("Error: " + event);
				var errorText:String = IOErrorEvent(event).text;
				//sprite.removeChildren();loader.removeChildren();
			}
			
			if (graphicStatus=="error" || eventType==IOErrorEvent.IO_ERROR) {
				showImageErrorIcon(true, errorText);
				var source:String = inlineGraphicElement.source as String;
				
				if (source && showImageSourceOnError) {
					imageDetailsView.imageSourceInput.text = source;
				}
				
				// we need to remove event listeners after error because error keeps get generated
				// on all inline images that have href set to urls with a bad request
			}
			else {
				showImageErrorIcon(false);
			}
			
			if (eventType!=Event.ADDED_TO_STAGE) {
				return;
			}
			
			if (loader.content) {
				bitmap = loader.content as Bitmap;
				
				if (bitmap) {
					actualWidth = bitmap.width;
					actualHeight = bitmap.height;
				}
			}
			
			if (sprite) {
				sprite.buttonMode = true;
				
				if (drawGraphics) {
					if (sprite.width==0 && actualWidth) {
						sprite.width = actualWidth;
						sprite.height = actualHeight;
					}
					
					sprite.graphics.beginFill(0xff0000, .8);
					sprite.graphics.drawCircle(0,0, 10);
					sprite.graphics.endFill();
				}
			}
			
			if (displayObject) {
				displayObject.addEventListener(MouseEvent.CLICK, handleInlineGraphicElementClick, false, 0, true);
				//displayObject.addEventListener(MouseEvent.CLICK, highPriorityInlineGraphicElementClickHandler, true, EventPriority.CURSOR_MANAGEMENT, true);
			}
			
			// makes the graphic show up after loading
			//richEditableText.textFlow.flowComposer.updateAllControllers();
			
			//target_mc.y = (stage.stageHeight - target_mc.height) / 2;
			//target_mc.x = (stage.stageWidth - target_mc.width) / 2;
		}
		
		public var inlineGraphicElementsDictionary:Dictionary = new Dictionary(true);
		public var displayObjectsDictionary:Dictionary = new Dictionary(true);
		public var showImageSourceOnError:Boolean;
		
		public function showImageErrorIcon(show:Boolean, message:String = ""):void {
			
			if (imageDetailsView.loadErrorIcon) {
				if (show && !imageDetailsView.loadErrorIcon.visible) {
					imageDetailsView.loadErrorIcon.visible = show;
					imageDetailsView.loadErrorIcon.includeInLayout = show;
					imageDetailsView.loadErrorIcon.toolTip = message;
				}
				else if (!show && imageDetailsView.loadErrorIcon.visible) {
					imageDetailsView.loadErrorIcon.visible = show;
					imageDetailsView.loadErrorIcon.includeInLayout = show;
					imageDetailsView.loadErrorIcon.toolTip = message;
				}
			}
		}
		
		protected function handleInlineGraphicElementClick(event:Event):void
		{
			//trace ("Clicked: " + event.currentTarget);
			var inlineGraphicElement:InlineGraphicElement;
			var currentTarget:Object = event.currentTarget;
			var sprite:Sprite = currentTarget as Sprite;
			var target:Object = event.target;
			var loader:Loader = target as Loader;
			var object:Object;
			var startPosition:int;
			
			inlineGraphicElement = inlineGraphicElementsDictionary[currentTarget];
			
			if (inlineGraphicElement==null) {
				inlineGraphicElement = displayObjectsDictionary[currentTarget];
			}
			
			if (inlineGraphicElement==null) {
				object = currentTarget;
			}
			
			
			while (inlineGraphicElement==null) {
				
				inlineGraphicElement = inlineGraphicElementsDictionary[object];
				
				if (inlineGraphicElement==null && object && "parent" in object) {
					object = object.parent;
				}
				else {
					break;
				}
			}
			
			if (inlineGraphicElement!=null) {
				startPosition = inlineGraphicElement.getAbsoluteStart();
				// we select it like this because findleaf uses earliest position to find leaf elements
				// this makes the active position be the earliest position
				richEditableText.selectRange(startPosition+1, startPosition);
			}
			else {
				//trace("could not find element");
			}
			
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				// do something with the error
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				// do something with the error
			}
			else
			{
				// a non-Error, non-ErrorEvent type was thrown and uncaught
			}
		}
		
		/**
		 *  @private
		 *  Automatically add a link if the previous text looks like a link
		 */
		private function checkLinks():void {
			var position:int = richEditableText.selectionActivePosition;
			
			//Find the first non-whitespace character
			while (position > 0)
			{
				if (!isWhitespace(richEditableText.textFlow.getCharCodeAtPosition(position)))
				{
					break;
				}
				position--;
			}
			
			//Find the next whitespace character
			while (position > 0)
			{
				if (isWhitespace(richEditableText.textFlow.getCharCodeAtPosition(position)))
				{
					position++; //Back up one character
					break;
				}
				position--;
			}
			
			var testText:String = richEditableText.textFlow.getText(position, richEditableText.selectionActivePosition);
			var result:Array = testText.match(_urlRegExpression);
			
			if (result != null && result.length > 0) {
				
				if (richEditableText.textFlow.interactionManager is IEditManager) {
					var selectionState:SelectionState = new SelectionState(richEditableText.textFlow, position, richEditableText.selectionActivePosition);
					
					if (testText.substr(0, 3) == "www") {
						testText = "http://" + testText; //Add a missing 'http://' if needed
					}
					
					applyLink(testText, "_blank", true, selectionState);
					richEditableText.setFocus();
					setEditorFocus();
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function getBulletSelectionState():SelectionState {
			
			if (richEditableText.textFlow) {
				var selectionManager:ISelectionManager = richEditableText.textFlow.interactionManager;
				var selectionState:SelectionState = selectionManager.getSelectionState();
				var startleaf:FlowLeafElement = richEditableText.textFlow.findLeaf(selectionState.absoluteStart);
				var endleaf:FlowLeafElement = richEditableText.textFlow.findLeaf(selectionState.absoluteEnd);
				
				if (startleaf != null) {
					selectionState.absoluteStart = startleaf.getAbsoluteStart();
				}
				
				if (endleaf != null) {
					selectionState.absoluteEnd = endleaf.getAbsoluteStart() + endleaf.parentRelativeEnd - endleaf.parentRelativeStart;
				}
				return selectionState;
			}
			return null;
		}
		
		/**
		 *  @private
		 */
		private function handleAlignChange(e:Event):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			
			if (alignTool.selectedItem) {
				//var txtLayFmt:TextLayoutFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				newFormat.textAlign = alignTool.selectedItem.value;
				richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				richEditableText.setFocus();
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				setEditorFocus();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleBoldClick(e:MouseEvent):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			
			currentFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			newFormat.fontWeight = (currentFormat.fontWeight == FontWeight.BOLD) ? FontWeight.NORMAL : FontWeight.BOLD;
			richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			richEditableText.setFocus();
			richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			setEditorFocus();
		}
		
		/**
		 * At one point I thought the selection rectangle not working was 
		 * because of delayed actionscript but it appears
		 * it's a bug in RichEditableText that setFocus() does not 
		 * always work.
		 * 
		 * Calling setFocus on textFlow.interactionManager seems to work
		 * */
		public function setEditorFocus(useInteractionManager:Boolean = true):void {
			
			if (!setFocusLater) {
				
				if (useInteractionManager) {
					richEditableText.textFlow.interactionManager.setFocus();
				}
				else {
					richEditableText.setFocus();
				}
			}
			else {
				
				if (useInteractionManager) {
					callLater(richEditableText.textFlow.interactionManager.setFocus);
				}
				else {
					callLater(richEditableText.setFocus);
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function handleBulletClick(event:MouseEvent):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				var editManager:IEditManager = IEditManager(richEditableText.textFlow.interactionManager);
				var doCreate:Boolean = true;
				var selectionState:SelectionState = getBulletSelectionState();
				var listElements:Array = richEditableText.textFlow.getElementsByTypeName("list");
				var orderedButtonPressed:Boolean;
				var listStyleType:String;
				var listTypeChanged:Boolean;
				
				newFormat = new TextLayoutFormat();
				
				// use numbered list items
				if (event.currentTarget==orderedBulletTool) {
					orderedButtonPressed = true;
					newFormat.listStyleType = ListStyleType.DECIMAL;
				}
				
				for each (var listElement:ListElement in listElements) {
					var start:int = listElement.getAbsoluteStart();
					var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
					/*
					listStyleType = listElement.listStyleType;
					
					// ordered button was pressed and list style is not ordered - change to ordered and exit
					if (orderedButtonPressed && 
						(listElement.listStyleType==undefined || newFormat.listStyleType!=newFormat.listStyleType)) {
						listTypeChanged = true;
						
						if (listTypeChanged) {
							editManager.applyFormatToElement(listElement, newFormat);
							doCreate = false;
							continue;
						}
					}
					// list style is ordered and unordered button was pressed - change to unordered list and exit
					else if (!orderedButtonPressed && 
						(listElement.listStyleType==ListStyleType.DECIMAL)) {
						newFormat.listStyleType = ListStyleType.DISC;
						editManager.clearFormatOnElement(listElement, newFormat);
						doCreate = false;
						continue;
					}*/
					
					// Same
					if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end) {
						removeList(listElement);
						doCreate = false;
						break;
					}
					// Inside touching start (inside list at any position of first item?)
					else if (selectionState.absoluteStart == start && selectionState.absoluteEnd <= end) {
						
						selectionState = new SelectionState(richEditableText.textFlow, end, selectionState.absoluteEnd);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					// Inside touching end (inside list at last position of last item?)
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd == end) {
						selectionState = new SelectionState(richEditableText.textFlow, selectionState.absoluteStart, start);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					// Inside (inside list but not first item and not last item?)
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end) {
						var firstRange:SelectionState = new SelectionState(richEditableText.textFlow, selectionState.absoluteStart, start);
						var secondRange:SelectionState = new SelectionState(richEditableText.textFlow, end, selectionState.absoluteEnd);
						
						removeList(listElement);
						editManager.createList(null, null, firstRange);
						editManager.createList(null, null, secondRange);
						doCreate = false;
						break;
						
					}
					// Overlap. Include this list in the selection
					else if ((selectionState.absoluteStart >= start && selectionState.absoluteStart <= end) || (selectionState.absoluteEnd >= start && selectionState.absoluteEnd <= end)) {
						selectionState = new SelectionState(richEditableText.textFlow, Math.min(start, selectionState.absoluteStart), Math.max(end, selectionState.absoluteEnd));
						removeList(listElement);
					}
					// surround. Remove this list since it will get added back in, only expanded.
					else if (selectionState.absoluteStart <= start && selectionState.absoluteEnd >= end) {
						removeList(listElement);
					}
				}
				
				if (doCreate) {
					editManager.createList(null, newFormat, selectionState);
				}
				
				//richEditableText.textFlow.interactionManager.setFocus();
				setEditorFocus(true);
				
				updateEditor();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleColorChoose(event:Event):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			
			//format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			
			newFormat.color = colorTool.selectedColor;
			richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			richEditableText.setFocus();
			richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			setEditorFocus();
		}
		
		/**
		 *  @private
		 */
		private function handleFontChange(event:Event):void {
			var newFormat:TextLayoutFormat;
			var font:Font;
			var fontName:String;
			var selectedItem:Object;
			
			if (fontTool.selectedItem) {
				//format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				newFormat = new TextLayoutFormat();
				selectedItem = fontTool.selectedItem;
				newFormat.fontFamily = selectedItem is Font ? Font(selectedItem).fontName : selectedItem;
				richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				
				if (focusOnTextAfterFontChange) {
					richEditableText.setFocus();
				}
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				
				if (focusOnTextAfterFontChange) {
					setEditorFocus();
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function handleItalicClick(event:MouseEvent):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			currentFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			newFormat.fontStyle = (currentFormat.fontStyle == FontPosture.ITALIC) ? FontPosture.NORMAL : FontPosture.ITALIC;
			richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			richEditableText.setFocus();
			richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			setEditorFocus();
		}
		
		/**
		 *  @private
		 */
		private function handleKeyDown(event:KeyboardEvent):void {
			
			if (event.keyCode == Keyboard.ENTER || 
				event.keyCode == Keyboard.SPACE || 
				event.keyCode == Keyboard.TAB) {
				
				if (automaticallyAddLinks) {
					checkLinks();
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function handleLinkKeydown(e:KeyboardEvent):void {
			e.stopImmediatePropagation();
			
			if (e.keyCode == Keyboard.ENTER) {
				handleLinkUpdate();
				richEditableText.setFocus();
				setEditorFocus();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleImageKeydown(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
			
			if (event.keyCode == Keyboard.ENTER) {
				handleImageUpdate();
				richEditableText.setFocus();
				setEditorFocus();
			}
			
			showImageErrorIcon(false);
		}
		
		/**
		 * Handle image url entered into text field
		 */
		private function handleImageUpdate(event:Event = null):void {
			var imageSource:String;
			var imageFloat:String;
			var targetText:String;
			var inlineGraphicElement:InlineGraphicElement;
			
			imageSource = imageDetailsView.imageSource;
			imageFloat = imageDetailsView.floatValue;
			
			inlineGraphicElement = insertImage(imageSource, null, null, imageFloat);
			
			if (inlineGraphicElement) {
				imageDetailsView.imageSourceInput.text = "";
			}
			
			updateInlineGraphicElementPadding(inlineGraphicElement);
			//Set focus to textFlow
			//richEditableText.textFlow.interactionManager.setFocus();
			setEditorFocus(true);
		}
		
		public function updateInlineGraphicElementPadding(inlineGraphicElement:InlineGraphicElement):void {
			var absoluteStart:int;
			var textContainerManager:RichEditableTextContainerManager;
			var imageFloat:String;
			var newFormat:TextLayoutFormat;
			var editManager:IEditManager;
			var currentFormat:TextLayoutFormat;
			var hasChange:Boolean;
			
			textContainerManager = richEditableText.mx_internal::textContainerManager as RichEditableTextContainerManager;
			editManager = richEditableText.textFlow.interactionManager as IEditManager;
			imageFloat = inlineGraphicElement.float;
			absoluteStart = inlineGraphicElement.getAbsoluteStart();
			//currentFormat = inlineGraphicElement.format;
			currentFormat = new TextLayoutFormat();
			currentFormat.paddingLeft = 1;
			currentFormat.paddingRight = 1;
			
			if (imageFloat==Float.LEFT || imageFloat==Float.START) {
				newFormat = new TextLayoutFormat();
				hasChange = true;
				newFormat.paddingRight = 5;
				inlineGraphicElement.paddingRight = 5;
			}
			else if (imageFloat==Float.RIGHT || imageFloat==Float.END) {
				newFormat = new TextLayoutFormat();
				hasChange = true;
				newFormat.paddingLeft = 5;
				inlineGraphicElement.paddingLeft = 5;
			}
			else {
				editManager.clearFormat(currentFormat, null, null);
			}
			
			// i don't like that this causes two operations 
			if (hasChange) {
				editManager.clearFormat(currentFormat, null, null);
				textContainerManager.applyFormatOperation(newFormat, null, null, absoluteStart, absoluteStart+1);
			}
			
			//richEditableText.setFormatOfRange(newFormat, absoluteStart, absoluteStart+1);
			
		}
		
		/**
		 *  @private
		 *  Handle link set by applying the link to the selected text
		 */
		public function clearLinkUpdate(event:Event = null):void
		{
			linkDetailsView.selectedLink = "";
			clearLink();
			setEditorFocus(true);
		}
		
		/**
		 * Updates the editor formatting buttons and controls to reflect
		 * selected text or cursor position. 
		 * You usually call this if you make modifications to the text flow programmatically 
		 * */
		public function updateEditor():void {
			handleSelectionChange();
		}
		
		/**
		 *  @private
		 */
		private function handleSelectionChange(event:FlexEvent = null):void {
			var format:TextLayoutFormat;
			
			// we call get selection state and get range multiple times - refactor
			
			if (richEditableText != null) {
				
				format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				
				if (fontTool != null)
				{ 
					fontTool.selectedFontFamily = format.fontFamily;
				}
				
				if (fontSizeTool != null)
				{ 
					fontSizeTool.selectedFontSize = format.fontSize;
				}
				
				if (boldTool != null)
				{  
					boldTool.selectedFontWeight = format.fontWeight;
				}
				
				if (italicTool != null)
				{ 
					italicTool.selectedFontStyle = format.fontStyle;
				}
				
				if (underlineTool != null)
				{ 
					underlineTool.selectedTextDecoration = format.textDecoration;
				}
				
				if (colorTool != null)
				{ 
					colorTool.selectedTextColor = format.color;
				}
				
				if (alignTool != null)
				{ 
					alignTool.selectedTextAlign = format.textAlign;
				}
				
				// BULLET LIST
				
				if (bulletTool != null || orderedBulletTool!=null) {
					
					if (richEditableText.textFlow) {
						
						var willRemoveBulletsIfClicked:Boolean = false;
						var selectionState:SelectionState = getBulletSelectionState();
						var listElements:Array = richEditableText.textFlow.getElementsByTypeName("list");
						var orderedList:Boolean;
						
						for each (var listElement:ListElement in listElements) {
							var start:int = listElement.getAbsoluteStart();
							var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
							orderedList = listElement.listStyleType == ListStyleType.DECIMAL;
							
							// Same
							if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end) {
								willRemoveBulletsIfClicked = true;
								break;
							}
							// Inside
							else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end) {
								willRemoveBulletsIfClicked = true;
								break;
							}
						}
						
						if (bulletTool) {
							bulletTool.selected = willRemoveBulletsIfClicked && !orderedList;
						}
						
						if (orderedBulletTool) {
							orderedBulletTool.selected = willRemoveBulletsIfClicked && orderedList;
						}
						
					}
				}
				
				
				// HYPERLINK 
				
				var bulletSelectionState:SelectionState;
				var range:ElementRange;
				var linkString:String;
				var linkTargetString:String;
				var linkEnabled:Boolean;
				var linkElStart:int;
				var linkElEnd:int;
				var tempLink:int;
				var beginRange:int;
				var endRange:int;
				var beginPara:ParagraphElement;
				var newLinkSelected:Boolean;
				
				if (linkDetailsView != null) {
					
					bulletSelectionState = richEditableText.textFlow.interactionManager.getSelectionState();
					
					if (bulletSelectionState.absoluteStart != -1 && bulletSelectionState.absoluteEnd != -1) {
						
						range = ElementRange.createElementRange(bulletSelectionState.textFlow, bulletSelectionState.absoluteStart, bulletSelectionState.absoluteEnd);
						
						if (range) {
							
							linkString = defaultLinkText;
							_linkElement = range.firstLeaf.getParentByType(LinkElement) as LinkElement;
							
							if (_linkElement != null) {
								linkElStart = _linkElement.getAbsoluteStart();
								linkElEnd = linkElStart + _linkElement.textLength;
								
								if (linkElEnd < linkElStart) {
									tempLink = linkElStart;
									linkElStart = linkElEnd;
									linkElEnd = tempLink;
								}
								
								beginRange = range.absoluteStart;
								endRange = range.absoluteEnd;
								
								beginPara = range.firstParagraph;
								
								if (endRange == (beginPara.getAbsoluteStart() + beginPara.textLength)) {
									endRange--;
								}
								
								if ((beginRange == endRange) || (endRange <= linkElEnd)) {
									linkString = LinkElement(_linkElement).href;
									linkTargetString = LinkElement(_linkElement).target;
								}
							}
							
							
							newLinkSelected = _linkElement != null;
							
							if (_linkSelected != newLinkSelected) {
								_linkSelected = newLinkSelected;
								dispatchEvent(new Event(LINK_SELECTED_CHANGE));
							}
							
							linkDetailsView.selectedLink = linkString;
							linkDetailsView.selectedTarget = linkTargetString;
							
							_lastRange = range;
						}
						else {
							_lastRange = null;
						}
					}
					
					linkEnabled = richEditableText.selectionAnchorPosition != richEditableText.selectionActivePosition || _linkSelected;
					linkDetailsView.textDisplay.enabled = linkEnabled;
					linkDetailsView.targetLocations.enabled = linkEnabled;
				}
				
				
				// INLINE GRAPHIC ELEMENT - IMAGE
				
				if (imageDetailsView != null) {
					var singleItemSelected:Boolean;
					var startPosition:int;
					var inlineGraphicElement:InlineGraphicElement;
					var flowElement:FlowElement;
					var inlineGraphicElementSelected:Boolean;
					
					singleItemSelected = Math.abs(richEditableText.selectionAnchorPosition - richEditableText.selectionActivePosition)==1;
					
					if (singleItemSelected) {
						selectionState = richEditableText.textFlow.interactionManager.getSelectionState();
						range = ElementRange.createElementRange(selectionState.textFlow, selectionState.absoluteStart, selectionState.absoluteEnd);
						inlineGraphicElement = range.firstLeaf as InlineGraphicElement;
						
						if (inlineGraphicElement) {
							imageDetailsView.imageSource = inlineGraphicElement.source as String;
							imageDetailsView.floatValue = inlineGraphicElement.float;
							inlineGraphicElementSelected = true;
						}
					}
					
					if (!inlineGraphicElementSelected) {
						imageDetailsView.imageSource = "";
						imageDetailsView.floatValue = "none";
					}
					
				}
			}
		}
		
		/*
		When applying a size that is NaN an error is thrown. For example, value 12..2 throws an error.
		
		RangeError: Property fontSize value NaN is out of range
			at flashx.textLayout.property::Property$/defaultErrorHandler()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/property/Property.as:39]
			at flashx.textLayout.property::Property/setHelper()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/property/Property.as:238]
			at flashx.textLayout.formats::TextLayoutFormat/setStyleByProperty()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/formats/TextLayoutFormat.as:1333]
			at flashx.textLayout.formats::TextLayoutFormat/set fontSize()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/formats/TextLayoutFormat.as:1821]
			at com.flexcapacitor.controls::RichTextEditorBar/handleSizeChange()[/Users/monkeypunch/Documents/ProjectsGithub/flexcapacitor/MainLibrary/src/com/flexcapacitor/controls/RichTextEditorBar.as:1239]
		*/
		
		/**
		 *  @private
		 */
		private function handleSizeChange(e:Event):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			
			if (fontSizeTool.selectedItem) {
				var newFontSize:Number = fontSizeTool.selectedItem;
				
				// ensure font size is valid
				if (isNaN(newFontSize)) {
					newFontSize = parseFloat(fontSizeTool.selectedItem);
					
					if (isNaN(newFontSize)) {
						newFontSize = 12; // should we abort if not valid or throw error
					}
				}
				
				newFormat.fontSize = Math.max(1, Math.min(newFontSize, 720));
				IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(newFormat);
				
				if (focusOnTextAfterFontSizeChange) {
					richEditableText.setFocus();
				}
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				if (focusOnTextAfterFontSizeChange) {
					setEditorFocus();
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function handleUnderlineClick(e:MouseEvent):void {
			var newFormat:TextLayoutFormat;
			var currentFormat:TextLayoutFormat;
			
			newFormat = new TextLayoutFormat();
			
			currentFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			newFormat.textDecoration = (currentFormat.textDecoration == TextDecoration.UNDERLINE) ? TextDecoration.NONE : TextDecoration.UNDERLINE;
			richEditableText.setFormatOfRange(newFormat, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			richEditableText.setFocus();
			richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			setEditorFocus();
		}

		/**
		 *  @private
		 */
		private function handleChange(e:Event):void
		{
			_htmlTextChanged = true;
			this.dispatchEvent(e);
		}
		
		/**
		 *  @private
		 */
		private function removeList(listElement:ListElement):void
		{
			var editManager:IEditManager = IEditManager(richEditableText.textFlow.interactionManager);
			
			var target:FlowGroupElement = listElement.parent;
			var targetIndex:int = target.getChildIndex(listElement);
			editManager.moveChildren(listElement, 0, listElement.numChildren, target, targetIndex);
		}
		
		/**
		 *  @private
		 *  Return true if the character is a whitespace character
		 */
		private function isWhitespace(charCode:uint):Boolean
		{
			return charCode === 0x0009 || charCode === 0x000A || charCode === 0x000B || charCode === 0x000C || charCode === 0x000D || charCode === 0x0020 || charCode === 0x0085 || charCode === 0x00A0 || charCode === 0x1680 || charCode === 0x180E || charCode === 0x2000 || charCode === 0x2001 || charCode === 0x2002 || charCode === 0x2003 || charCode === 0x2004 || charCode === 0x2005 || charCode === 0x2006 || charCode === 0x2007 || charCode === 0x2008 || charCode === 0x2009 || charCode === 0x200A || charCode === 0x2028 || charCode === 0x2029 || charCode === 0x202F || charCode === 0x205F || charCode === 0x3000;
		}
		
		
		/*
		when applying a bullet point and then clicking undo and then redo it causes this error:
		
		steps
		1. select text
		2. click bullet list button
		3. press keyboard for undo (CMD+Z)
		4. press keyboard for redo (CMD+Y) - error occurs
		
		workaround:
		- add an event listener to the textflow for a FlowOperationEvent.END event 
		and check the event.error property. if it's not null use event.preventDefault() 
		to prevent an error from being thrown.
		
		TypeError: Error #1009: Cannot access a property or method of a null object reference.
		at flashx.textLayout.edit::SelectionManager/setSelectionState()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/edit/SelectionManager.as:552]
		at flashx.textLayout.edit::EditManager/performRedo()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/edit/EditManager.as:1081]
		at flashx.textLayout.operations::FlowOperation/performRedo()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/operations/FlowOperation.as:211]
		at flashx.undo::UndoManager/redo()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/undo/UndoManager.as:223]
		at flashx.textLayout.edit::EditManager/redo()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/edit/EditManager.as:1039]
		at flashx.textLayout.edit::EditManager/keyDownHandler()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/edit/EditManager.as:322]
		at flashx.textLayout.container::ContainerController/keyDownHandler()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/container/ContainerController.as:2555]
		at flashx.textLayout.container::TextContainerManager/keyDownHandler()[/Users/justinmclean/Documents/ApacheFlexTLFGit/textLayout/src/flashx/textLayout/container/TextContainerManager.as:1889]
		at spark.components.supportClasses::RichEditableTextContainerManager/keyDownHandler()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/spark/src/spark/components/supportClasses/RichEditableTextContainerManager.as:665]
		*/
		
		/**
		 * Handles errors when user is editing content and encounters an error.
		 * */
		protected function flowOperationHandler(event:FlowOperationEvent):void
		{
			// when undo and redoing a bullet list an error occurs as shown in the comment above
			// adding an event listener prevents this
			var operation:String = Object(event.operation).toString();
			var target:String = Object(event.target).toString();
			
			if (event.target) {
				
			}
			
			// if we have an error this will not be null
			if (event.error) {
				// call prevent to prevent a runtime error
				event.preventDefault();
				
				//trace("FLOW OPERATION ERROR OCCURRED on " + operation + " on " + target);
			}
		}
		
		
		/**
		 * Called when the TextContainerManager dispatches an 'operationComplete' 
		 * event after an editing operation. 
		 * This is useful for seeing the history of operations on a text flow
		 * and for debugging purposes. 
		 */
		public function flowOperationCompleteHandler(event:FlowOperationEvent):void {
			//trace("flowOperationComplete", "level", event.level);
			
			// Dispatch a 'change' event from the RichEditableText
			// as notification that an editing operation has occurred.
			// The flow is now in a state that it can be manipulated.
			// The level will be 0 for single operations, and at the end
			// of a composite operation.
			/*if (dispatchChangeAndChangingEvents && event.level == 0) {
				var newEvent:TextOperationEvent =
				new TextOperationEvent(TextOperationEvent.CHANGE);
				newEvent.operation = event.operation;
				dispatchEvent(newEvent);
			}*/
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			
			if (event.operation is ApplyFormatOperation) {
				//enterDebugger();
			}
		}
		
		public function returnToDefaultState():void
		{
			var playAnimation:Boolean = true;
			
			if (skin && skin.currentState!=NORMAL_VIEW) {
				deselectToggles();
				skin.setCurrentState(NORMAL_VIEW, playAnimation);
			}
		}
		
		[Embed(source="../skins/richTextEditorClasses/icons/PointingHand.png")]
		public static const PointerHand:Class;
		public var useCursorManager:Boolean = true;
		private var currentCursorIndex:int;
		public var cursorManagerX:int = -6;
		public var cursorManagerY:int = 0;
		
		protected function cursorObject_mouseMove(event:MouseEvent):void {
			
			//trace("\n"+event.type);
			
			if (useCursorManager) {
				// when using flex cursor manager the cursor is updated
				// at the framerate of the application. this makes it look 
				// sluggish. calling updateAfterEvent forces a redraw
				event.updateAfterEvent();
			}
			
		}
		
		protected function cursorObject_rollOver(event:Event):void
		{
			
			//trace("\n"+event.type);
			
			if (useCursorManager) {
				//trace("using flex cursor manager");
				currentCursorIndex = cursorManager.setCursor(PointerHand, 2, cursorManagerX, cursorManagerY);
			}
			
			//Mouse.cursor = MouseCursor.AUTO;
			//cursorManager.setBusyCursor();
		}
		
		protected function cursorObject_rollOut(event:MouseEvent):void
		{
			//trace(event.type);
			removeCustomCursor();
		}
		
		public function removeCustomCursor():void {
			
			if (useCursorManager) {
				//trace("removing flex cursor " + currentCursorIndex);
				cursorManager.removeCursor(currentCursorIndex);
				cursorManager.removeAllCursors();
			}
		}
	}
}
