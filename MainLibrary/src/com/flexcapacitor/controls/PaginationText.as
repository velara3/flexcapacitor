package com.flexcapacitor.controls
{
	import com.flexcapacitor.controls.supportClasses.PaginationWidget;
	import com.flexcapacitor.formatters.HTMLFormatterTLF;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.core.UIComponent;
	
	import spark.events.IndexChangeEvent;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
/**
 *  The name of the font to use, or a comma-separated list of font names. 
 * 
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontFamily.</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontFamily,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontFamily.</b></p>
 * 
 *  <p>The default value for the Spark theme is <code>Arial</code>.
 *  The default value for the Mobile theme is <code>_sans</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontFamily
 *  @see spark.components.supportClasses.StyleableStageText#style:fontFamily
 *  @see spark.components.supportClasses.StyleableTextField#style:fontFamily
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="fontFamily", type="String", inherit="yes")]

	/**
	 * Creates a multicolumn text flow
	 * 
	 	&lt;c:PaginationText id="textBox" left="20" right="20" width="100%" height="100%"
					  htmlText="{instructions}"
					  selectable="false"
					  replaceLinebreaksWithBreaks="true"/>
					   
	**/
	/**
	 * This is an adaptation of an TLF SDK example found online
	 * */
	public class PaginationText extends UIComponent {
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 */
		public function PaginationText() {
			XML.ignoreWhitespace = false;
			
			if (stage) {
				setup();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, addToStage, false, 0, true);
			}
			setup();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Comment
		 */
		private var textFlowChanged:Boolean;
		
		/**
		 *  @private
		 *  Comment
		 */
		private var htmlTextChanged:Boolean;
		
		/**
		 *  @private
		 *  Comment
		 */
		private var textFlowTextChanged:Boolean;
		
		/**
		 *  @private
		 *  Comment
		 */
		private var updatedHTMLText:String;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Comment
		 */
		public var chapters:Array;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public var pageView:PaginationWidget;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public var currentChapter:int;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public var config:Configuration;
		
		// some configuration values - ContainerFormat for all containers and constraints on container width
		private var _containerFormat:TextLayoutFormat;

		public function get containerFormat():TextLayoutFormat {
			return _containerFormat;
		}

		public function set containerFormat(value:TextLayoutFormat):void {
			_containerFormat = value;
			pageView.containerFormat = value;
		}

		
		/**
		 *  @private
		 *  Comment
		 * */
		public var contents:Array = []; // chapters
		
		
		/**
		 *  @private
		 *  Comment
		 * */
		[Bindable] public var currentPage:int;
		
		/**
		 *  @private
		 *  Comment
		 * */
		[Bindable] public var totalPages:int;
		
		//----------------------------------
		//  htmlText
		//----------------------------------
		
		private var _htmlText:String;
		
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function get htmlText():String {
			return _htmlText;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function set htmlText(value:String):void {
			_htmlText = value;
			htmlTextChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  textFlow
		//----------------------------------
		
		
		private var _textFlow:TextFlow;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function get textFlow():TextFlow {
			return _textFlow;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function set textFlow(value:TextFlow):void {
			_textFlow = value;
			textFlowChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  textFlowText
		//----------------------------------
		
		private var _textFlowText:String;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function get textFlowText():String {
			return _textFlowText;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function set textFlowText(value:String):void {
			_textFlowText = value;
			textFlowTextChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  replaceLinebreaksWithBreaks
		//----------------------------------
		private var _replaceLinebreaksWithBreaks:Boolean;
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function get replaceLinebreaksWithBreaks():Boolean {
			return _replaceLinebreaksWithBreaks;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function set replaceLinebreaksWithBreaks(value:Boolean):void {
			_replaceLinebreaksWithBreaks = value;
			HTMLFormatterTLF.staticInstance.replaceLinebreaks = value;
		}
		
		//----------------------------------
		//  selectable
		//----------------------------------
		private var _selectable:Boolean;
		private var selectableChanged:Boolean;

		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			selectableChanged = true;
			invalidateProperties();
		}
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			var currentFormat:TextLayoutFormat = pageView.containerFormat;
			
			currentFormat.fontFamily = getStyle('fontFamily');
			pageView.containerFormat = currentFormat;
			pageView.containerFormat.setStyle("fontFamily", getStyle("fontFamily"));
			if (pageView.textFlow) {
				pageView.recomputeContainers();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Comment
		 * */
		public function setup():void {
			pageView = new PaginationWidget();
			pageView.addEventListener(IndexChangeEvent.CHANGE, pageChangeHandler);
			pageView.addEventListener(PaginationWidget.PAGE_COUNT_CHANGE, totalPagesChangeHandler);
			
			addChild(pageView);
			
			// update the display on resize
			//systemManager.getTopLevelRoot().stage.
			// we can move this to updateDisplayList?
			addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			
			// keyboard navigation
			if (!stage) {
				addEventListener(Event.ADDED_TO_STAGE, addKeyBoardHandler, false, 0, true);
			}
		
			// Configuration passed to any TextFlows the default importer is importing
			config = TextFlow.defaultConfiguration;
			config.inactiveSelectionFormat = config.focusedSelectionFormat;
			config.unfocusedSelectionFormat  = config.focusedSelectionFormat;
			//config.textFlowInitialFormat.fontFamily = getStyle("fontFamily");
			chapters = new Array(contents.length);
			
			//setChapter(0);
		}
		
		/**
		 * Go to the last page of the current textFlow.
		 * */
		public function lastPage():void {
			
			if (pageView) {
				pageView.lastPage();
			}
		}
		
		/** 
		 * Go to the next page of the current textFlow. 
		 * */
		public function nextPage():void {
			
			if (pageView) {
				pageView.nextPage();
			}
		}
		
		/** 
		 * Go to the previous page of the current textFlow. 
		 * */
		public function prevPage():void { 
			
			if (pageView) {
				pageView.prevPage();
			}
		}
		
		/** 
		 * Go to the first page of the current textFlow. 
		 * */
		public function firstPage():void { 
			
			if (pageView) {
				pageView.firstPage();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Comment
		 * */
		protected function pageChangeHandler(event:IndexChangeEvent):void {
			currentPage = PaginationWidget(event.currentTarget).page;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		protected function totalPagesChangeHandler(event:Event):void {
			totalPages = PaginationWidget(event.currentTarget).pageCount;
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		protected function addKeyBoardHandler(event:Event):void {
			systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		}
		
		/**
		 *  @private
		 *  Comment
		 * */
		private function setChapter(chapterNumber:int):void {
			currentChapter = chapterNumber;
			
			var textFlow:TextFlow = chapters[currentChapter];
			
			if (textFlow == null) {
				textFlow = TextConverter.importToFlow(contents[chapterNumber], TextConverter.TEXT_LAYOUT_FORMAT, config);
				chapters[currentChapter] = textFlow;
				
				var ca:TextLayoutFormat = new TextLayoutFormat(textFlow.format);
				ca.fontFamily = getStyle("fontFamily");//"Georgia, Times";
				ca.fontSize = getStyle("fontSize");//16
				ca.textIndent = getStyle("fontSize");//15;
				ca.paragraphSpaceAfter = getStyle("paragraphSpaceAfter");//10;
				ca.textAlign = getStyle("textAlign");//TextAlign.JUSTIFY;
				textFlow.format = ca;
			}
			
			pageView.textFlow = textFlow;
		}
		
		//----------------------------------
		//  prevChapter
		//----------------------------------
		
		public function prevChapter():void {
			if (currentChapter > 0)
				setChapter(currentChapter-1);
		}
		
		//----------------------------------
		//  nextChapter
		//----------------------------------
		
		public function nextChapter():void {
			if (currentChapter >= 0 && currentChapter < contents.length-1) {
				setChapter(currentChapter+1);
			}
		}
		
		//----------------------------------
		//  resizeHandler
		//----------------------------------
		
		/**
		 *  @private
		 *  Comment
		 * */
		private function resizeHandler(event:Event):void {
			//pageView.setSize(stage.stageWidth-this.x,stage.stageHeight-this.y);
			pageView.setSize(width, height);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  commitProperties
		//----------------------------------
		
		/**
		 *  @private
		 *  Comment
		 * */
		override protected function commitProperties():void {
			super.commitProperties();
			var ca:TextLayoutFormat;
			
			if (textFlowTextChanged) {
				textFlow = TextConverter.importToFlow(textFlowText, TextConverter.TEXT_LAYOUT_FORMAT, config);
				//chapters[currentChapter] = textFlow;
				
				ca = new TextLayoutFormat(textFlow.format);
				ca.fontFamily = "Georgia, Times";
				ca.fontSize = 16;
				ca.textIndent = 15;
				//ca.paragraphSpaceAfter = 10;
				ca.textAlign = TextAlign.JUSTIFY;
				
				textFlow.format = ca;
			
				pageView.textFlow = textFlow;
				textFlowTextChanged = false;
			}
			
			if (htmlTextChanged) {
				updatedHTMLText = HTMLFormatterTLF.staticInstance.format(htmlText);
				textFlow = TextConverter.importToFlow(updatedHTMLText, TextConverter.TEXT_FIELD_HTML_FORMAT, config);
				
				ca = new TextLayoutFormat(textFlow.format);
				ca.fontFamily = "Georgia, Times";
				ca.fontSize = 16;
				ca.textIndent = 15;
				ca.paragraphSpaceAfter = 0;
				ca.textAlign = TextAlign.JUSTIFY;
				
				textFlow.format = ca;
				pageView.textFlow = textFlow;
				htmlTextChanged = false;
			}
			
			if (selectableChanged) {
				if (_textFlow) {
					pageView.selectable = selectable;
					selectableChanged = false;
				}
			}
		}
		
		
		//----------------------------------
		//  keyDownHandler
		//----------------------------------
		
		/** 
		 * Handle Key events that change the current page or chapter
		 * */
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
			if (event.charCode == 0 && event.shiftKey) {
				
				// the keycodes that we currently handle
				switch(event.keyCode) {
					case Keyboard.PAGE_UP:
						prevChapter();
						event.preventDefault();
						return;
					case Keyboard.PAGE_DOWN:
						nextChapter();
						event.preventDefault();
						return;
				}
			}
			
			pageView.processKeyDownEvent(event);
		}
		
		
		//----------------------------------
		//  addToStage
		//----------------------------------
		
		/** 
		 * Handle Key events that change the current page or chapter
		 * */
		protected function addToStage(event:Event):void {
			pageView.setSize(width, height);
			systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		}
	}
}