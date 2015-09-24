




package com.flexcapacitor.graphics {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.graphics.SolidColorStroke;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	
	import spark.components.Group;
	import spark.primitives.Line;

	/**
	 * Draws an outline around the target object
	 * */
	public class LayoutLines {
		
		public var backgroundFillAlpha:Number = 0;
		public var backgroundFillColor:uint = 0x000000;
		public var lineAlpha:Number = 1;
		public var lineColor:uint = 0x2da6e9;
		public var horizontalOffset:int = -5;
		public var verticalOffset:int = -5;
		public var lineThickness:int = 1;
		public var group:Group;
		
		public function LayoutLines() {
			
		}
		private static var _instance:LayoutLines;
		
		public static function getInstance():LayoutLines {
			
			if (_instance!=null) {
				return _instance;
			}
			else {
				_instance = new LayoutLines();
				return _instance;
			}
		}
		
		/**
		 * Reference to LayoutLines instance
		 * */
		public static function get instance():LayoutLines {
			
			if (_instance==null) {
				_instance = new LayoutLines();
			}
			return _instance;
		}
		
		/**
		 * Draws an outline around the target object
		 * */
		public function drawLines(target:Object, systemManager:ISystemManager):void {
			var point:Point;
			var targetWidth:int;
			var targetHeight:int;
			var displayObject:DisplayObject;
			
			if (target == null) {
				if (group) {
					group.graphics.clear();
				}
				return;
			}
			
			if (systemManager!=null) {
				var isPopUp:Boolean;// = target is UIComponent ? UIComponent(target).isPopUp : false;
				
				// if we add to the application we won't show on pop up manager elements
				if (group==null || group.parent==null) {
					group = new Group();
					group.mouseEnabled = false;
					
					systemManager.addChild(DisplayObject(group));
				}
				else {
					group.graphics.clear();
				}
			}
			else {
				return;
			}
			
			if (!(target is DisplayObject)) {
				return;
			}
			displayObject = DisplayObject(target);
			
			targetWidth = displayObject.width;
			targetHeight = displayObject.height;
			
			point = new Point();
			point = displayObject.localToGlobal(point);
			
			var topOffset:Number = 0 - (lineThickness / 2);
			var leftOffset:Number = 0 - (lineThickness / 2);
			var rightOffset:Number = targetWidth + 0 - (lineThickness / 2);
			var bottomOffset:Number = targetHeight + 0 - (lineThickness / 2);
			
			// move group to new location
			group.x = point.x;
			group.y = point.y;
			
			// add a background fill
			group.graphics.beginFill(backgroundFillColor, backgroundFillAlpha);
			group.graphics.drawRect(0, 0, targetWidth, targetHeight);
			group.graphics.endFill();
			
			// adds a thin line at the top
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(horizontalOffset, topOffset, targetWidth + 10, lineThickness);
			group.graphics.endFill();
			
			// adds a thin line to the bottom of the spacer
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(horizontalOffset, bottomOffset, targetWidth + 10, lineThickness);
			group.graphics.endFill();
			
			// adds a thin line to the left
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(leftOffset, verticalOffset, lineThickness, targetHeight + 10);
			group.graphics.endFill();
			
			// adds a thin line to the right
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(rightOffset, verticalOffset, lineThickness, targetHeight + 10);
			group.graphics.endFill();
		}
		
		public function drawLines2(target:DisplayObject, groupTarget:DisplayObject = null):void {
			var point:Point;
			var targetWidth:int;
			var targetHeight:int;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (target == null) 
				return;
			
			if (systemManager!=null) {
				
				if (group==null) {
					group = new Group();
					group.mouseEnabled = false;
					systemManager.addChild(DisplayObject(group));
				}
				else {
					group.removeAllElements();
				}
			}
			else {
				return;
			}
			
			targetWidth = DisplayObject(target).width;
			targetHeight = DisplayObject(target).height;
			
			point = new Point();
			point = DisplayObject(target).localToGlobal(point);
			
			var topLine:Line = new Line();
			var bottomLine:Line = new Line();
			var leftLine:Line = new Line();
			var rightLine:Line = new Line();
			
			var stroke:SolidColorStroke = new SolidColorStroke();
			stroke.color = lineColor;
			stroke.alpha = lineAlpha;
			topLine.stroke = stroke;
			bottomLine.stroke = stroke;
			leftLine.stroke = stroke;
			rightLine.stroke = stroke;
			
			topLine.xFrom = 0;
			topLine.xTo = systemManager.width;
			topLine.y = point.y - (lineThickness / 2);
			
			bottomLine.xFrom = 0;
			bottomLine.xTo = systemManager.width;
			bottomLine.y = point.y + targetHeight - (lineThickness / 2);
			
			leftLine.x = point.x - (lineThickness / 2);
			leftLine.yFrom = 0;
			leftLine.yTo = systemManager.height;
			
			rightLine.x = point.x + targetWidth - (lineThickness / 2);
			rightLine.yFrom = 0;
			rightLine.yTo = systemManager.height;

			group.addElement(topLine);
			group.addElement(bottomLine);
			group.addElement(leftLine);
			group.addElement(rightLine);
			
			if (group.parent!=systemManager) {
				systemManager.addChild(group);
			}
			
		}
		
		/**
		 * Clears the outline 
		 * */
		public function clear(target:Object, systemManager:ISystemManager, remove:Boolean=false):void {
			
			if (group) {
				group.graphics.clear();
				
				if (remove) {
					
					if (systemManager.contains(group)) {
						systemManager.removeChild(group);
					}
				}
			}
			
		}
		
		public function remove(target:Object, groupTarget:Object=null):void {
			var application:Object = FlexGlobals.topLevelApplication;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (systemManager) {
				
				if (group && group.parent==systemManager) {
					group.graphics.clear();
					systemManager.removeChild(group);
				}
			}
			
			if (application) {
				
				if (group && group.parent==application) {
					group.graphics.clear();
					application.removeChild(group);
				}
			}
		}
		
		public function clear2(target:Object, groupTarget:Object=null):void {
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (systemManager) {
				
				if (group!=null) {
					group.graphics.clear();
				}
			}
		}
		
	}
}