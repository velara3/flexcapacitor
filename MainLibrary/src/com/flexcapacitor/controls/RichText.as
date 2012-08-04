package com.flexcapacitor.controls
{
	import com.flexcapacitor.formatters.HTMLFormatterTLF;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import spark.components.RichEditableText;
	
	/**
	 * Extends Rich Editable Text with:<br/><br/>
	 * 
	 * Turns off editing<br/>
	 * Disables tab focus. <br/>
	 * Keeps selection of text.  <br/>
	 * Supports HTML text.<br/>
	 * Replaces linebreaks correctly.<br/><br/>
	 * 
	 * @copy spark.components.RichEditableText
	 * */
	public class RichText extends spark.components.RichEditableText {
		
		
		public function RichText() {
			super();
			editable = false;
			selectable = true;
			tabFocusEnabled = false;
		}
		
		private	var selectableChanged:Boolean;
		private var htmlTextChanged:Boolean;
		private var _htmlText:String;

		public function get htmlText():String {
			return _htmlText;
		}

		public function set htmlText(value:String):void {
			_htmlText = value;
			htmlTextChanged = true;
			invalidateProperties();
		}

		public var computedHTMLText:String;
		public var translatedHTMLText:String;
		public var computedTextFlow:TextFlow;
		
		private var _selectable:Boolean;

		/*public function get selectableText():Boolean
		{
			return _selectable;
		}

		public function set selectableText(value:Boolean):void
		{
			_selectable = value;
			selectableChanged = true;
			invalidateProperties();
		}*/
		
		private var _replaceLinebreaksWithBreaks:Boolean;

		public function get replaceLinebreaksWithBreaks():Boolean {
			return _replaceLinebreaksWithBreaks;
		}

		public function set replaceLinebreaksWithBreaks(value:Boolean):void {
			_replaceLinebreaksWithBreaks = value;
			HTMLFormatterTLF.staticInstance.replaceLinebreaks = value;
		}

		
		override protected function commitProperties():void {
			
			if (htmlTextChanged) {
				translatedHTMLText = HTMLFormatterTLF.staticInstance.format(htmlText);
				textFlow = TextConverter.importToFlow(translatedHTMLText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			}
			
			super.commitProperties();
			
			/*if (htmlTextChanged) {
				
				translatedHTMLText = HTMLFormatterTLF.staticInstance.format(htmlText);
				computedTextFlow = TextConverter.importToFlow(translatedHTMLText, TextConverter.TEXT_FIELD_HTML_FORMAT);
				var computedTextFlowString:String = String(TextConverter.export(computedTextFlow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE));
				//computedTextFlow = TextConverter.importToFlow(htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
				//var computedTextFlowString2:String = String(TextConverter.export(computedTextFlow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE));
				textFlow = computedTextFlow;
				//selectableChanged = true;
				//htmlTextChanged = false;
			}*/
			
			
			/*if (selectableChanged) {
				
				if (textFlow) {
					//textFlow.interactionManager = new SelectionManager();
					//textFlow.flowComposer.updateAllControllers();
				}
				selectableChanged = false;
			}*/
			
		}

	}
}