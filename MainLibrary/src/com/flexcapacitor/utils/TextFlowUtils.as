package com.flexcapacitor.utils
{
	
	import avmplus.getQualifiedClassName;
	
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Category;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.property.Property;

	use namespace tlf_internal;
	
	public class TextFlowUtils
	{
		public function TextFlowUtils()
		{
			
		}
		
		/**
		 * Contains last error from some calls
		 **/
		public static var error:Error;
		
		/**
		 * Gets an inline graphic element at the position provided or null if not found
		 * */
		public static function getInlineGraphicImageFromPosition(textFlow:TextFlow, selectionStart:int, selectionEnd:int):InlineGraphicElement {
			var singleItemSelected:Boolean;
			var startPosition:int;
			var inlineGraphicElement:InlineGraphicElement;
			var flowElement:FlowElement;
			var inlineGraphicElementSelected:Boolean;
			var selectionState:SelectionState;
			var elementRange:ElementRange;
			
			singleItemSelected = Math.abs(selectionStart - selectionEnd)==1;
			
			if (singleItemSelected) {
				selectionState = textFlow.interactionManager.getSelectionState();
				elementRange = ElementRange.createElementRange(textFlow, selectionState.absoluteStart, selectionState.absoluteEnd);
				inlineGraphicElement = elementRange.firstLeaf as InlineGraphicElement;
			}
			
			return inlineGraphicElement;
		}
		
		/**
		 * Gets a LinkElement at the cursor position if no selection or null selected range do not 
		 * containa a link element
		 * */
		public static function getLinkElementFromPosition(textFlow:TextFlow, selectionStart:int, selectionEnd:int):LinkElement {
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
		
		
		/**
		 * Gets an array of elements and ancestors from the cursor position 
		 * */
		public static function getHierarchyFromPosition(textFlow:TextFlow, selectionStart:int, reverse:Boolean = false):Array {
			var element:FlowElement = textFlow.findLeaf(selectionStart);
			var elements:Array = [];
			
			while (element) {
				elements.push(element);
				element = element.parent;
			}
			
			reverse ? elements.reverse() : 0;
			
			return elements;
		}
		
		public static function getElementPath(element:FlowElement):String {
			var result:String;
			
			if (element != null) {
				if (element.parent != null) {
					result = getElementPath(element.parent) + "." + Object(element).className + "[" + element.parent.getChildIndex(element) + "]";
				}
				else {
					result = Object(element).className;
				}
			}
			return result;
		}
		
		/**
		 * Gets the beginning position of the text flow. Gets the earliest position 
		 * whether it is the active position or anchor position.
		 * Returns -1 if there is no selection manager 
		 * */
		public static function getSelectionBeginPosition(textFlow:TextFlow):int {
			var selectionManager:ISelectionManager = textFlow.interactionManager as ISelectionManager;
			
			if (selectionManager) {
				return selectionManager.absoluteStart;
			}
			
			return -1;
		}
		
		/**
		 * Gets an array of elements by type
		 * */
		public static function getElementsByType(textFlow:TextFlow, type:Object):Array {
			var elementRange:ElementRange;
			var leaf:FlowLeafElement;
			var isString:Boolean = type is String;
			var typeName:String = type as String;
			var elements:Array = [];
			var pathName:String;
			var absoluteEnd:int;
			
			if (isString) {
				elements = textFlow.getElementsByTypeName(typeName);
				return elements;
			}
			
			try {
				absoluteEnd = Math.max(textFlow.textLength, textFlow.interactionManager.absoluteEnd); 
				elementRange = ElementRange.createElementRange(textFlow, 0, absoluteEnd);
				leaf = elementRange ? elementRange.firstLeaf : null;
			}
			catch(error:Error) {
				return [];
			}
			
			
			for (;;) {
				
				if (isString) {
					if ("defaultTypeName" in leaf && leaf.defaultTypeName==typeName) {
						elements.push(leaf);
					}
					else if ("typeName" in leaf && leaf.typeName==typeName) {
						elements.push(leaf);
					}
					else {
						pathName = getQualifiedClassName(leaf);
						pathName = pathName.indexOf("::")!=-1 ? pathName.split("::")[1]:pathName;
						if (pathName==typeName) {
							elements.push(leaf);
						}
					}
				}
				else if (leaf is (type as Class)) {
					elements.push(leaf);
				}
			
				if (leaf == elementRange.lastLeaf) {
					break;
				}
				
				leaf = leaf.getNextLeaf();
			}
			
			return elements;
		}
		
		/**
		 * Gets the name of the element. For a paragraph will return "p" or "ParagraphElement"
		 * depending if the short name is set to true or false
		 * */
		public static function getElementName(element:FlowElement, short:Boolean = true, defaultTypeName:Boolean = true):String {
			var path:String;
			
			if (short) {
				// ReferenceError: Error #1069: 
				// Property http://www.adobe.com/2006/flex/mx/internal::defaultTypeName not found on flashx.textLayout.elements.TextFlow and there is no default value.
				//path = element.mx_internal::defaultTypeName;
				
				// TypeError: Error #1034: 
				// Type Coercion failed: cannot convert flashx.textLayout.elements::TextFlow@2582221335f1 to Namespace.
				//path = element::mx_internal.defaultTypeName;
				
				// a span element had a type of "a"
				// so using default type name??
				// path = element.typeName;
				if (defaultTypeName) {
					path = element.defaultTypeName;
				}
				else {
					path = element.typeName;
				}
			}
			else {
				path = getQualifiedClassName(element);
				path = path.indexOf("::")!=-1 ? path.split("::")[1]:path;
			}
			
			return path;
		}
		
		/**
		 * Select element
		 * */
		public static function selectElement(element:FlowElement):void {
			var textFlow:TextFlow = element.getTextFlow();
			var selection:SelectionState = ISelectionManager(textFlow.interactionManager).getSelectionState();
			var startIndex:int = element.getAbsoluteStart();
			selection.updateRange(startIndex, startIndex + element.textLength);
			IEditManager(textFlow.interactionManager).setSelectionState(selection);
			textFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * Get format of element range
		 **/
		public static function getElementRangeFormat(elementRange:ElementRange):TextLayoutFormat {		
			var leaf:FlowLeafElement = elementRange.firstLeaf;
			var attr:TextLayoutFormat = new TextLayoutFormat(leaf.computedFormat);
			
			// found method: 
			// RichEditableText.getFormatOfRange();
			
			for (;;)
			{
				if (leaf == elementRange.lastLeaf)
					break;
				leaf = leaf.getNextLeaf();
				attr.concatInheritOnly(leaf.computedFormat);
			}
			
			return Property.extractInCategory(TextLayoutFormat, TextLayoutFormat.description, attr, Category.CHARACTER, false) as TextLayoutFormat;
		}
		
		/**
		 * Get format of current selection from TextFlow
		 **/
		public static function getFormatOfSelection(textFlow:TextFlow):TextLayoutFormat {
			var selectionManager:ISelectionManager = textFlow.interactionManager;
			var selectionStart:int = Math.min(selectionManager.absoluteStart, selectionManager.absoluteEnd);
			var selectionEnd:int = Math.max(selectionManager.absoluteEnd, selectionManager.absoluteEnd);
			var elementRange:ElementRange = ElementRange.createElementRange(textFlow, selectionStart, selectionEnd);
			var format:TextLayoutFormat = getElementRangeFormat(elementRange);
			
			return format;
		}
		
		/**
		 * Get string value of a TextFlow
		 **/
		public static function getTextFlowString(value:TextFlow):String {
			return TextConverter.export(value, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE) as String;
		}
		
		
		/**
		 * Get a TextFlow from a string value
		 **/
		public static function getTextFlowFromString(value:String):TextFlow {
			var flow:TextFlow;
			error = null;
			
			// TODO: test performance of below if deep copy is faster and works reliably
			try {
				flow = TextConverter.importToFlow(value, TextConverter.TEXT_LAYOUT_FORMAT);
			}
			catch (e:Error) {
				error = e;
			}
			
			return flow;
		}
		
		/**
		 * Clone a textflow 
		 **/
		public static function cloneTextFlow(textFlow:TextFlow, useDeepCopy:Boolean = false):TextFlow {
			var string:String;
			var flow:TextFlow;
			error = null;
			
			try {
				string = getTextFlowString(textFlow);
				flow = getTextFlowFromString(string);
			}
			catch (e:Error) {
				error = e;
			}
			
			return flow;
		}
	}
}