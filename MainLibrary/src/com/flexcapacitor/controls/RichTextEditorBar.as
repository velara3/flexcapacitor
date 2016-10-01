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
	import com.flexcapacitor.controls.richTextEditorClasses.FontTool;
	import com.flexcapacitor.controls.richTextEditorClasses.ItalicTool;
	import com.flexcapacitor.controls.richTextEditorClasses.LinkButtonTool;
	import com.flexcapacitor.controls.richTextEditorClasses.LinkTool;
	import com.flexcapacitor.controls.richTextEditorClasses.SizeTool;
	import com.flexcapacitor.controls.richTextEditorClasses.UnderlineTool;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.RichEditableText;
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
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.FlowOperationEvent;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.ApplyFormatOperation;

	use namespace mx_internal;
	
	// for asdoc
	[Event(name = "change", type = "mx.events.FlexEvent")]
	[Event(name = LINK_SELECTED_CHANGE, type = "flash.events.Event")]
	
	[Style(name = "borderColor", inherit = "no", type = "unit")]
	[Style(name = "focusColor", inherit = "yes", type = "unit")]
	
	public class RichTextEditorBar extends SkinnableComponent {
		
		public function RichTextEditorBar() {
			super();
			
			this.textFlow = new TextFlow(); //Prevents a stack trace that happends when you try to access the textflow on click.
		}
		
		public const LINK_SELECTED_CHANGE:String = "linkSelectedChange";
		
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
		public var sizeTool:SizeTool;
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
		public var linkTool:LinkTool;
		[SkinPart(required="false")]
		public var showLinkTool:LinkButtonTool;
		[SkinPart(required="false")]
		public var linkDialog:LinkTool;
		[SkinPart(required="false")]
		public var clearFormattingTool:ClearFormattingTool;
		
		/**
		 * Set this to true to set focus on rich text editor on the next frame.
		 * This helps solve an issue to maintain focus on the rich text field 
		 * when the editor bar is in a pop up.  
		 * */
		public var setFocusLater:Boolean = true;
		
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
				fontTool.toolTip = "Font Family";
			}
			
			if (instance == sizeTool)
			{
				sizeTool.addEventListener(IndexChangeEvent.CHANGE, handleSizeChange, false, 0, true);
				sizeTool.toolTip = "Font Size";
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
			
			if (instance == linkTool) {
				linkTool.textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown, false, 0, true);
				linkTool.textDisplay.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate, false, 0, true);
				linkTool.textDisplay.addEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput, false, 0, true);
				linkTool.textDisplay.addEventListener(ClearButtonTextInput.CLEAR_TEXT, clearLinkUpdate, false, 0, true);
				
				linkTool.targetLocations.addEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput, false, 0, true);
				linkTool.targetLocations.addEventListener(Event.CHANGE, handleLinkTargetChange, false, 0, true);
			}
			
			if (instance == clearFormattingTool) {
				clearFormattingTool.addEventListener(MouseEvent.CLICK, handleClearFormattingClick, false, 0, true);
				clearFormattingTool.toolTip = "Clear Common Formatting";
			}
			
			if (instance == showLinkTool) {
				showLinkTool.addEventListener(MouseEvent.CLICK, showLinkDialogClick, false, 0, true);
				showLinkTool.toolTip = "Show Link";
			}
			
			handleSelectionChange();
		}
		
		protected function handleLinkTargetChange(event:IndexChangeEvent):void {
			var linkElement:LinkElement;
			var selectionStart:int;
			var selectionEnd:int;
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager) {
				selectionStart = Math.min(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				selectionEnd = Math.max(richEditableText.selectionActivePosition, richEditableText.selectionAnchorPosition);
				
				linkElement = getLinkElementFromRange(richEditableText.textFlow, selectionStart, selectionEnd);
				
				if (linkElement) {
					linkElement.target = linkTool.targetLocations.selectedItem;
				}
			}
		}
		
		protected function showLinkDialogClick(event:MouseEvent):void {
			var linkVisible:Boolean;
			
			if (skin.currentState=="normal") {
				skin.currentState = "linkDialog";
				
				/*
				linkVisible = linkDialog.visible;
				
				linkDialog.visible = !linkVisible;
				linkDialog.includeInLayout = !linkVisible;*/
			}
			else {
				skin.currentState = "normal";
			}
		}
		
		/**
		 *  @private
		 */
		protected override function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == richEditableText) {
				removeTextArea(instance);
			}
			
			if (instance == fontTool) {
				fontTool.removeEventListener(IndexChangeEvent.CHANGE, handleFontChange);
			}
			
			if (instance == sizeTool) {
				sizeTool.removeEventListener(IndexChangeEvent.CHANGE, handleSizeChange);
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
			
			if (instance == linkTool) {
				linkTool.textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown);
				linkTool.textDisplay.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate);
				linkTool.textDisplay.removeEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput);
				linkTool.textDisplay.removeEventListener(ClearButtonTextInput.CLEAR_TEXT, clearLinkUpdate);
				
				linkTool.targetLocations.removeEventListener(FocusEvent.FOCUS_IN, handleFocusInLinkTextInput);
				linkTool.targetLocations.removeEventListener(Event.CHANGE, handleLinkTargetChange);
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
				
				linkElement = getLinkElementFromRange(richEditableText.textFlow, selectionStart, selectionEnd);
				
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
		
		/**
		 * Gets the parent LinkElement of a span or null if parent is not a link element
		 * */
		public static function getLinkElementFromRange(textFlow:TextFlow, selectionStart:int, selectionEnd:int):LinkElement {
			var startElement:SpanElement;
			var endElement:SpanElement;
			var startLinkElement:LinkElement;
			var endLinkElement:LinkElement;
			var noSelection:Boolean = selectionStart==selectionEnd;
			
			if (textFlow==null) {
				return null;
			}
			
			startElement = textFlow.findLeaf(selectionStart) as SpanElement;
			startLinkElement = startElement ? startElement.parent as LinkElement : null;
			
			// if there is no selection but cursor is in an element that has a parent link element
			// return that link element
			if (startLinkElement && noSelection) {
				return startLinkElement;
			}
			
			endElement = textFlow.findLeaf(selectionEnd-1) as SpanElement;
			endLinkElement = endElement ? endElement.parent as LinkElement : null;
			
			// if we have a selection with two different links then return null
			if (startLinkElement!=endLinkElement) {
				return null;
			}
			
			// user selected full link
			if (startLinkElement==endLinkElement) {
				return startLinkElement;
			}
			
			return null;
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
			instance.clearUndoOnFocusOut = false;
			
			instance.addEventListener(TextOperationEvent.CHANGE, handleChange, false, 0, true);
			instance.addEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange, false, 0, true);
			instance.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
			instance.addEventListener(MouseEvent.CLICK, richEditableText_clickHandler, false, 0, true);
			instance.addEventListener(FlowOperationEvent.FLOW_OPERATION_END, flowOperationHandler, false, 0, true);
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
				
				linkElement = getLinkElementFromRange(richEditableText.textFlow, selectionStart, selectionEnd);
				
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
		private function getBulletSelectionState():SelectionState
		{
			if (richEditableText.textFlow)
			{
				var selectionManager:ISelectionManager = richEditableText.textFlow.interactionManager;
				var selectionState:SelectionState = selectionManager.getSelectionState();
				var startleaf:FlowLeafElement = richEditableText.textFlow.findLeaf(selectionState.absoluteStart);
				var endleaf:FlowLeafElement = richEditableText.textFlow.findLeaf(selectionState.absoluteEnd);
				if (startleaf != null)
				{
					selectionState.absoluteStart = startleaf.getAbsoluteStart();
				}
				if (endleaf != null)
				{
					selectionState.absoluteEnd = endleaf.getAbsoluteStart() + endleaf.parentRelativeEnd - endleaf.parentRelativeStart;
				}
				return selectionState;
			}
			return null;
		}
		
		/**
		 *  @private
		 */
		private function handleAlignChange(e:Event):void
		{
			if (alignTool.selectedItem)
			{
				var txtLayFmt:TextLayoutFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				txtLayFmt.textAlign = alignTool.selectedItem.value;
				richEditableText.setFormatOfRange(txtLayFmt, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				richEditableText.setFocus();
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				setEditorFocus();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleBoldClick(e:MouseEvent):void
		{
			var format:TextLayoutFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			format.fontWeight = (format.fontWeight == FontWeight.BOLD) ? FontWeight.NORMAL : FontWeight.BOLD;
			richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
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
		private function handleBulletClick(e:MouseEvent):void {
			
			if (richEditableText.textFlow && richEditableText.textFlow.interactionManager is IEditManager)
			{
				var editManager:IEditManager = IEditManager(richEditableText.textFlow.interactionManager);
				var doCreate:Boolean = true;
				var selectionState:SelectionState = getBulletSelectionState();
				var listElements:Array = richEditableText.textFlow.getElementsByTypeName("list");
				
				for each (var listElement:ListElement in listElements)
				{
					var start:int = listElement.getAbsoluteStart();
					var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
					
					if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end)
					{ //Same
						removeList(listElement);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart == start && selectionState.absoluteEnd <= end)
					{ //Inside touching start
						selectionState = new SelectionState(richEditableText.textFlow, end, selectionState.absoluteEnd);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd == end)
					{ //Inside touching end
						selectionState = new SelectionState(richEditableText.textFlow, selectionState.absoluteStart, start);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end)
					{ //Inside
						var firstRange:SelectionState = new SelectionState(richEditableText.textFlow, selectionState.absoluteStart, start);
						var secondRange:SelectionState = new SelectionState(richEditableText.textFlow, end, selectionState.absoluteEnd);
						removeList(listElement);
						editManager.createList(null, null, firstRange);
						editManager.createList(null, null, secondRange);
						doCreate = false;
						break;
					}
					else if ((selectionState.absoluteStart >= start && selectionState.absoluteStart <= end) || (selectionState.absoluteEnd >= start && selectionState.absoluteEnd <= end))
					{ //Overlap. Include this list in the selection
						selectionState = new SelectionState(richEditableText.textFlow, Math.min(start, selectionState.absoluteStart), Math.max(end, selectionState.absoluteEnd));
						removeList(listElement);
					}
					else if (selectionState.absoluteStart <= start && selectionState.absoluteEnd >= end)
					{ //surround. Remove this list since it will get added back in, only expanded.
						removeList(listElement);
					}
				}
				
				if (doCreate) {
					IEditManager(richEditableText.textFlow.interactionManager).createList(null, null, selectionState);
				}
				
				richEditableText.textFlow.interactionManager.setFocus();
				setEditorFocus(true);
			}
		}
		
		/**
		 *  @private
		 */
		private function handleColorChoose(event:ColorChangeEvent):void {
			var format:TextLayoutFormat;
			
			format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			format.color = event.color
			richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			richEditableText.setFocus();
			richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			setEditorFocus();
		}
		
		/**
		 *  @private
		 */
		private function handleFontChange(event:Event):void {
			var format:TextLayoutFormat;
			
			if (fontTool.selectedItem) {
				format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				format.fontFamily = fontTool.selectedItem;
				richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				richEditableText.setFocus();
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				setEditorFocus();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleItalicClick(event:MouseEvent):void {
			var format:TextLayoutFormat;
			
			format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			format.fontStyle = (format.fontStyle == FontPosture.ITALIC) ? FontPosture.NORMAL : FontPosture.ITALIC;
			richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
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
		 *  Handle link set by applying the link to the selected text
		 */
		private function handleLinkUpdate(e:Event = null):void {
			var urlText:String;
			var targetText:String;
			
			urlText = linkTool.selectedLink == defaultLinkText ? '' : linkTool.selectedLink;
			targetText = linkTool.selectedTarget !="" ? linkTool.selectedTarget : "_blank";
			applyLink(urlText, targetText, true);
			
			//Set focus to textFlow
			//richEditableText.textFlow.interactionManager.setFocus();
			setEditorFocus(true);
		}
		
		/**
		 *  @private
		 *  Handle link set by applying the link to the selected text
		 */
		public function clearLinkUpdate(e:Event = null):void
		{
			linkTool.selectedLink = "";
			clearLink();
			setEditorFocus(true);
		}
		
		/**
		 *  @private
		 */
		private function handleSelectionChange(e:FlexEvent = null):void {
			var format:TextLayoutFormat;
			
			if (richEditableText != null) {
				
				format = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				
				if (fontTool != null)
				{ 
					fontTool.selectedFontFamily = format.fontFamily;
				}
				if (sizeTool != null)
				{ 
					sizeTool.selectedFontSize = format.fontSize;
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
				
				if (bulletTool != null)
				{ 
					if (richEditableText.textFlow)
					{
						var willRemoveBulletsIfClicked:Boolean = false;
						var selectionState:SelectionState = getBulletSelectionState();
						var listElements:Array = richEditableText.textFlow.getElementsByTypeName("list");
						
						for each (var listElement:ListElement in listElements)
						{
							var start:int = listElement.getAbsoluteStart();
							var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
							if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end)
							{ //Same
								willRemoveBulletsIfClicked = true;
								break;
							}
							else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end)
							{ //Inside
								willRemoveBulletsIfClicked = true;
								break;
							}
						}
						
						bulletTool.selected = willRemoveBulletsIfClicked;
						
					}
				} 
				
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
				
				if (linkTool != null) { 
					
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
							
							linkTool.selectedLink = linkString;
							linkTool.selectedTarget = linkTargetString;
							
							_lastRange = range;
						}
						else {
							_lastRange = null;
						}
					}
					
					linkEnabled = richEditableText.selectionAnchorPosition != richEditableText.selectionActivePosition || _linkSelected;
					linkTool.textDisplay.enabled = linkEnabled;
					linkTool.targetLocations.enabled = linkEnabled;
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function handleSizeChange(e:Event):void
		{
			if (sizeTool.selectedItem)
			{
				/*var format:TextLayoutFormat = richEditableText.getFormatOfRange(fontSizeVector, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				format.fontSize = sizeTool.selectedItem;
				richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
				*/
				var newFontSize:Number = sizeTool.selectedItem;
				var cf:TextLayoutFormat = new TextLayoutFormat();
				cf.fontSize = newFontSize;
				IEditManager(richEditableText.textFlow.interactionManager).applyLeafFormat(cf);
				
				richEditableText.setFocus();
				richEditableText.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
				setEditorFocus();
			}
		}
		
		/**
		 *  @private
		 */
		private function handleUnderlineClick(e:MouseEvent):void
		{
			var format:TextLayoutFormat = richEditableText.getFormatOfRange(null, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
			format.textDecoration = (format.textDecoration == TextDecoration.UNDERLINE) ? TextDecoration.NONE : TextDecoration.UNDERLINE;
			richEditableText.setFormatOfRange(format, richEditableText.selectionAnchorPosition, richEditableText.selectionActivePosition);
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
				
				trace("FLOW OPERATION ERROR OCCURRED on " + operation + " on " + target);
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
			
			//console.appendText(event.level + ": " + event.operation + "\n");
			if (event.operation is ApplyFormatOperation) {
				//enterDebugger();
			}
		}
	}
}
