////////////////////////////////////////////////////////////////////////////////
//
// ADOBE SYSTEMS INCORPORATED
// Copyright 2007-2010 Adobe Systems Incorporated
// All Rights Reserved.
//
// NOTICE:  Adobe permits you to use, modify, and distribute this file 
// in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
﻿package com.flexcapacitor.controls.supportClasses {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import spark.events.IndexChangeEvent;
	
	/**
	 * Dispatched when a page changes
	 * */
	[Event(name="change", type="spark.events.IndexChangeEvent")]
	
	/**
	 * Dispatched when the page count changes
	 * */
	[Event(name="pageCountChange", type="flash.events.Event")]
	
	public class PaginationWidget extends Sprite {
		
		public function PaginationWidget() {
			_currentPage = -1;
			_curPosition = 0;
			_pageList = new Array();
			
			// all containers formatted this way
			containerFormat = new TextLayoutFormat();
			containerFormat.columnCount = 1;
			containerFormat.paddingTop = paddingTop;
			containerFormat.paddingBottom = paddingBottom;
			containerFormat.paddingLeft = paddingLeft;
			containerFormat.paddingRight = paddingRight;
			
			_containersToShow = 0;
			
			this.focusRect = false;
		}
		
		public static var PAGE_COUNT_CHANGE:String = "pageCountChange";
		
		public static var CHANGE:String = "change";
		
		private var inRecomputeContainers:Boolean;
		
		// width and height this widget should use
		private var _width:int;
		private var _height:int;
		
		// current textflow, the list of pages and current page and display position
		private var _textFlow:TextFlow;
		private var _pageList:Array;
		private var _currentPage:int;
		private var _page:int;
		

		private var _curPosition:int;	// really the first visible character - during resize keep this in view
		
		// some configuration values - ContainerFormat for all containers and constraints on container width
		private var _containerFormat:TextLayoutFormat;

		public function get containerFormat():TextLayoutFormat {
			return _containerFormat;
		}

		public function set containerFormat(value:TextLayoutFormat):void {
			_containerFormat = value;
			if (_textFlow) {
				recomputeContainers();
			}
		}

		private const _minContainerWidth:int = 100;
		private const _maxContainerWidth:int = 10000;
		
		// derived values - based on width/height compute these values
		private var _containerHeight:int;
		private var _containerWidth:int;
		private var _containersToShow:int;
		private var _containerMargin:Number;
		
		public var paddingLeft:int = 0;
		public var paddingRight:int = 20;
		public var paddingTop:int = 0;
		public var paddingBottom:int = 0;
		
		public var containerMargin:int = 0;
		
		public var columnCountThresholds:Array = [350, 700, 1050];
		
		private var _pageCount:int;

		public function get pageCount():int {
			var count:int = _containersToShow ? Math.ceil(_pageList.length/_containersToShow):1;
			return count;
		}
		
		[Bindable]
		public function set pageCount(value:int):void {
			_pageCount = value;
		}
		
		[Bindable]
		public function get page():int {
			var count:int = Math.max(1, (_currentPage/_containersToShow)+1);
			return count;
		}
		
		public function set page(value:int):void {
			_page = value;
		}
		
		private var _selectable:Boolean = true;
		private var selectableChanged:Boolean;

		public function get selectable():Boolean {
			return _selectable;
		}

		public function set selectable(value:Boolean):void {
			_selectable = value;
			
			if (value) {
				if (_textFlow) {
					_textFlow.interactionManager = new SelectionManager();
					_textFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, selectionChangeEvent);
				}
			}
			else {
				if (_textFlow) {
					_textFlow.interactionManager = null;
					_textFlow.removeEventListener(SelectionEvent.SELECTION_CHANGE, selectionChangeEvent);
				}
			}
		}

		
		/** 
		 * Sets a new width and height into the widget.  
		 * Uses simple heuristics to decide how big the containers are and how many are visible.
		 * Don't resize the containers on every size change - instead wait for a larger change 
		 */
		public function setSize(w:int, h:int):void {
			if (w == _width && h == _height) return;
			
			_width = w;
			_height = h;
			
			var newContainerMargin:int = containerMargin;
			
			// width <= 250 one column
			// width <= 500 two columns
			// width <= 1000 three columns
			// width > 1000 four colunmns
			var newContainersToShow:int = 0;
			
			if (_width <= columnCountThresholds[0]) {
				newContainersToShow = 1;
			}
			else if (_width <= columnCountThresholds[1]) {
				newContainersToShow = 2;
			}
			else if (_width <= columnCountThresholds[2]) {
				newContainersToShow = 3;
			}
			else {
				newContainersToShow = 4;
			}
			
			var newContainerHeight:int = _height;
			var newContainerWidth:int = Math.max((_width-2*newContainerMargin)/newContainersToShow, _minContainerWidth);

			// only change if things go out of view or height changes by more than one line - call it 12
			// this is a heuristic that can be easily refined.  the goal is to not reflow the text every time things change just a little to give much smoother performance
			if (newContainersToShow != _containersToShow || Math.abs(_containerWidth-newContainerWidth)>36 || Math.abs(newContainerHeight-_containerHeight) > 12 || (_containerMargin + _containerWidth * _containersToShow) > _width) { 
				_containerWidth = newContainerWidth;
				_containerHeight = newContainerHeight;
				_containersToShow = newContainersToShow;
				_containerMargin = newContainerMargin;
				
				if (_textFlow) {
					recomputeContainers();
					goToCurrentPosition(true);
				}
			}
			else {
				// decided not to recompose but lets redo the margins so things look nice
				newContainerMargin = Math.max((_width - _containersToShow * _containerWidth) / 2.0,0);
				
				if (newContainerMargin != _containerMargin) {
					var savePage:int = _currentPage;
					_containerMargin = newContainerMargin;
					goToPage(-1, false);
					goToPage(savePage, false);
				}
			}
		}
		
		/** The worker function.  Reflows based on the parameters computed in setSize */
		public function recomputeContainers():void {
			var controller:ContainerController;
			var oldPageCount:int;
			var index:int;	// scratch
			
			inRecomputeContainers = true;

			// clear list of pages
			_pageList.splice(0);
			
			// resize existing containers
			for (index = 0; index < _textFlow.flowComposer.numControllers; index++) {
				_textFlow.flowComposer.getControllerAt(index).setCompositionSize(_containerWidth, _containerHeight);
			}

			
			for (;;) {
				
				// compose the current chain of containers
				if (_textFlow.flowComposer.numControllers) {
					_textFlow.flowComposer.compose();
					
					// add just the containers with content to pageList.  Stop at first empty container or when all text is placed
					while (_pageList.length < _textFlow.flowComposer.numControllers) {
						controller = _textFlow.flowComposer.getControllerAt(_pageList.length);
						_pageList.push(Sprite(controller.container));
						
						if (controller.textLength == 0 || controller.absoluteStart + controller.textLength >= _textFlow.textLength) {
							// all the text has fit into the containers.  now display the textlines and done
							_textFlow.flowComposer.updateAllControllers();
							inRecomputeContainers = false;
							
							
							if (_pageList.length!=oldPageCount) {
								if (hasEventListener(PAGE_COUNT_CHANGE)) {
									dispatchEvent(new Event(PAGE_COUNT_CHANGE));
								}
							}
							
							return;
						} 
					}
				}
				
				// create new containers in batches - 10 at a time
				for (index = 0; index < 10; index++) {
					controller = new MyDisplayObjectContainerController(new Sprite(),_containerWidth,_containerHeight, this);
					controller.horizontalScrollPolicy = ScrollPolicy.OFF;
					controller.verticalScrollPolicy = ScrollPolicy.OFF;
					controller.format = containerFormat;
					
					_textFlow.flowComposer.addController(controller);
				}
			}
		}
		
		
		/** The TextFlow to display */
		public function get textFlow():TextFlow { 
			return _textFlow;
		}
		
		public function set textFlow(newFlow:TextFlow):void {
			
			// clear any old flow if present
			if (_textFlow) {
				_textFlow.interactionManager = null;
				goToPage(-1, false);
				_textFlow.flowComposer.removeAllControllers();
				_textFlow.removeEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, graphicStatusChangeEvent);	
				_textFlow.removeEventListener(SelectionEvent.SELECTION_CHANGE, selectionChangeEvent);
				_textFlow.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, compositionDoneEvent);
				_textFlow = null;
			}
			
			_textFlow = newFlow;
			
			if (_textFlow) {
				// Disable the interactionManager
				// _textFlow.interactionManager = new EditManager();
				// _textFlow.interactionManager.selectRange(0,0);

				// setup event listener ILG loaded
				_textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, graphicStatusChangeEvent);	
				_textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, compositionDoneEvent);
				
				if (selectable) {
					_textFlow.interactionManager = new SelectionManager();
					_textFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, selectionChangeEvent);
				}
				
				recomputeContainers();
				goToPage(0);
			}
		}
		
		/** Receives an event any time an ILG with a computed size finishes loading. */
 		private function graphicStatusChangeEvent(event:StatusChangeEvent):void {
			
			// recompose if the evt is from an element in this textFlow
			if (_textFlow && event.element.getTextFlow() == _textFlow) {
				recomputeContainers();
				goToCurrentPosition();
			}
		}
		
		private function selectionChangeEvent(e:SelectionEvent):void {
			goToCurrentPosition();
		}
		
		private function compositionDoneEvent(evt:CompositionCompleteEvent):void {
			
			if (inRecomputeContainers) return;
			
			// is the entire flow in a container
			var lastLine:TextFlowLine = _textFlow.flowComposer.getLineAt(_textFlow.flowComposer.numLines-1);
			
			if (lastLine.controller == null || _textFlow.flowComposer.findControllerIndexAtPosition(lastLine.absoluteStart) != _pageList.length-1) {
				recomputeContainers();
				goToCurrentPosition();
			}
		}
		
		/**
		 * Go to the first page of the current textFlow. 
		 * */
		public function firstPage():void { 
			if (_currentPage != -1 &&_pageList.length) {
				goToPage(0);
			}
		}
		
		/**
		 * Go to the last page of the current textFlow.
		 * */
		public function lastPage():void {
			
			if (_currentPage != -1 && _pageList.length) {
				goToPage(_pageList.length-1);
			}
		}
		
		/** Go to the next page of the current textFlow. */
		public function nextPage():void {
		
			if (_currentPage != -1) {
				goToPage(_currentPage + _containersToShow);
			}
		}
		
		/** Go to the previous page of the current textFlow. */
		public function prevPage():void { 
			
			if (_currentPage != -1) {
				goToPage(Math.max(0, _currentPage-_containersToShow));
			}
		}
		
		private function goToCurrentPosition(alwaysgo:Boolean = false):void {
			var activePosition:int = _textFlow.interactionManager ? _textFlow.interactionManager.activePosition : _curPosition;
			
			var pageToShow:int = _textFlow.flowComposer.findControllerIndexAtPosition(activePosition,activePosition == _textFlow.textLength);
			pageToShow = Math.max(0, Math.min(pageToShow, _pageList.length-_containersToShow));	
			
			// if its already visible do nothing
			if (alwaysgo || _currentPage == -1 || _currentPage > pageToShow || _currentPage+_containersToShow <= pageToShow) {
				goToPage(-1, false);						
				goToPage(pageToShow, false);
				
				if (_textFlow.interactionManager)
					_textFlow.interactionManager.refreshSelection();
			}
		}
		
		/** 
		 * Go to a specific page.
		 * @param pageNum - page to go to
		 * @param updateCurPosition - remember first character so that on resize that character stays in view.
		 */
		public function goToPage(pageNumber:int, updateCurrentPosition:Boolean = true):void {
			var oldIndex:int = _currentPage;
			var newIndex:int = pageNumber;
			
			if (pageNumber >= _pageList.length) {
				return;
				//pageNumber = _pageList.length-1; // causes to show an extra page sometimes when not needed
			}
			
			if (pageNumber != _currentPage) {
				
				while (numChildren) {
					removeChildAt(0);
				}
				
				_currentPage = pageNumber;
				page = _currentPage;
				
				if (_currentPage != -1) {
					
					// now add in the correct number of pages
					var pageAfter:int = Math.min(_pageList.length, _currentPage + _containersToShow);
					var xPosition:Number = _containerMargin;
					
					for (var index:int = _currentPage; index < pageAfter; index++) {
						var pageToShow:Sprite = _pageList[index];
						pageToShow.x = xPosition;
						addChild(pageToShow);
						xPosition += _containerWidth;
					}
				}
				
				
				if (hasEventListener(IndexChangeEvent.CHANGE)) {
					dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldIndex, newIndex));
				}
			}
			
			// focus on the first page
			if (stage) {
				stage.focus = _currentPage == -1 ? null : _pageList[_currentPage];
			}
			
			if (updateCurrentPosition) {
				_curPosition = _currentPage == -1 ? 0 : _textFlow.flowComposer.getControllerAt(_currentPage).absoluteStart;
			}
		}
		
		/** KeyDown helper function for keyboard navigation.
		 * @returns true --> keyboard event handled here. */
		public function processKeyDownEvent(e:KeyboardEvent):Boolean {
			
			if (e.charCode == 0 && !e.shiftKey) {	
				
				// the keycodes for navigating within a TextFlow
				switch(e.keyCode) {
					case Keyboard.LEFT:
					case Keyboard.UP:
					case Keyboard.PAGE_UP:
							prevPage();
							return true;
					case Keyboard.RIGHT:
					case Keyboard.DOWN:
					case Keyboard.PAGE_DOWN:
							nextPage();
							return true;
					case Keyboard.HOME:
							firstPage();
							return true;
					case Keyboard.END:
							lastPage();
							return true;
				}
			}
			
			return false;
		}
	}
}

import com.flexcapacitor.controls.supportClasses.PaginationWidget;

import flash.display.Sprite;
import flash.events.KeyboardEvent;

import flashx.textLayout.container.ContainerController;

/** overrides processKeyDownEvent to add keyboard navigation */
class MyDisplayObjectContainerController extends ContainerController {
	private var _widget:PaginationWidget;
	
	public function MyDisplayObjectContainerController(container:Sprite, compositionWidth:Number, compositionHeight:Number, widget:PaginationWidget) {
		super(container, compositionWidth, compositionHeight);
		_widget = widget;
	}
	
	
	public override function keyDownHandler(event:KeyboardEvent):void {
		
		if (_widget.processKeyDownEvent(event)) {
			event.preventDefault();
			event.stopImmediatePropagation(); // added to fix 
			return;
		}
		
		super.keyDownHandler(event);
	}
}
